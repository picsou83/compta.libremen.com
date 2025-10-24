# --------------- COUCHE OS -------------------
FROM debian:bullseye-slim

# MÉTADONNÉES DE L'IMAGE
LABEL version="1.14" maintainer="Picsou83 <picsou83@gmail.com>"

# VARIABLES TEMPORAIRES
ARG DBNAME="comptalibre"
ARG APACHE_CONF_FILE="/etc/apache2/apache2.conf"
 
# CONFIGURATION TIMEZONE AND LOCALE 
RUN apt-get update && apt-get install -q -y libterm-readkey-perl locales && \ 
echo "LC_ALL=fr_FR.UTF-8" >> /etc/environment && \ 
echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf && \ 
locale-gen fr_FR.UTF-8

# CONFIGURATION DU FUSEAU HORAIRE
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# INSTALLATION DES PACKETS
RUN apt-get update && apt-get install -q -y \
	openssh-server sudo apache2 \
	php php-pgsql php-mbstring swaks \
	libapache-dbi-perl libapache2-request-perl libpdf-api2-perl \
	libdbd-pg-perl libapache-session-perl libjson-perl libmime-tools-perl vim poppler-utils supervisor && \
	apt-get update && apt-get install -q -y \
	postgresql && \
	apt-get clean && \ 
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
	
# COPIE DES FICHIERS LOCAUX
COPY adminer.php ${DOCUMENTROOT}
COPY compta.conf /etc/apache2/sites-available
COPY wsl.conf /etc/
COPY compta.sql /tmp/
COPY comptalibre-server.tar.gz /tmp/
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD create.sh /create.sh
ADD start.sh /start.sh
RUN ln -s /etc/apache2/sites-available/compta.conf /etc/apache2/sites-enabled/
RUN chmod 775 /*.sh

# PREPARATION SSH
RUN echo 'root:comptalibre' |chpasswd
RUN sed -ri 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config && \
	mkdir -p /var/run/sshd
EXPOSE 22

# Décommenter et ajouter l'adresse IPv4 '127.0.0.1' dans le fichier postgresql.conf
RUN sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '127.0.0.1'/g" /etc/postgresql/13/main/postgresql.conf

# PREPARATION APACHE
RUN sed -ri 's/ServerTokens OS/ServerTokens Prod/' /etc/apache2/*/security.conf && \
	sed -ri 's/ServerSignature On/ServerSignature Off/' /etc/apache2/conf-available/security.conf && \
	sed -ri 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/1!g' /etc/apache2/sites-available/*.conf && \
	sed -ri 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' /etc/apache2/apache2.conf && \
	rm /var/www/html/index.html && \
	echo "ServerName localhost" >> /etc/apache2/sites-available/000-default.conf && \
	echo "RedirectMatch "^/$" /base" >> /etc/apache2/sites-available/000-default.conf && \
	sudo a2dismod --force autoindex && \
	sudo a2dismod autoindex && \
	sudo a2dismod status
EXPOSE 80

# Modifier le fichier ImagePNG.pm avec sed, mais seulement si la modification n'a pas encore été faite
RUN if ! grep -q 'use parent "Exporter";' /usr/lib/x86_64-linux-gnu/perl5/5.32/PDF/API2/XS/ImagePNG.pm; then \
    sed -i '/^package PDF::API2::XS::ImagePNG;/a\use parent "Exporter";\nour @EXPORT = qw(split_channels unfilter);' \
    /usr/lib/x86_64-linux-gnu/perl5/5.32/PDF/API2/XS/ImagePNG.pm; \
fi

# RÉPERTOIRE DE TRAVAIL
WORKDIR /var/www/html

# EXECUTION DU SCRIPT CREATE A LA CREATION DE L'IMAGE
RUN ["/create.sh"]

# EXECUTION DU SCRIPT ET DES SERVICES AU DEMARRAGE DU CONTENEUR
ENTRYPOINT ["/bin/sh", "-c", "/start.sh && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]


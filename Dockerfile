# --------------- COUCHE OS -------------------
FROM debian:bullseye-slim

# MÉTADONNÉES DE L'IMAGE
LABEL version="1.10" maintainer="Picsou83 <picsou83@gmail.com>"

# VARIABLES TEMPORAIRES
ARG DBNAME="comptalibre"
ARG APACHE_CONF_FILE="/etc/apache2/apache2.conf"
 
# CONFIGURATION TIMEZONE AND LOCALE 
RUN apt-get update && apt-get install -q -y libterm-readkey-perl locales && \ 
echo "LC_ALL=fr_FR.UTF-8" >> /etc/environment && \ 
echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \ 
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf && \ 
locale-gen fr_FR.UTF-8

# INSTALLATION DES PACKETS
RUN apt-get update && apt-get install -q -y \
	openssh-server sudo apache2 \
	php php-pgsql php-mbstring \
	libapache-dbi-perl libapache2-request-perl libpdf-api2-perl \
	libdbd-pg-perl libapache-session-perl libmime-tools-perl vim && \
	apt-get update && apt-get install -q -y \
	postgresql && \
	apt-get clean && \ 
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# COPIE DES FICHIERS LOCAUX
COPY adminer.php ${DOCUMENTROOT}
COPY compta.conf /etc/apache2/sites-available
COPY compta.sql /tmp/
COPY comptalibre-server.tar.gz /tmp/
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

# RÉPERTOIRE DE TRAVAIL
WORKDIR /var/www/html

# EXECUTION DU SCRIPT CREATE A LA CREATION DE L'IMAGE
RUN ["/create.sh"]

# EXECUTION DU SCRIPT ET DES SERVICES AU DEMARRAGE DU CONTENEUR
ENTRYPOINT /start.sh && service postgresql start && /usr/sbin/sshd && apache2ctl -D FOREGROUND

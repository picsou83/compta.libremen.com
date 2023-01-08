--
-- PostgreSQL database dump
--

-- Dumped from database version 13.7 (Debian 13.7-0+deb11u1)
-- Dumped by pg_dump version 13.7 (Debian 13.7-0+deb11u1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: calcul_balance(integer, integer, date, integer, integer, text); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.calcul_balance(integer, integer, date, integer, integer, text, OUT numero_compte text, OUT classe text, OUT libelle_compte text, OUT debit text, OUT credit text, OUT solde_debit text, OUT solde_credit text, OUT classe_total_debit text, OUT classe_total_credit text, OUT classe_total_debit_solde text, OUT classe_total_credit_solde text, OUT grand_total_debit text, OUT grand_total_credit text, OUT grand_total_debit_solde text, OUT grand_total_credit_solde text, OUT classe_total_credit_solde_dif text, OUT classe_total_debit_solde_dif text) RETURNS SETOF record
    LANGUAGE sql STABLE
    AS $_$
	    with t1 as (
SELECT numero_compte, sum(debit)/100::numeric as debit, sum(credit)/100::numeric as credit, sum(credit - debit)/100::numeric as solde, substring(numero_compte from '^.') as classe
FROM tbljournal 
WHERE id_client = $1 AND fiscal_year = $2 and date_ecriture <= $3 AND libelle_journal NOT LIKE '%CLOTURE%'
GROUP BY numero_compte 
	    ),
	    t2 as (
SELECT numero_compte, substring(numero_compte from '^.') as classe, libelle_compte
FROM tblcompte t2
WHERE id_client = $4 AND fiscal_year = $5
	    ),
	    t3 as (
SELECT t2.numero_compte, t2.classe, t2.libelle_compte, coalesce(t1.debit, 0) as debit, coalesce(t1.credit, 0) as credit, coalesce(t1.solde, 0) as solde
FROM t2 LEFT JOIN t1 ON t1.numero_compte = t2.numero_compte
	    ),
	    t4 as (
SELECT t3.numero_compte, t3.classe, t3.libelle_compte, t3.debit as debit, t3.credit as credit, -least(0, t3.solde) as solde_debit, greatest(0, t3.solde) as solde_credit
FROM t3
	    ), 
	    t5 as (
SELECT t4.numero_compte, t4.classe, t4.libelle_compte, t4.debit, t4.credit, t4.solde_debit, t4.solde_credit, 
sum(t4.debit) over (partition by t4.classe) as classe_total_debit, sum(t4.credit) over (partition by t4.classe) as classe_total_credit, sum(t4.solde_debit) over (partition by t4.classe) as classe_total_debit_solde, sum(t4.solde_credit) over (partition by t4.classe) as classe_total_credit_solde, greatest(0, sum(t4.credit - t4.debit) over (partition by t4.classe)) as classe_total_credit_solde_dif, greatest(0,sum(t4.debit - t4.credit) over (partition by t4.classe)) as classe_total_debit_solde_dif
FROM t4
	    )
	    SELECT t5.numero_compte, t5.classe, t5.libelle_compte, 
	    to_char(t5.debit, $6) as debit, to_char(t5.credit, $6) as credit, to_char(t5.solde_debit, $6) as solde_debit, to_char(t5.solde_credit, $6) as solde_credit, 
	    to_char(t5.classe_total_debit, $6) as classe_total_debit, to_char(t5.classe_total_credit, $6) as classe_total_credit, to_char(t5.classe_total_debit_solde, $6) as classe_total_debit_solde, to_char(t5.classe_total_credit_solde, $6) as classe_total_credit_solde, to_char(sum(t5.debit) over (), $6) as grand_total_credit, to_char(sum(t5.credit) over (), $6) as grand_total_debit, to_char(sum(t5.solde_debit) over (), $6) as grand_total_debit_solde, to_char(sum(t5.solde_credit) over (), $6) as grand_total_credit_solde, to_char(t5.classe_total_credit_solde_dif, $6) as classe_total_credit_solde_dif, to_char(t5.classe_total_debit_solde_dif, $6) as classe_total_debit_solde_dif
	    FROM t5 
	    ORDER by numero_compte;
$_$;


ALTER FUNCTION public.calcul_balance(integer, integer, date, integer, integer, text, OUT numero_compte text, OUT classe text, OUT libelle_compte text, OUT debit text, OUT credit text, OUT solde_debit text, OUT solde_credit text, OUT classe_total_debit text, OUT classe_total_credit text, OUT classe_total_debit_solde text, OUT classe_total_credit_solde text, OUT grand_total_debit text, OUT grand_total_credit text, OUT grand_total_debit_solde text, OUT grand_total_credit_solde text, OUT classe_total_credit_solde_dif text, OUT classe_total_debit_solde_dif text) OWNER TO compta;

--
-- Name: calcul_balance_cloture(integer, integer, date, integer, integer, text); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.calcul_balance_cloture(integer, integer, date, integer, integer, text, OUT numero_compte text, OUT classe text, OUT libelle_compte text, OUT debit text, OUT credit text, OUT solde_debit text, OUT solde_credit text, OUT classe_total_debit text, OUT classe_total_credit text, OUT classe_total_debit_solde text, OUT classe_total_credit_solde text, OUT grand_total_debit text, OUT grand_total_credit text, OUT grand_total_debit_solde text, OUT grand_total_credit_solde text, OUT classe_total_credit_solde_dif text, OUT classe_total_debit_solde_dif text) RETURNS SETOF record
    LANGUAGE sql STABLE
    AS $_$
	    with t1 as (
SELECT numero_compte, sum(debit)/100::numeric as debit, sum(credit)/100::numeric as credit, sum(credit - debit)/100::numeric as solde, substring(numero_compte from '^.') as classe
FROM tbljournal 
WHERE id_client = $1 AND fiscal_year = $2 and date_ecriture <= $3
GROUP BY numero_compte 
	    ),
	    t2 as (
SELECT numero_compte, substring(numero_compte from '^.') as classe, libelle_compte
FROM tblcompte t2
WHERE id_client = $4 AND fiscal_year = $5
	    ),
	    t3 as (
SELECT t2.numero_compte, t2.classe, t2.libelle_compte, coalesce(t1.debit, 0) as debit, coalesce(t1.credit, 0) as credit, coalesce(t1.solde, 0) as solde
FROM t2 LEFT JOIN t1 ON t1.numero_compte = t2.numero_compte
	    ),
	    t4 as (
SELECT t3.numero_compte, t3.classe, t3.libelle_compte, t3.debit as debit, t3.credit as credit, -least(0, t3.solde) as solde_debit, greatest(0, t3.solde) as solde_credit
FROM t3
	    ), 
	    t5 as (
SELECT t4.numero_compte, t4.classe, t4.libelle_compte, t4.debit, t4.credit, t4.solde_debit, t4.solde_credit, 
sum(t4.debit) over (partition by t4.classe) as classe_total_debit, sum(t4.credit) over (partition by t4.classe) as classe_total_credit, sum(t4.solde_debit) over (partition by t4.classe) as classe_total_debit_solde, sum(t4.solde_credit) over (partition by t4.classe) as classe_total_credit_solde, greatest(0, sum(t4.credit - t4.debit) over (partition by t4.classe)) as classe_total_credit_solde_dif, greatest(0,sum(t4.debit - t4.credit) over (partition by t4.classe)) as classe_total_debit_solde_dif
FROM t4
	    )
	    SELECT t5.numero_compte, t5.classe, t5.libelle_compte, 
	    to_char(t5.debit, $6) as debit, to_char(t5.credit, $6) as credit, to_char(t5.solde_debit, $6) as solde_debit, to_char(t5.solde_credit, $6) as solde_credit, 
	    to_char(t5.classe_total_debit, $6) as classe_total_debit, to_char(t5.classe_total_credit, $6) as classe_total_credit, to_char(t5.classe_total_debit_solde, $6) as classe_total_debit_solde, to_char(t5.classe_total_credit_solde, $6) as classe_total_credit_solde, to_char(sum(t5.debit) over (), $6) as grand_total_credit, to_char(sum(t5.credit) over (), $6) as grand_total_debit, to_char(sum(t5.solde_debit) over (), $6) as grand_total_debit_solde, to_char(sum(t5.solde_credit) over (), $6) as grand_total_credit_solde, to_char(t5.classe_total_credit_solde_dif, $6) as classe_total_credit_solde_dif, to_char(t5.classe_total_debit_solde_dif, $6) as classe_total_debit_solde_dif
	    FROM t5 
	    ORDER by numero_compte;
$_$;


ALTER FUNCTION public.calcul_balance_cloture(integer, integer, date, integer, integer, text, OUT numero_compte text, OUT classe text, OUT libelle_compte text, OUT debit text, OUT credit text, OUT solde_debit text, OUT solde_credit text, OUT classe_total_debit text, OUT classe_total_credit text, OUT classe_total_debit_solde text, OUT classe_total_credit_solde text, OUT grand_total_debit text, OUT grand_total_credit text, OUT grand_total_debit_solde text, OUT grand_total_credit_solde text, OUT classe_total_credit_solde_dif text, OUT classe_total_debit_solde_dif text) OWNER TO compta;

--
-- Name: date_is_in_fiscal_year(date, date, date); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.date_is_in_fiscal_year(arg_date date, fiscal_year_start date, fiscal_year_end date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
IF ( arg_date BETWEEN fiscal_year_start AND fiscal_year_end ) THEN RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
END 
$$;


ALTER FUNCTION public.date_is_in_fiscal_year(arg_date date, fiscal_year_start date, fiscal_year_end date) OWNER TO compta;

--
-- Name: date_is_in_fiscal_year_2(date, date, date); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.date_is_in_fiscal_year_2(arg_date date, fiscal_year_start date, fiscal_year_end date) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
IF ( arg_date BETWEEN fiscal_year_start AND fiscal_year_end ) THEN RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
END $$;


ALTER FUNCTION public.date_is_in_fiscal_year_2(arg_date date, fiscal_year_start date, fiscal_year_end date) OWNER TO compta;

--
-- Name: delete_account_data(integer); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.delete_account_data(id_client integer) RETURNS void
    LANGUAGE sql
    AS $_$
update tbljournal set id_export = null where id_client = $1;	
delete from tbllocked_month where id_client = $1;	
delete from tblexport where id_client = $1;	
delete from tbljournal where id_client = $1;
delete from tbljournal_liste where id_client = $1;
delete from tbldocuments where id_client = $1;
delete from tbldocuments_categorie where id_client = $1;
delete from tblcompte where id_client = $1;
delete from tbljournal_liste where id_client = $1;
delete from tbljournal_staging where id_client = $1;
delete from tblcerfa_2_detail where id_entry in (select id_entry from tblcerfa_2 where id_client = $1);
delete from tblcerfa_2 where id_client = $1;
delete from compta_user where id_client = $1 and username != 'superadmin' ;
delete from compta_client where id_client = $1;
$_$;


ALTER FUNCTION public.delete_account_data(id_client integer) OWNER TO compta;

--
-- Name: import_staging(text, integer, date, date); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.import_staging(my_token_id text, my_fiscal_year integer, "my_Exercice_debut_YMD" date, "my_Exercice_fin_YMD" date) RETURNS void
    LANGUAGE plpgsql
    AS $_$
BEGIN
-- vérifier que le total global est équilibré
IF ( not (select sum(credit-debit) from tbljournal_import where _token_id = $1) = 0 ) then RAISE EXCEPTION 'unbalanced total'; END IF;
-- supprimer les champs où débit et crédit sont nulls
delete from tbljournal_import where coalesce(debit, 0) + coalesce(credit, 0) = 0 and _token_id = $1;
-- multiplier par 100 les valeurs en euros, pour les enregistrer en centimes
update tbljournal_import set debit = debit * 100, credit = credit * 100 where _token_id = $1;

--vérifier que les dates sont bien dans l'exercice
if exists (select date_ecriture, id_client
from tbljournal_import
where _token_id = $1 and date_is_in_fiscal_year(date_ecriture, $3, $4) = FALSE
)
then raise exception 'bad fiscal year';
end if;

--vérifier que les numéros de mouvement n'existe pas déjà dans l'exercice
if exists ( select t1.num_mouvement
from tbljournal_import t1 inner join tbljournal t2 using (id_client, fiscal_year) 
where t1.num_mouvement::integer != t2.num_mouvement::integer ) 
then RAISE exception 'bad num mouvement';
END IF ;

-- vérifier que les groupes sont à l'équilibre
if exists (select date_ecriture, id_facture, fiscal_year, id_client, libelle_journal
from tbljournal_import
where _token_id = $1
group by date_ecriture, id_facture, fiscal_year, id_client, libelle_journal
having sum(credit-debit) != 0 )
then RAISE EXCEPTION 'unbalanced group';
end if;
-- générer les id_entry par écriture
with t1 as (
select num_mouvement, date_ecriture, id_paiement, id_facture, fiscal_year, id_client, libelle_journal
from tbljournal_import
where _token_id = $1
group by num_mouvement, date_ecriture, id_paiement, id_facture, fiscal_year, id_client, libelle_journal
ORDER BY num_mouvement, date_ecriture
),
t2 as (
select nextval('tbljournal_id_entry_seq'::regclass) as my_id_entry, date_ecriture as my_date_ecriture, id_paiement as my_id_paiement, id_facture as my_id_facture, fiscal_year as my_fiscal_year, id_client as my_id_client, libelle_journal as my_libelle_journal
from t1
)
update tbljournal_import set id_entry = t2.my_id_entry
from t2
where date_ecriture = t2.my_date_ecriture and (id_facture = t2.my_id_facture or id_facture is null) and (id_paiement = t2.my_id_paiement or id_paiement is null) and fiscal_year = t2.my_fiscal_year and id_client = t2.my_id_client and libelle_journal = t2.my_libelle_journal;

-- pratiquer l'insertion proprement dite
insert into tbljournal (date_ecriture, id_facture, libelle, debit, credit, lettrage, id_entry, id_paiement, numero_compte, fiscal_year, id_client, libelle_journal, pointage, id_export, documents1, documents2, num_mouvement)
select date_ecriture, id_facture, libelle, debit, credit, lettrage, id_entry, id_paiement, numero_compte, fiscal_year, id_client, libelle_journal, pointage, id_export, documents1, documents2, num_mouvement
from tbljournal_import
where _token_id = $1;
-- si l'insertion s'est bien passée, on vide tbljournal_import
delete from tbljournal_import where _token_id = $1;
END;
$_$;


ALTER FUNCTION public.import_staging(my_token_id text, my_fiscal_year integer, "my_Exercice_debut_YMD" date, "my_Exercice_fin_YMD" date) OWNER TO compta;

--
-- Name: record_staging(text, integer); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.record_staging(my_token_id text, my_id_entry integer) RETURNS integer
    LANGUAGE plpgsql
    AS $_$
DECLARE _id_entry integer;
BEGIN
IF ( not (select sum(credit-debit) from tbljournal_staging where _token_id = $1) = 0 ) then RAISE EXCEPTION 'unbalanced'; END IF;
-- supprimer les champs où débit et crédit sont nulls
delete from tbljournal_staging where ( coalesce(debit, 0) + coalesce(credit, 0) = 0 and _token_id = my_token_id);
-- si c'est une nouvelle entrée, id_entry = 0; lui affecter la nouvelle valeur
IF my_id_entry = 0 THEN
update tbljournal_staging set id_entry = (select nextval('tbljournal_id_entry_seq'::regclass)) where id_entry = 0 and _token_id = my_token_id;
ELSE
-- si c'est une mise à jour d'une entrée existante, il faut la supprimer
delete from tbljournal where id_entry = $2;
END IF;
-- pratiquer l'insertion proprement dite
insert into tbljournal (date_ecriture, id_facture, libelle, debit, credit, lettrage, id_line, id_entry, id_paiement, numero_compte, fiscal_year, id_client, libelle_journal, pointage, id_export, documents1, documents2, recurrent)
select date_ecriture, id_facture, libelle, debit, credit, lettrage, id_line, id_entry, id_paiement, numero_compte, fiscal_year, id_client, libelle_journal, pointage, id_export, documents1, documents2, recurrent
from tbljournal_staging where _token_id = $1;
-- si l'insertion s'est bien passée, on vide tbljournal_stagin
with t1 as (delete from tbljournal_staging where _token_id = $1
RETURNING id_entry)
select id_entry from t1 LIMIT 1 INTO _id_entry;
RETURN _id_entry;
END;
$_$;


ALTER FUNCTION public.record_staging(my_token_id text, my_id_entry integer) OWNER TO compta;

--
-- Name: tblcerfa_2_detail_check_compte_not_in_use(); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.tblcerfa_2_detail_check_compte_not_in_use() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if exists (with t1 as (select id_client, fiscal_year from tblcerfa_2 where id_entry = new.id_entry )
select numero_compte from tblcerfa_2_detail where id_entry in (select id_entry from tblcerfa_2 inner join t1 using (id_client, fiscal_year) where id_client = t1.id_client and fiscal_year = t1.fiscal_year) and numero_compte = new.numero_compte)
then RAISE exception 'account already in use'; else return new; END IF ;
END
$$;


ALTER FUNCTION public.tblcerfa_2_detail_check_compte_not_in_use() OWNER TO compta;

--
-- Name: tblcerfa_2_detail_check_numero_compte(); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.tblcerfa_2_detail_check_numero_compte() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if exists ( select t1.numero_compte from tblcompte t1 inner join tblcerfa_2 t2 using (id_client, fiscal_year) where t1.numero_compte = new.numero_compte and t2.id_entry = new.id_entry ) then return new; else RAISE exception 'bad account number'; END IF ;
END
$$;


ALTER FUNCTION public.tblcerfa_2_detail_check_numero_compte() OWNER TO compta;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: tblcompte; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblcompte (
    id_client integer NOT NULL,
    numero_compte text NOT NULL,
    libelle_compte text NOT NULL,
    default_id_tva numeric(4,2) DEFAULT 0 NOT NULL,
    fiscal_year integer NOT NULL,
    contrepartie text
);


ALTER TABLE public.tblcompte OWNER TO compta;

--
-- Name: tblcerfa_2_unused_accounts(integer, integer); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.tblcerfa_2_unused_accounts(id_client integer, fiscal_year integer) RETURNS SETOF public.tblcompte
    LANGUAGE sql
    AS $_$
SELECT *
FROM tblcompte
WHERE id_client = $1 AND fiscal_year = $2 AND substring(numero_compte from 1 for 1) IN ('6', '7')
AND numero_compte NOT IN (SELECT numero_compte FROM tblcerfa_2_detail INNER JOIN tblcerfa_2 using (id_entry) WHERE id_client = $1 AND fiscal_year = $2)
ORDER BY numero_compte
$_$;


ALTER FUNCTION public.tblcerfa_2_unused_accounts(id_client integer, fiscal_year integer) OWNER TO compta;

--
-- Name: tbljournal_check_month_is_archived(); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.tbljournal_check_month_is_archived() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
arrow record;
BEGIN
IF ( TG_OP = 'DELETE' ) THEN arrow := OLD; ELSE arrow := NEW; END IF;
IF EXISTS (SELECT id_client FROM tbllocked_month WHERE id_client = arrow.id_client AND ( id_month = to_char(arrow.date_ecriture, 'MM') ) AND fiscal_year = arrow.fiscal_year)
THEN
RAISE EXCEPTION 'month is archived';
ELSE
RETURN arrow;
END IF;
END $$;


ALTER FUNCTION public.tbljournal_check_month_is_archived() OWNER TO compta;

--
-- Name: tbljournal_staging_check_fiscal_year(); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.tbljournal_staging_check_fiscal_year() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
if ( not date_is_in_fiscal_year(new.date_ecriture, old.fiscal_year_start, old.fiscal_year_end) )
THEN RAISE EXCEPTION 'bad fiscal year';
ELSE RETURN NEW; END IF ; END $$;


ALTER FUNCTION public.tbljournal_staging_check_fiscal_year() OWNER TO compta;

--
-- Name: tbljournal_staging_check_numero_compte(); Type: FUNCTION; Schema: public; Owner: compta
--

CREATE FUNCTION public.tbljournal_staging_check_numero_compte() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN if ( coalesce(new.numero_compte, '') = coalesce(old.numero_compte,'') ) or exists (select numero_compte from tblcompte where id_client=old.id_client and fiscal_year = old.fiscal_year and numero_compte=new.numero_compte ) then return new; else RAISE exception 'bad account number'; END IF ; END $$;


ALTER FUNCTION public.tbljournal_staging_check_numero_compte() OWNER TO compta;

--
-- Name: compta_client; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.compta_client (
    id_client integer NOT NULL,
    etablissement text NOT NULL,
    siret text NOT NULL,
    padding_zeroes integer DEFAULT 2 NOT NULL,
    fiscal_year_start text DEFAULT '01-01'::text NOT NULL,
    id_tva_periode text DEFAULT 'trimestrielle'::text NOT NULL,
    id_tva_option text DEFAULT 'encaissements'::text NOT NULL,
    id_tva_regime text,
    adresse_1 text,
    adresse_2 text,
    code_postal text,
    ville text,
    journal_tva text DEFAULT 'OD'::text NOT NULL,
    last_connection_date date DEFAULT ('now'::text)::date NOT NULL,
    date_debut date,
    date_fin date,
    validation text,
    default_cca_journal text,
    default_cca_compte text,
    default_caisse_journal text,
    default_caisse_compte text,
    default_banque_journal text,
    default_banque_compte text,
    default_divers_journal text,
    default_divers_compte text,
    type_compta text DEFAULT 'engagement'::text NOT NULL
);


ALTER TABLE public.compta_client OWNER TO compta;

--
-- Name: compta_client_id_client_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.compta_client_id_client_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.compta_client_id_client_seq OWNER TO compta;

--
-- Name: compta_client_id_client_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: compta
--

ALTER SEQUENCE public.compta_client_id_client_seq OWNED BY public.compta_client.id_client;


--
-- Name: compta_user; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.compta_user (
    username text NOT NULL,
    userpass text NOT NULL,
    id_client integer NOT NULL,
    preferred_datestyle text DEFAULT 'iso'::text NOT NULL,
    nom text,
    prenom text,
    is_main integer DEFAULT 1 NOT NULL,
    debug integer DEFAULT 0 NOT NULL,
    dump integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.compta_user OWNER TO compta;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.sessions (
    session_id text NOT NULL,
    date_session timestamp without time zone DEFAULT now(),
    serialized_session bytea
);


ALTER TABLE public.sessions OWNER TO compta;

--
-- Name: tblcerfa_2; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblcerfa_2 (
    id_entry integer NOT NULL,
    id_item text NOT NULL,
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    credit_first boolean DEFAULT false NOT NULL
);


ALTER TABLE public.tblcerfa_2 OWNER TO compta;

--
-- Name: tblcerfa_2_detail; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblcerfa_2_detail (
    id_entry integer NOT NULL,
    numero_compte text NOT NULL
);


ALTER TABLE public.tblcerfa_2_detail OWNER TO compta;

--
-- Name: tblcerfa_2_id_entry_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tblcerfa_2_id_entry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tblcerfa_2_id_entry_seq OWNER TO compta;

--
-- Name: tblcerfa_2_id_entry_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: compta
--

ALTER SEQUENCE public.tblcerfa_2_id_entry_seq OWNED BY public.tblcerfa_2.id_entry;


--
-- Name: tblconfig_liste; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblconfig_liste (
    id_client integer NOT NULL,
    config_libelle text NOT NULL,
    config_compte text,
    config_journal text,
    module text NOT NULL
);


ALTER TABLE public.tblconfig_liste OWNER TO compta;

--
-- Name: tbldatestyle; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbldatestyle (
    id_datestyle text NOT NULL,
    libelle text
);


ALTER TABLE public.tbldatestyle OWNER TO compta;

--
-- Name: tbldocuments; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbldocuments (
    id_client integer NOT NULL,
    id_name text NOT NULL,
    libelle_cat_doc text NOT NULL,
    fiscal_year integer NOT NULL,
    last_fiscal_year text,
    date_upload date DEFAULT CURRENT_DATE,
    date_reception date,
    montant integer DEFAULT 0 NOT NULL,
    check_banque boolean DEFAULT false NOT NULL,
    id_compte text,
    multi boolean DEFAULT false NOT NULL
);


ALTER TABLE public.tbldocuments OWNER TO compta;

--
-- Name: tbldocuments_categorie; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbldocuments_categorie (
    libelle_cat_doc text NOT NULL,
    id_client integer NOT NULL
);


ALTER TABLE public.tbldocuments_categorie OWNER TO compta;

--
-- Name: tblexport; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblexport (
    id_export integer NOT NULL,
    id_client integer NOT NULL,
    date_export date NOT NULL,
    fiscal_year integer NOT NULL,
    date_validation date NOT NULL
);


ALTER TABLE public.tblexport OWNER TO compta;

--
-- Name: tblexport_id_export_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tblexport_id_export_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tblexport_id_export_seq OWNER TO compta;

--
-- Name: tblexport_id_export_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: compta
--

ALTER SEQUENCE public.tblexport_id_export_seq OWNED BY public.tblexport.id_export;


--
-- Name: tbljournal; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbljournal (
    id_line integer NOT NULL,
    id_entry integer NOT NULL,
    num_mouvement text,
    date_creation date DEFAULT CURRENT_DATE NOT NULL,
    date_ecriture date NOT NULL,
    id_facture text,
    libelle text,
    debit integer DEFAULT 0 NOT NULL,
    credit integer DEFAULT 0 NOT NULL,
    lettrage text,
    pointage boolean DEFAULT false NOT NULL,
    id_paiement text,
    numero_compte text NOT NULL,
    fiscal_year integer NOT NULL,
    id_client integer NOT NULL,
    libelle_journal text NOT NULL,
    id_export integer,
    documents1 text,
    documents2 text,
    recurrent boolean
);


ALTER TABLE public.tbljournal OWNER TO compta;

--
-- Name: tbljournal_id_entry_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tbljournal_id_entry_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbljournal_id_entry_seq OWNER TO compta;

--
-- Name: tbljournal_id_line_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tbljournal_id_line_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbljournal_id_line_seq OWNER TO compta;

--
-- Name: tbljournal_id_line_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: compta
--

ALTER SEQUENCE public.tbljournal_id_line_seq OWNED BY public.tbljournal.id_line;


--
-- Name: tbljournal_id_num_mouvement_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tbljournal_id_num_mouvement_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tbljournal_id_num_mouvement_seq OWNER TO compta;

--
-- Name: tbljournal_import; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbljournal_import (
    date_ecriture date,
    id_facture text,
    libelle text,
    debit numeric DEFAULT 0 NOT NULL,
    credit numeric DEFAULT 0 NOT NULL,
    lettrage text,
    id_line integer,
    id_entry integer NOT NULL,
    id_paiement text,
    numero_compte text NOT NULL,
    fiscal_year integer NOT NULL,
    id_client integer NOT NULL,
    libelle_journal text NOT NULL,
    _session_id text NOT NULL,
    fiscal_year_offset integer,
    id_export integer,
    pointage boolean DEFAULT false NOT NULL,
    _token_id text NOT NULL,
    documents1 text,
    documents2 text,
    num_mouvement integer,
    date_validation date
);


ALTER TABLE public.tbljournal_import OWNER TO compta;

--
-- Name: tbljournal_liste; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbljournal_liste (
    id_client integer NOT NULL,
    code_journal text NOT NULL,
    libelle_journal text NOT NULL,
    fiscal_year integer NOT NULL,
    type_journal text NOT NULL
);


ALTER TABLE public.tbljournal_liste OWNER TO compta;

--
-- Name: tbljournal_staging; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbljournal_staging (
    date_ecriture date,
    id_facture text,
    libelle text,
    debit integer DEFAULT 0 NOT NULL,
    credit integer DEFAULT 0 NOT NULL,
    lettrage text,
    id_line integer DEFAULT nextval('public.tbljournal_id_line_seq'::regclass) NOT NULL,
    id_entry integer NOT NULL,
    id_paiement text,
    numero_compte text,
    fiscal_year integer NOT NULL,
    id_client integer NOT NULL,
    libelle_journal text NOT NULL,
    _session_id text NOT NULL,
    fiscal_year_offset integer,
    id_export integer,
    pointage boolean DEFAULT false NOT NULL,
    _token_id text NOT NULL,
    documents1 text,
    documents2 text,
    fiscal_year_start date,
    fiscal_year_end date,
    recurrent boolean
);


ALTER TABLE public.tbljournal_staging OWNER TO compta;

--
-- Name: tbljournal_type; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbljournal_type (
    type_journal text NOT NULL
);


ALTER TABLE public.tbljournal_type OWNER TO compta;


--
-- Name: tbllocked_month; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbllocked_month (
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    id_month text NOT NULL,
    date_locked date DEFAULT ('now'::text)::date NOT NULL
);


ALTER TABLE public.tbllocked_month OWNER TO compta;

--
-- Name: tblndf; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblndf (
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    piece_ref text NOT NULL,
    piece_date date NOT NULL,
    piece_compte text NOT NULL,
    piece_libelle text NOT NULL,
    piece_entry integer,
    id_vehicule integer,
    com1 text,
    com2 text,
    com3 text
);


ALTER TABLE public.tblndf OWNER TO compta;

--
-- Name: tblndf_bareme; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblndf_bareme (
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    vehicule text NOT NULL,
    puissance text NOT NULL,
    distance1 numeric,
    distance2 numeric,
    prime2 numeric,
    distance3 numeric
);


ALTER TABLE public.tblndf_bareme OWNER TO compta;

--
-- Name: tblndf_detail; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblndf_detail (
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    piece_ref text NOT NULL,
    frais_date date NOT NULL,
    frais_compte text NOT NULL,
    frais_libelle text NOT NULL,
    frais_quantite integer,
    frais_montant integer DEFAULT 0 NOT NULL,
    frais_doc text,
    frais_line integer NOT NULL,
    frais_bareme numeric
);


ALTER TABLE public.tblndf_detail OWNER TO compta;

--
-- Name: tblndf_detail_frais_line_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tblndf_detail_frais_line_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tblndf_detail_frais_line_seq OWNER TO compta;

--
-- Name: tblndf_detail_frais_line_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: compta
--

ALTER SEQUENCE public.tblndf_detail_frais_line_seq OWNED BY public.tblndf_detail.frais_line;


--
-- Name: tblndf_frais; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblndf_frais (
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    intitule text NOT NULL,
    compte text NOT NULL,
    tva numeric(4,2) DEFAULT '0'::numeric NOT NULL
);


ALTER TABLE public.tblndf_frais OWNER TO compta;

--
-- Name: tblndf_vehicule; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tblndf_vehicule (
    id_client integer NOT NULL,
    fiscal_year integer NOT NULL,
    vehicule text NOT NULL,
    puissance text NOT NULL,
    vehicule_name text NOT NULL,
    numero_compte text NOT NULL,
    documents text,
    id_vehicule integer NOT NULL,
    electrique boolean DEFAULT false NOT NULL
);


ALTER TABLE public.tblndf_vehicule OWNER TO compta;

--
-- Name: tblndf_vehicule_id_vehicule_seq; Type: SEQUENCE; Schema: public; Owner: compta
--

CREATE SEQUENCE public.tblndf_vehicule_id_vehicule_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tblndf_vehicule_id_vehicule_seq OWNER TO compta;

--
-- Name: tblndf_vehicule_id_vehicule_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: compta
--

ALTER SEQUENCE public.tblndf_vehicule_id_vehicule_seq OWNED BY public.tblndf_vehicule.id_vehicule;


--
-- Name: tbltva; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbltva (
    id_tva numeric(4,2) NOT NULL
);


ALTER TABLE public.tbltva OWNER TO compta;

--
-- Name: tbltva_option; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbltva_option (
    id_tva_option text NOT NULL
);


ALTER TABLE public.tbltva_option OWNER TO compta;

--
-- Name: tbltva_periode; Type: TABLE; Schema: public; Owner: compta
--

CREATE TABLE public.tbltva_periode (
    id_tva_periode text NOT NULL
);


ALTER TABLE public.tbltva_periode OWNER TO compta;

--
-- Name: compta_client id_client; Type: DEFAULT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_client ALTER COLUMN id_client SET DEFAULT nextval('public.compta_client_id_client_seq'::regclass);


--
-- Name: tblcerfa_2 id_entry; Type: DEFAULT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcerfa_2 ALTER COLUMN id_entry SET DEFAULT nextval('public.tblcerfa_2_id_entry_seq'::regclass);


--
-- Name: tblexport id_export; Type: DEFAULT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblexport ALTER COLUMN id_export SET DEFAULT nextval('public.tblexport_id_export_seq'::regclass);


--
-- Name: tbljournal id_line; Type: DEFAULT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal ALTER COLUMN id_line SET DEFAULT nextval('public.tbljournal_id_line_seq'::regclass);


--
-- Name: tblndf_detail frais_line; Type: DEFAULT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_detail ALTER COLUMN frais_line SET DEFAULT nextval('public.tblndf_detail_frais_line_seq'::regclass);


--
-- Name: tblndf_vehicule id_vehicule; Type: DEFAULT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule ALTER COLUMN id_vehicule SET DEFAULT nextval('public.tblndf_vehicule_id_vehicule_seq'::regclass);


--
-- Data for Name: compta_client; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.compta_client (id_client, etablissement, siret, padding_zeroes, fiscal_year_start, id_tva_periode, id_tva_option, id_tva_regime, adresse_1, adresse_2, code_postal, ville, journal_tva, last_connection_date, date_debut, date_fin, validation, default_cca_journal, default_cca_compte, default_caisse_journal, default_caisse_compte, default_banque_journal, default_banque_compte, default_divers_journal, default_divers_compte, type_compta) FROM stdin;
1	Compta-Libre	850550550123	3	01-01	mensuelle	encaissements	normal	\N	\N	\N	\N	OD	2022-06-04	2022-01-01	2022-12-31	\N	\N	\N	\N	\N	\N	\N	\N	\N	engagement
\.


--
-- Data for Name: compta_user; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.compta_user (username, userpass, id_client, preferred_datestyle, nom, prenom, is_main, debug, dump) FROM stdin;
superadmin	admin	1	SQL, dmy	superadmin		1	1	0
\.

--
-- Data for Name: tbldatestyle; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.tbldatestyle (id_datestyle, libelle) FROM stdin;
iso	iso
SQL, dmy	SQL, dmy
\.

--
-- Data for Name: tbldocuments_categorie; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.tbldocuments_categorie (libelle_cat_doc, id_client) FROM stdin;
Temp	1
Inter-exercice	1
\.

--
-- Data for Name: tbljournal_type; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.tbljournal_type (type_journal) FROM stdin;
Achats
Ventes
Trésorerie
Clôture
OD
A-nouveaux
\.

--
-- Data for Name: tbltva; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.tbltva (id_tva) FROM stdin;
0.00
2.10
5.50
8.50
10.00
20.00
\.


--
-- Data for Name: tbltva_option; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.tbltva_option (id_tva_option) FROM stdin;
encaissements
débits
\.


--
-- Data for Name: tbltva_periode; Type: TABLE DATA; Schema: public; Owner: compta
--

COPY public.tbltva_periode (id_tva_periode) FROM stdin;
mensuelle
trimestrielle
\.


--
-- Name: compta_client_id_client_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.compta_client_id_client_seq', 2, false);


--
-- Name: tblcerfa_2_id_entry_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tblcerfa_2_id_entry_seq', 1, false);


--
-- Name: tblexport_id_export_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tblexport_id_export_seq', 1, false);


--
-- Name: tbljournal_id_entry_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tbljournal_id_entry_seq', 1, false);


--
-- Name: tbljournal_id_line_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tbljournal_id_line_seq', 1, false);


--
-- Name: tbljournal_id_num_mouvement_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tbljournal_id_num_mouvement_seq', 1, false);


--
-- Name: tblndf_detail_frais_line_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tblndf_detail_frais_line_seq', 1, false);


--
-- Name: tblndf_vehicule_id_vehicule_seq; Type: SEQUENCE SET; Schema: public; Owner: compta
--

SELECT pg_catalog.setval('public.tblndf_vehicule_id_vehicule_seq', 1, false);



--
-- Name: tbllocked_month add; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbllocked_month
    ADD CONSTRAINT add PRIMARY KEY (id_client, fiscal_year, id_month);


--
-- Name: compta_client compta_client_pkey; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_client
    ADD CONSTRAINT compta_client_pkey PRIMARY KEY (id_client);


--
-- Name: compta_user compta_user_username_userpass_pk; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_user
    ADD CONSTRAINT compta_user_username_userpass_pk PRIMARY KEY (username, userpass);


--
-- Name: tblcerfa_2 tblcerfa_2_pkey; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcerfa_2
    ADD CONSTRAINT tblcerfa_2_pkey PRIMARY KEY (id_entry);


--
-- Name: tblcompte tblcompte_client_year_numero_compte_pk; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcompte
    ADD CONSTRAINT tblcompte_client_year_numero_compte_pk PRIMARY KEY (id_client, fiscal_year, numero_compte);


--
-- Name: tblconfig_liste tblconfig_liste_id_client_config_libelle; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblconfig_liste
    ADD CONSTRAINT tblconfig_liste_id_client_config_libelle PRIMARY KEY (id_client, config_libelle);


--
-- Name: tbldatestyle tbldatestyle_pkey; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbldatestyle
    ADD CONSTRAINT tbldatestyle_pkey PRIMARY KEY (id_datestyle);


--
-- Name: tbldocuments_categorie tbldocuments_categorie_id_client_libelle_cat_doc; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbldocuments_categorie
    ADD CONSTRAINT tbldocuments_categorie_id_client_libelle_cat_doc PRIMARY KEY (id_client, libelle_cat_doc);


--
-- Name: tbldocuments tbldocuments_id_name_id_client; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbldocuments
    ADD CONSTRAINT tbldocuments_id_name_id_client PRIMARY KEY (id_name, id_client);


--
-- Name: tblexport tblexport_id_export_id_client_fiscal_year; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblexport
    ADD CONSTRAINT tblexport_id_export_id_client_fiscal_year PRIMARY KEY (id_export, id_client, fiscal_year);


--
-- Name: tbljournal_liste tbljournal_client_year_libelle_journal_pk; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal_liste
    ADD CONSTRAINT tbljournal_client_year_libelle_journal_pk PRIMARY KEY (id_client, fiscal_year, libelle_journal);


--
-- Name: tbljournal tbljournal_id_line; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_id_line PRIMARY KEY (id_line);



--
-- Name: tbljournal_type tbljournal_type_type_journal; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal_type
    ADD CONSTRAINT tbljournal_type_type_journal PRIMARY KEY (type_journal);


--
-- Name: tblndf_bareme tblndf_bareme_id_client_fiscal_year_vehicule_puissance; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_bareme
    ADD CONSTRAINT tblndf_bareme_id_client_fiscal_year_vehicule_puissance PRIMARY KEY (id_client, fiscal_year, vehicule, puissance);


--
-- Name: tblndf_detail tblndf_detail_pkey; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_detail
    ADD CONSTRAINT tblndf_detail_pkey PRIMARY KEY (frais_line);


--
-- Name: tblndf_frais tblndf_frais_id_client_fiscal_year_intitule_compte_tva; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_frais
    ADD CONSTRAINT tblndf_frais_id_client_fiscal_year_intitule_compte_tva PRIMARY KEY (id_client, fiscal_year, intitule, compte, tva);


--
-- Name: tblndf tblndf_id_client_fiscal_year_piece_ref; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf
    ADD CONSTRAINT tblndf_id_client_fiscal_year_piece_ref PRIMARY KEY (id_client, fiscal_year, piece_ref);


--
-- Name: tblndf_vehicule tblndf_vehicule_id_client_fiscal_year_vehicule_puissance_vehicu; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule
    ADD CONSTRAINT tblndf_vehicule_id_client_fiscal_year_vehicule_puissance_vehicu UNIQUE (id_client, fiscal_year, vehicule, puissance, vehicule_name);


--
-- Name: tblndf_vehicule tblndf_vehicule_id_vehicule_id_client_fiscal_year; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule
    ADD CONSTRAINT tblndf_vehicule_id_vehicule_id_client_fiscal_year PRIMARY KEY (id_vehicule, id_client, fiscal_year);



--
-- Name: tbltva_option tbltva_option_id_tva_option_pk; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbltva_option
    ADD CONSTRAINT tbltva_option_id_tva_option_pk PRIMARY KEY (id_tva_option);


--
-- Name: tbltva_periode tbltva_periode_id_tva_periode_pk; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbltva_periode
    ADD CONSTRAINT tbltva_periode_id_tva_periode_pk PRIMARY KEY (id_tva_periode);


--
-- Name: tbltva tbltva_pkey; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbltva
    ADD CONSTRAINT tbltva_pkey PRIMARY KEY (id_tva);


--
-- Name: tblcerfa_2_detail unique_id_entry_numero_compte; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcerfa_2_detail
    ADD CONSTRAINT unique_id_entry_numero_compte UNIQUE (id_entry, numero_compte);


--
-- Name: tblcerfa_2 unique_item_per_year; Type: CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcerfa_2
    ADD CONSTRAINT unique_item_per_year UNIQUE (id_item, id_client, fiscal_year);


--
-- Name: tblcerfa_2_detail_id_entry_idx; Type: INDEX; Schema: public; Owner: compta
--

CREATE INDEX tblcerfa_2_detail_id_entry_idx ON public.tblcerfa_2_detail USING btree (id_entry);


--
-- Name: tblexport_id_client_idx; Type: INDEX; Schema: public; Owner: compta
--

CREATE INDEX tblexport_id_client_idx ON public.tbljournal USING btree (id_client);


--
-- Name: tblexport_id_export_idx; Type: INDEX; Schema: public; Owner: compta
--

CREATE INDEX tblexport_id_export_idx ON public.tbljournal USING btree (id_export);


--
-- Name: tbljournal_client_year_compte_idx; Type: INDEX; Schema: public; Owner: compta
--

CREATE INDEX tbljournal_client_year_compte_idx ON public.tbljournal USING btree (id_client, fiscal_year, numero_compte);


--
-- Name: tbljournal_client_year_libelle_journal_idx; Type: INDEX; Schema: public; Owner: compta
--

CREATE INDEX tbljournal_client_year_libelle_journal_idx ON public.tbljournal USING btree (id_client, fiscal_year, libelle_journal);


--
-- Name: tbljournal_id_entry_idx; Type: INDEX; Schema: public; Owner: compta
--

CREATE INDEX tbljournal_id_entry_idx ON public.tbljournal USING btree (id_entry);


--
-- Name: tblcerfa_2_detail check_compte_not_in_use; Type: TRIGGER; Schema: public; Owner: compta
--

CREATE TRIGGER check_compte_not_in_use BEFORE INSERT ON public.tblcerfa_2_detail FOR EACH ROW EXECUTE PROCEDURE public.tblcerfa_2_detail_check_compte_not_in_use();


--
-- Name: tbljournal_staging check_fiscal_year_is_a_match; Type: TRIGGER; Schema: public; Owner: compta
--

CREATE TRIGGER check_fiscal_year_is_a_match BEFORE UPDATE ON public.tbljournal_staging FOR EACH ROW EXECUTE PROCEDURE public.tbljournal_staging_check_fiscal_year();


--
-- Name: tbljournal check_month_is_archived; Type: TRIGGER; Schema: public; Owner: compta
--

CREATE TRIGGER check_month_is_archived BEFORE INSERT OR DELETE ON public.tbljournal FOR EACH ROW EXECUTE PROCEDURE public.tbljournal_check_month_is_archived();


--
-- Name: tblcerfa_2_detail check_numero_compte_is_a_match; Type: TRIGGER; Schema: public; Owner: compta
--

CREATE TRIGGER check_numero_compte_is_a_match BEFORE INSERT ON public.tblcerfa_2_detail FOR EACH ROW EXECUTE PROCEDURE public.tblcerfa_2_detail_check_numero_compte();


--
-- Name: tbljournal_staging check_numero_compte_is_a_match; Type: TRIGGER; Schema: public; Owner: compta
--

CREATE TRIGGER check_numero_compte_is_a_match BEFORE UPDATE ON public.tbljournal_staging FOR EACH ROW EXECUTE PROCEDURE public.tbljournal_staging_check_numero_compte();


--
-- Name: compta_client compta_client_id_tva_option_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_client
    ADD CONSTRAINT compta_client_id_tva_option_fkey FOREIGN KEY (id_tva_option) REFERENCES public.tbltva_option(id_tva_option);


--
-- Name: compta_client compta_client_id_tva_periode_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_client
    ADD CONSTRAINT compta_client_id_tva_periode_fkey FOREIGN KEY (id_tva_periode) REFERENCES public.tbltva_periode(id_tva_periode);


--
-- Name: compta_user compta_user_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_user
    ADD CONSTRAINT compta_user_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client);


--
-- Name: compta_user compta_user_preferred_datestyle_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.compta_user
    ADD CONSTRAINT compta_user_preferred_datestyle_fkey FOREIGN KEY (preferred_datestyle) REFERENCES public.tbldatestyle(id_datestyle);


--
-- Name: tblcerfa_2_detail tblcerfa_2_detail_id_entry_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcerfa_2_detail
    ADD CONSTRAINT tblcerfa_2_detail_id_entry_fkey FOREIGN KEY (id_entry) REFERENCES public.tblcerfa_2(id_entry);


--
-- Name: tblcompte tblcompte_default_id_tva_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcompte
    ADD CONSTRAINT tblcompte_default_id_tva_fkey FOREIGN KEY (default_id_tva) REFERENCES public.tbltva(id_tva) ON UPDATE CASCADE;


--
-- Name: tblcompte tblcompte_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblcompte
    ADD CONSTRAINT tblcompte_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- Name: tblconfig_liste tblconfig_liste_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblconfig_liste
    ADD CONSTRAINT tblconfig_liste_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON DELETE CASCADE;


--
-- Name: tbldocuments tblcontrat_document_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbldocuments
    ADD CONSTRAINT tblcontrat_document_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- Name: tbldocuments tblcontrat_document_id_client_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbldocuments
    ADD CONSTRAINT tblcontrat_document_id_client_fkey1 FOREIGN KEY (id_client, libelle_cat_doc) REFERENCES public.tbldocuments_categorie(id_client, libelle_cat_doc) ON UPDATE CASCADE;


--
-- Name: tbldocuments_categorie tbldocuments_categorie_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbldocuments_categorie
    ADD CONSTRAINT tbldocuments_categorie_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- Name: tblexport tblexport_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblexport
    ADD CONSTRAINT tblexport_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON DELETE CASCADE;


--
-- Name: tbljournal tbljournal_documents1_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_documents1_id_client_fkey FOREIGN KEY (documents1, id_client) REFERENCES public.tbldocuments(id_name, id_client) ON UPDATE CASCADE;


--
-- Name: tbljournal tbljournal_documents2_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_documents2_id_client_fkey FOREIGN KEY (documents2, id_client) REFERENCES public.tbldocuments(id_name, id_client) ON UPDATE CASCADE;


--
-- Name: tbljournal tbljournal_id_client_fiscal_year_id_export_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_id_client_fiscal_year_id_export_fkey FOREIGN KEY (id_client, fiscal_year, id_export) REFERENCES public.tblexport(id_client, fiscal_year, id_export) ON UPDATE CASCADE;


--
-- Name: tbljournal tbljournal_id_client_fiscal_year_libelle_journal_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_id_client_fiscal_year_libelle_journal_fkey FOREIGN KEY (id_client, fiscal_year, libelle_journal) REFERENCES public.tbljournal_liste(id_client, fiscal_year, libelle_journal) ON UPDATE CASCADE;


--
-- Name: tbljournal tbljournal_id_client_fiscal_year_numero_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_id_client_fiscal_year_numero_compte_fkey FOREIGN KEY (id_client, fiscal_year, numero_compte) REFERENCES public.tblcompte(id_client, fiscal_year, numero_compte) ON UPDATE CASCADE;


--
-- Name: tbljournal tbljournal_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal
    ADD CONSTRAINT tbljournal_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client);


--
-- Name: tbljournal_liste tbljournal_liste_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbljournal_liste
    ADD CONSTRAINT tbljournal_liste_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- Name: tbllocked_month tbllocked_month_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tbllocked_month
    ADD CONSTRAINT tbllocked_month_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON DELETE CASCADE;


--
-- Name: tblndf_bareme tblndf_bareme_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_bareme
    ADD CONSTRAINT tblndf_bareme_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- Name: tblndf_detail tblndf_detail_id_client_fiscal_year_piece_ref_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_detail
    ADD CONSTRAINT tblndf_detail_id_client_fiscal_year_piece_ref_fkey FOREIGN KEY (id_client, fiscal_year, piece_ref) REFERENCES public.tblndf(id_client, fiscal_year, piece_ref) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tblndf_frais tblndf_frais_id_client_fiscal_year_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_frais
    ADD CONSTRAINT tblndf_frais_id_client_fiscal_year_compte_fkey FOREIGN KEY (id_client, fiscal_year, compte) REFERENCES public.tblcompte(id_client, fiscal_year, numero_compte) ON UPDATE CASCADE;


--
-- Name: tblndf_frais tblndf_frais_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_frais
    ADD CONSTRAINT tblndf_frais_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- Name: tblndf_detail tblndf_id_client_fiscal_year_frais_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_detail
    ADD CONSTRAINT tblndf_id_client_fiscal_year_frais_compte_fkey FOREIGN KEY (id_client, fiscal_year, frais_compte) REFERENCES public.tblcompte(id_client, fiscal_year, numero_compte) ON UPDATE CASCADE;


--
-- Name: tblndf tblndf_id_client_fiscal_year_id_vehicule_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf
    ADD CONSTRAINT tblndf_id_client_fiscal_year_id_vehicule_fkey FOREIGN KEY (id_client, fiscal_year, id_vehicule) REFERENCES public.tblndf_vehicule(id_client, fiscal_year, id_vehicule);


--
-- Name: tblndf tblndf_id_client_fiscal_year_piece_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf
    ADD CONSTRAINT tblndf_id_client_fiscal_year_piece_compte_fkey FOREIGN KEY (id_client, fiscal_year, piece_compte) REFERENCES public.tblcompte(id_client, fiscal_year, numero_compte);


--
-- Name: tblndf_detail tblndf_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_detail
    ADD CONSTRAINT tblndf_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client);


--
-- Name: tblndf tblndf_id_client_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf
    ADD CONSTRAINT tblndf_id_client_fkey1 FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client);


--
-- Name: tblndf_detail tblndf_id_client_frais_doc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_detail
    ADD CONSTRAINT tblndf_id_client_frais_doc_fkey FOREIGN KEY (id_client, frais_doc) REFERENCES public.tbldocuments(id_client, id_name) ON UPDATE CASCADE;


--
-- Name: tblndf_vehicule tblndf_vehicule_id_client_documents_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule
    ADD CONSTRAINT tblndf_vehicule_id_client_documents_fkey FOREIGN KEY (id_client, documents) REFERENCES public.tbldocuments(id_client, id_name) ON UPDATE CASCADE;


--
-- Name: tblndf_vehicule tblndf_vehicule_id_client_fiscal_year_numero_compte_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule
    ADD CONSTRAINT tblndf_vehicule_id_client_fiscal_year_numero_compte_fkey FOREIGN KEY (id_client, fiscal_year, numero_compte) REFERENCES public.tblcompte(id_client, fiscal_year, numero_compte) ON UPDATE CASCADE;


--
-- Name: tblndf_vehicule tblndf_vehicule_id_client_fiscal_year_vehicule_puissance_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule
    ADD CONSTRAINT tblndf_vehicule_id_client_fiscal_year_vehicule_puissance_fkey FOREIGN KEY (id_client, fiscal_year, vehicule, puissance) REFERENCES public.tblndf_bareme(id_client, fiscal_year, vehicule, puissance) ON UPDATE CASCADE;


--
-- Name: tblndf_vehicule tblndf_vehicule_id_client_fkey; Type: FK CONSTRAINT; Schema: public; Owner: compta
--

ALTER TABLE ONLY public.tblndf_vehicule
    ADD CONSTRAINT tblndf_vehicule_id_client_fkey FOREIGN KEY (id_client) REFERENCES public.compta_client(id_client) ON UPDATE CASCADE;


--
-- PostgreSQL database dump complete
--


--CREAZIONE DELLE TABELLE


--creazione tab gen_dip

CREATE TABLE if not exists Gen_dip(
	year int,
	cname_send varchar,
	main_posting int,
	title int,
	gender int,
	cname_receive varchar,
	ccode_send int,
	ccodealp_send varchar,
	ccodeCOW_send int,
	region_send int,
	GME_send int,
	v2lgfemleg_send int,
	FFP_send int,
	ccode_receive int,
	ccodealp_receive varchar,
	ccodeCOW_receive int,
	region_receive int,
	GME_receive int,
	FFP_receive int);


--creazione tab region_name per l'associazione tra codice e nome dei continenti in esame

CREATE TABLE if not exists region_name AS(	
SELECT DISTINCT region_send AS region_code, CASE
WHEN region_send=0 THEN 'Africa'
WHEN region_send=1 THEN 'Asia'
WHEN region_send=2 THEN 'Central and North America (including the West Indies)'
WHEN region_send=3 THEN 'Europe (including Russia)'
WHEN region_send=4 THEN 'Middle East (including Egypt and Turkey)'
WHEN region_send=5 THEN 'Nordic countries'
WHEN region_send=6 THEN 'Oceania'
WHEN region_send=7 THEN 'South America'
END AS region_name
FROM gen_dip
ORDER BY region_send ASC);


--creazione tab title_recap per l'associazione tra codice e nome dei ruoli diplomatici in esame

CREATE TABLE if not exists title_recap AS(	
SELECT DISTINCT title, CASE
WHEN title = 99 THEN 'missing'
WHEN title = 1 THEN 'chargé daffaires'
WHEN title = 2 THEN 'minister, internuncios'
WHEN title = 3 THEN 'ambassador, high commissioners papal nuncios, designate ambassador, ambassador-at-large, secretary of the people''s bureau(Libya)'
WHEN title = 96 THEN 'acting chargé daffaires'
WHEN title = 97 THEN 'acting ambassador, acting secretary of the people''s bureau (Libya)'
WHEN title = 98 THEN 'other(head of mission, head of section, secretary, consul, diplomatic representative, envoy, deputy high commissioner, bureau chief, etc.)'
END AS title_name
FROM gen_dip
WHERE title <> 0
ORDER BY title ASC);
-- CORRELAZIONE TRA LA PERCENTUALE DI DONNE IN PARLAMENTO E DIPLOMATICHE IN MISSIONE NEI PAESI ASIATICI CON GAP MINORE TRA UOMINI E DONNE 


/* tabella temporanea che rappresenta il rapporto tra la crescita del numero di diplomatiche inviate in missione
e l'aumento della percentuale di donne in parlamento */

CREATE TEMPORARY TABLE if not exists wdiplomats_wlegislator AS(
SELECT cname_send as country, 
	   year, 
	   COUNT(gender) FILTER(WHERE gender=1) as women_diplomats, 
	   COUNT(gender) FILTER(WHERE gender=0) as men_diplomats, 
	   v2lgfemleg_send as female_legislator_perc
FROM gen_dip
WHERE cname_send IN ('Bhutan', 'Philippines', 'Maldives','Timor-Leste') AND v2lgfemleg_send<>9999
GROUP BY cname_send, year, v2lgfemleg_send
ORDER BY cname_send asc , year desc);


--tabella temporanea con somma totale di diplomatici per ogni anno in ogni paese e percentuale della presenza di diplomatiche in incarichi 

CREATE TEMPORARY TABLE if not exists wdiplomats_wlegislator_perc AS(
SELECT country, year, women_diplomats, men_diplomats, COALESCE(women_diplomats,0)+COALESCE(men_diplomats,0) AS total_diplomats, female_legislator_perc
FROM wdiplomats_wlegislator);


-- select con cambiamento percentuale annuo per i 4 paesi asiatici in esame

SELECT year, country, (women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) as women_diplomats_perc, female_legislator_perc
FROM wdiplomats_wlegislator_perc
WHERE total_diplomats <> 0
ORDER BY country asc, year asc


/* LA SELECT DIMOSTRA CHE NEI PAESI ASIATICI CON UN MAGGIOR NUMERO DI DONNE INVIATE IN MISSIONE  ESISTE UN'EFFETTIVA CORRELAZIONE 
NEGLI ANNI TRA L'AUMENTO DELLA PRESENZA DELLE DONNE NEL PROCESSO LEGISLATIVO ED IL NUMERO DI DIPLOMATICHE COINVOLTE IN MISSIONI */
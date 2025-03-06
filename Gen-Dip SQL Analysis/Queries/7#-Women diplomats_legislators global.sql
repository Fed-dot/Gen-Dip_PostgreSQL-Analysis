--RELAZIONE TRA LA PERCENTUALE DI DONNE IN PARLAMENTO E DIPLOMATICHE MANDATE IN MISSIONE 

/*tabella per individuare i paesi con la percentuale minore di donne presenti in parlamento in relazione
alle diplomatiche inviate in missione nel 2021; i 10 paesi con la percentuale più bassa (escluso 9999=dato mancante) */

CREATE TEMPORARY TABLE if not exists women_legislator_women_diplomats_10LEAST AS(
SELECT g.cname_send, r.region_name, g.v2lgfemleg_send, 
	   COUNT(g.gender) FILTER (WHERE g.gender=1) as women_diplomats_sended, 
	   COUNT(g.gender) FILTER (WHERE g.gender=0) as men_diplomats_sended,
	   COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=1),0)+COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=0),0) AS total_diplomats_send,
	 ((COUNT(g.gender) FILTER (WHERE g.gender=1))::numeric/(COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=1),0)+COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=0),0))::numeric)::numeric(10,2) AS women_diplomats_sended_perc
FROM gen_dip g
INNER JOIN region_name r 
ON g.region_send=r.region_code
WHERE v2lgfemleg_send <> 9999 AND year=2021 
GROUP BY g.cname_send,r.region_name, g.v2lgfemleg_send
ORDER BY v2lgfemleg_send asc LIMIT 10 );


-- medesima tabella con i 10 paesi con la percentuale più alta di donne presenti in parlamento (escluso 9999=dato mancante)

CREATE TEMPORARY TABLE if not exists women_legislator_women_diplomats_10TOP AS(
SELECT g.cname_send, r.region_name, g.v2lgfemleg_send, 
	   COUNT(g.gender) FILTER (WHERE g.gender=1) as women_diplomats_sended, 
	   COUNT(g.gender) FILTER (WHERE g.gender=0) as men_diplomats_sended,
	   COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=1),0)+COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=0),0) AS total_diplomats_send,
	 ((COUNT(g.gender) FILTER (WHERE g.gender=1))::numeric/(COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=1),0)+COALESCE(COUNT(g.gender) FILTER (WHERE g.gender=0),0))::numeric)::numeric(10,2) AS women_diplomats_sended_perc
FROM gen_dip g
INNER JOIN region_name r 
ON g.region_send=r.region_code
WHERE v2lgfemleg_send <> 9999 AND year=2021 
GROUP BY g.cname_send,r.region_name, g.v2lgfemleg_send
ORDER BY v2lgfemleg_send desc LIMIT 10);


/* tabella con unione delle due tabelle temporanee create, aggiungendo la classificazione dei paesi 
ai primi e agli ultimi 10 rispetto alla percentuale di donne in parlamento */

CREATE TEMPORARY TABLE if not exists womenlegislator_10_top_least AS(
SELECT CASE
			WHEN v2lgfemleg_send >= 46.00 THEN '10_TOP_COUNTRIES'
			ELSE 'LEAST'
			END AS class,
		cname_send, region_name, v2lgfemleg_send, women_diplomats_sended_perc  FROM women_legislator_women_diplomats_10TOP 
UNION
SELECT CASE
			WHEN v2lgfemleg_send >= 46.00 THEN '10_TOP'
			ELSE '10_LEAST_COUNTRIES'
			END AS class,
		cname_send, region_name, v2lgfemleg_send, women_diplomats_sended_perc  FROM women_legislator_women_diplomats_10LEAST
ORDER BY v2lgfemleg_send desc);


/* select delle media percentuale della presenza di donne in parlamento per i primi 10 e gli ultimi 10 in classifica presi in esame precedentemente,
in rapporto alla media di diplomatiche inviate in missione dagli stessi paesi */

SELECT class, AVG(v2lgfemleg_send)::numeric(10,2) as average_women_legislator, AVG(women_diplomats_sended_perc)::numeric(10,2) as average_women_diplomats_sended
FROM womenlegislator_10_top_least
GROUP BY class


/* IL CONFRONTO TRA LE MEDIE DI ENTRAMBE LE CLASSI:

-"PAESI CON IL MAGGIOR NUMERO DI DONNE IN PARLAMENTO NEL 2021" = 10_TOP_COUNTRIES  
-"PAESI CON IL MINOR NUMERO DI DONNE IN PARLAMENTO NEL 2021" = 10_LEAST_COUNTRIES

DIMOSTRA LA RELAZIONE TRA LA PERCENTUALE DI DONNE CON ACCESSO AL PROCESSO LEGISLATIVO RISPETTO ALLA PERCENTUALE 
DI DONNE CON ACCESSO AD INCARICHI DIPLOMATICI, IN QUANTO NEI PAESI CON UNA PRESENZA MEDIA MAGGIORE DI DONNE IN PARLAMENTO SI HA
UNA PRESENZA MEDIA MAGGIORE DI DONNE CHE SONO PROTAGONISTE DI INCARICHI DIPLOMATICI */
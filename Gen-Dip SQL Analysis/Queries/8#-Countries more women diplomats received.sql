-- PAESI IN CUI LE DIPLOMATICHE SONO INVIATE MAGGIORMENTE IN MISSIONE  


-- tabella temporanea per associare i codici dei continenti ai propri nomi e registrare il conteggio di diplomatiche e diplomatici ricevuti

CREATE TEMPORARY TABLE if not exists diplomats_region_received AS(
SELECT g.region_receive, r.region_name, 
	COUNT (g.gender) FILTER(where g.gender=1) as women_diplomats_received, 
	COUNT (g.gender) FILTER(where g.gender=0) as men_diplomats_received,
	COALESCE(COUNT (g.gender) FILTER(where g.gender=1),0) + COALESCE(COUNT (g.gender) FILTER(where g.gender=0),0) as total_diplomats_received
FROM gen_dip g
INNER JOIN region_name r
ON g.region_receive=r.region_code
GROUP BY g.region_receive,r.region_name
ORDER BY g.region_receive ASC);


--tabella temporanea per dedurre la percentuale di diplomatiche e diplomatici ricevuti in ogni continente ed il gap presente

CREATE TEMPORARY TABLE if not exists diplomats_region_received_perc AS(
SELECT region_receive as region_code,
	   region_name, 
	  (women_diplomats_received::numeric/total_diplomats_received::numeric)::numeric(10,2) as women_diplomats_received_perc,
	  (men_diplomats_received::numeric/total_diplomats_received::numeric)::numeric(10,2) as men_diplomats_received_perc,
	  ((women_diplomats_received::numeric/total_diplomats_received::numeric)-(men_diplomats_received::numeric/total_diplomats_received::numeric))::numeric(10,2) as total_gap
FROM diplomats_region_received
ORDER BY ((women_diplomats_received::numeric/total_diplomats_received::numeric)-(men_diplomats_received::numeric/total_diplomats_received::numeric))::numeric(10,2) ASC);


-- select per identificare i paesi che ricevono un maggior numero di diplomatiche in missione e analizzare quante donne hanno ricevuto effettivamente

SELECT DISTINCT cname_receive, region_name, 
	   COUNT(gender) FILTER(WHERE gender=1) as women_diplomats, 
	   COUNT(gender) FILTER(WHERE gender=0) as men_diplomats,
	   COALESCE(COUNT(gender) FILTER(WHERE gender=1),0)+COALESCE(COUNT(gender) FILTER(WHERE gender=0),0) as total_diplomats,
	   ((COUNT(gender) FILTER(WHERE gender=1))::numeric/(COALESCE(COUNT(gender) FILTER(WHERE gender=1),0)+COALESCE(COUNT(gender) FILTER(WHERE gender=0),0)::numeric))::numeric(10,2) as perc_women_in_total
FROM gen_dip g
INNER JOIN diplomats_region_received_perc d
ON d.region_code=g.region_receive
WHERE total_gap=(SELECT MAX(total_gap) FROM diplomats_region_received_perc)
GROUP BY cname_receive, region_name
ORDER BY cname_receive ASC


/* LA QUERY DIMOSTRA COME I PAESI NORDICI DANIMARCA, FINLANDIA, ISLANDA, NORVEGIA, SVEZIA 
SIANO I PAESI IN CUI IN PERCENTUALE LE DIPLOMATICHE SONO PIÙ PRESENTI RISPETTO AGLI ALTRI CONTINENTI,
MA ALLO STESSO TEMPO LA LORO PRESENZA È COMUNQUE MOLTO INFERIORE AL 50% */
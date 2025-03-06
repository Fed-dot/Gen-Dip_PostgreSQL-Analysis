--AREE GEOGRAFICHE CON IL MINOR NUMERO DI DIPLOMATICHE COINVOLTE NEGLI INCARICHI 

--creazione di una tabella temporanea per raggruppare il conteggio degli incarichi diplomatici svolti diviso per continente

CREATE TEMPORARY TABLE if not exists region_diplomats AS(
	SELECT region_send as region_code, 
		COUNT(gender) FILTER(WHERE gender=1) as women_diplomats, 
		COUNT(gender) FILTER(WHERE gender=0) as men_diplomats
	FROM gen_dip
	GROUP BY region_send
	ORDER BY region_send asc);
	
	
/*creazione di una tabella per associare i nomi ai codici dei continenti con la tab 'region_name', 
contenente i codici associati con i nomi dei continenti*/

CREATE TEMPORARY TABLE if not exists women_men_region AS(
SELECT r.region_code, n.region_name, r.women_diplomats, r.men_diplomats, COALESCE(r.women_diplomats,0)+COALESCE(r.men_diplomats,0) as total_diplomats
FROM region_diplomats r
INNER JOIN region_name n
ON r.region_code=n.region_code);


-- visualizzazione della differenza percentuale tra continenti

SELECT region_code, region_name,
       (women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) as women_diplomats_perc,
	   (men_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) as men_diplomats_perc,
	   ((women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2)-(men_diplomats::numeric/total_diplomats::numeric)::numeric(10,2))::numeric(10,2) as diplomats_perc_diff
FROM women_men_region
ORDER BY diplomats_perc_diff asc

/*I CONTINENTI IN CUI LA DIFFERENZA PERCENTUALE A SFAVORE DELLE DONNE PER GLI INCARICHI DIPLOMATICI SVOLTI È MAGGIORE 
SONO IL MEDIO ORIENTE E L'ASIA*/
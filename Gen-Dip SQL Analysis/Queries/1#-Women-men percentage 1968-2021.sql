-- CONFRONTO TRA IL NUMERO DI DONNE E UOMINI NEL RUOLO DI DIPLOMATICI IN MISSIONE DAL 1968 AL 2021


-- la tabella racchiude il numero di diplomatiche e diplomatici inviati negli anni presi in analisi dal dataset in tutti i continenti

CREATE TEMPORARY TABLE if not exists diplomats AS(
SELECT year, COUNT(gender) FILTER(WHERE gender=0) AS men, COUNT (gender) FILTER(WHERE gender=1) as women
FROM gen_dip
GROUP BY year
ORDER BY year ASC);


-- somma del totale dei diplomatici donne e uomini

CREATE TEMPORARY TABLE if not exists women_men_diplomats AS(
SELECT year, women, men, COALESCE (women,0) + COALESCE (men,0) AS total
FROM diplomats);


-- visualizzazione dei dati

SELECT *, (women::numeric/total::numeric)::numeric(10,2) as women_perc, 
		  (men::numeric/total::numeric)::numeric(10,2) as men_perc 
FROM women_men_diplomats


/* LA PERCENTUALE DI DIPLOMATICHE COINVOLTE IN INCARICHI HA AVUTO UN INCREMENTO DEL 22% DAL 1968 AL 2021,
MA, IN RELAZIONE AI DIPLOMATICI UOMINI, LA SITUAZIONE È ANCORA SFAVOREVOLE AL LIVELLO GLOBALE */
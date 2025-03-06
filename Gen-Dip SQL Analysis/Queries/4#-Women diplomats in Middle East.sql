--COINVOLGIMENTO DELLE DONNE NEGLI INCARICHI DIPLOMATICI ORGANIZZATI DAL MEDIO ORIENTE


/* creazione di una tabella contenente l'associazione tra i codici attribuiti ai continenti dal dataset Gen_Dip e 
i nomi corrispondenti dalla tabella region_name */

CREATE TABLE if not exists gen_dip_nameregion AS(
SELECT g.*, r.region_name 
FROM gen_dip g
INNER JOIN region_name r
ON g.region_send = r.region_code);

/* nel dataset gen_dip è presente anche la suddivisione storica tra nord e sud dello Yemen, venuta meno nel 1990;
al fine di analizzare il paese allo stesso livello degli altri nel medesimo arco storico, i dati saranno accorpati
in questa Query */

UPDATE gen_dip_nameregion
SET cname_send = 'Yemen', cname_receive = 'Yemen'
WHERE cname_send LIKE '%Yemen%' OR cname_receive LIKE '%Yemen%';


-- creazione di una tabella temporanea con un confronto tra donne e uomini parte di missioni dimplomatiche dal Medio Oriente	dal 1968 al 2021

CREATE TEMPORARY TABLE if not exists middle_east_diplomats AS(
SELECT cname_send as ME_Country, COUNT(*) FILTER (WHERE gender=1) AS women_diplomats, COUNT(*) FILTER (WHERE gender=0) AS men_diplomats
FROM gen_dip_nameregion
WHERE region_name LIKE '%Middle East%'
GROUP BY cname_send
ORDER BY count(gender) ASC);


-- creazione di una tabella temporanea con il totale dei diplomatici inviati in missioni 

CREATE TEMPORARY TABLE if not exists middle_east_diplomats_perc AS(
SELECT *, COALESCE(women_diplomats,0)+COALESCE(men_diplomats,0) AS total_diplomats
FROM middle_east_diplomats);


-- confronto percentuale tra uomini e donne per comprendere se sono rilevati paesi con un gap minore

SELECT ME_country, (women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) AS women_perc, 
          (men_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) AS men_perc,
		  ((women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2)-(men_diplomats::numeric/total_diplomats::numeric)::numeric(10,2)) AS total_gap
FROM middle_east_diplomats_perc
ORDER BY total_gap ASC 


/* DAI DATI OTTENUTI SI EVINCE CHE NON CI SONO PAESI NEL MEDIO ORIENTE IN CUI IL GAP SIA MENO SIGNIFICATIVO; 
LA DIFFERENZA PERCENTUALE A SFAVORE DELLE DONNE NON È INFERIORE AL 70%, DUNQUE LE MISSIONI DIPLOMATICHE SONO SVOLTE PER LA
GRAN PARTE DAGLI UOMINI IN OGNI CASISTICA*/
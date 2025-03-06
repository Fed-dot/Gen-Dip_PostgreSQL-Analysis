--COINVOLGIMENTO DELLE DONNE NEGLI INCARICHI DIPLOMATICI ORGANIZZATI DALL'ASIA


/* creazione di una tabella contenente l'associazione tra i codici attribuiti ai continenti dal dataset Gen_Dip e
i nomi corrispondenti dalla tabella region_name */

CREATE TABLE if not exists gen_dip_nameregion AS(
SELECT g.*, r.region_name 
FROM gen_dip g
INNER JOIN region_name r
ON g.region_send = r.region_code);


/* nel dataset gen_dip è presente anche la suddivisione storica tra nord e sud del Vietnam;
al fine di analizzare il paese allo stesso livello degli altri nel medesimo arco storico, i dati saranno accorpati
in questa Query */

UPDATE gen_dip_nameregion
SET cname_send = 'Vietnam'
WHERE cname_send LIKE '%Viet%';


-- creazione di una tabella temporanea con un confronto tra donne e uomini parte di missioni dimplomatiche dal Medio Oriente	dal 1968 al 2021

CREATE TEMPORARY TABLE if not exists asia_diplomats AS(
SELECT cname_send as ME_Country, COUNT(*) FILTER (WHERE gender=1) AS women_diplomats, COUNT(*) FILTER (WHERE gender=0) AS men_diplomats
FROM gen_dip_nameregion
WHERE region_name LIKE '%Asia%'
GROUP BY cname_send
ORDER BY count(gender) ASC);


-- creazione di una tabella temporanea con il totale dei diplomatici inviati in missione 

CREATE TEMPORARY TABLE if not exists asia_diplomats_perc AS(
SELECT *, COALESCE(women_diplomats,0)+COALESCE(men_diplomats,0) AS total_diplomats
FROM asia_diplomats);

-- confronto percentuale tra uomini e donne per comprendere se sono rilevati paesi con un gap minore o maggiore

SELECT ME_country, (women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) AS women_perc, 
          (men_diplomats::numeric/total_diplomats::numeric)::numeric(10,2) AS men_perc,
		  ((women_diplomats::numeric/total_diplomats::numeric)::numeric(10,2)-(men_diplomats::numeric/total_diplomats::numeric)::numeric(10,2)) AS total_gap_perc
FROM asia_diplomats_perc
ORDER BY total_gap_perc ASC 
 

/*IL GAP TRA GLI UOMINI E LE DONNE IN ASIA RIMANE ALTO, SFIORANDO PICCHI FINO AL 100%, MA A CONTRARIO DEL MEDIO ORIENTE
SONO PRESENTI PAESI COME IL BHUTAN, LE FILIPPINE, LE MALDIVE E IL TIMOR-LESTE IN CUI LA PRESENZA DI DONNE NEGLI INCARICHI
DIPLOMATICI È SENSIBILMENTE MAGGIORE RISPETTO ALLA MEDIA DELLA POPOLAZIONE */
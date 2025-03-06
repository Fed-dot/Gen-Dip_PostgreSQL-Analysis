-- PERCENTUALE DI DIPLOMATICHE CHE RICOPRONO TITOLI SPECIFICI AL LIVELLO GLOBALE NEL XX E XXI SECOLO


-- select per collegare ogni diplomatica e diplomatico al proprio titolo, conteggiando quante donne e quanti uomini svolgono ed hanno svolto ogni ruolo, divisi per secolo


SELECT t.title_name,
	   COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=1 AND year<2000),0)+COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=0 AND year<2000),0) AS total_diplomats_XX_cen,
	   COUNT(g.gender) FILTER(WHERE g.gender=1 AND year<2000) AS women_diplomats_xx_cen,
	   ((COUNT(g.gender) FILTER(WHERE g.gender=1 AND year<2000)::numeric/(COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=1 AND year<2000),0)+COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=0 AND year<2000),0))::numeric))::numeric(10,2) AS women_diplomats_perc_XX_cen,
       COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=1 AND year>=2000),0)+COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=0 AND year>=2000),0) AS total_diplomats_XXI_cen,
	   COUNT(g.gender) FILTER(WHERE g.gender=1 AND year>=2000) AS women_diplomats_xxi_cen,
	   ((COUNT(g.gender) FILTER(WHERE g.gender=1 AND year>=2000)::numeric/(COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=1 AND year>=2000),0)+COALESCE(COUNT(g.gender) FILTER(WHERE g.gender=0 AND year>=2000),0))::numeric))::numeric(10,2) AS women_diplomats_perc_XXI_cen
FROM gen_dip g
LEFT JOIN title_recap t
ON g.title=t.title
WHERE t.title_name IS NOT NULL AND title_name <> 'missing' 
GROUP BY t.title_name
ORDER BY title_name ASC


/* DAL 1968 AL 2021 LA PERCENTUALE DI DIPLOMATICHE DISTRIBUITE NEI VARI TITOLI ASSEGNATI È AUMENTATA SENSIBILMENTE, MA LA DISPARITÀ DI GENERE 
RIMANE DIFFUSA NELLA MAGGIOR PARTE DEI TITOLI DIPLOMATICI, IN CUI LA PERCENTUALE DI DONNE DELLA POPOLAZIONE TOTALE NON SFIORA IL 30% AL 2021,
ECCETTO PER IL RUOLO DI "ACTING CHARGÉ D'AFFAIRES", IN  CUI LA PERCENTUALE DI DIPLOMATICHE È DEL 67% */
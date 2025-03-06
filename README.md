# Gen-Dip_PostgreSQL-Analysis

<br>
Progetto mirato alla gestione ed all'utilizzo del linguaggio SQL per la gestione di database relazionali e l'analisi dati.

<br>

Il dataset GenDip (Dataset on Gender and Diplomatic Representation), è stato creato da Birgitta Niklasson e Ann Towns, per approfondire come gli Stati hanno nominato diplomatici di diverso genere per diversi tipi di incarichi bilaterali e copre più di 200 Paesi e 10 anni specifici tra il 1968 e il 2021.

Per ogni diplomatico e anno, contiene informazioni come:

- Paese di invio: lo Stato che ha nominato il diplomatico.
- Paese di destinazione: la sede dell'incarico.
- Tipo di titolo diplomatico: per esempio, ambasciatore, ministro, ecc.
- Genere del diplomatico: che è “basato su titoli (per esempio signor/signora, principe/principessa, barone/baronessa ecc.), pronomi usati quando ci si riferisce al diplomatico o sul riconoscimento dei nomi come femminili o maschili”.

<br>

L’analisi è stata svolta attraverso il file .csv del dataset Gen_Dip e lo sviluppo di altre due tabelle con pgAdmin4, grazie ai dati forniti dal Codebook:
- tab “region_name”: inner join tra i codici dei continenti assegnati dal dataset Gen_Dip ed il loro nome.
- tab “title_name”: inner join tra i codici assegnati dal dataset Gen_ Dip ai titoli appartenenti ai diplomatici ed il loro nome.

DROP DATABASE IF EXISTS restoran;
CREATE DATABASE restoran;
USE restoran;

CREATE TABLE osoba (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    broj_mob VARCHAR(10),
    email VARCHAR(30)
);

CREATE TABLE zanimanje (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    placa_hrk DECIMAL(10, 2) DEFAULT 3750.00,
    CHECK (placa_hrk >= 3750.00)
);

CREATE TABLE djelatnik (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_osoba INTEGER NOT NULL,
    oib CHAR(11) NOT NULL,
    datum_rodenja DATE NOT NULL,
    datum_zaposlenja DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_zanimanje INTEGER NOT NULL,
    zaposlen CHAR(1) NOT NULL DEFAULT "D",
    CHECK (zaposlen IN("D", "N")),
    FOREIGN KEY (id_osoba) REFERENCES osoba (id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje (id),
    CONSTRAINT id_osoba_unique UNIQUE (id_osoba),
    CONSTRAINT oib_unique UNIQUE (oib)
);

CREATE TABLE adresa (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	drzava VARCHAR (50) NOT NULL,
	grad VARCHAR (50) NOT NULL,
	ulica VARCHAR (50) NOT NULL,
	post_broj VARCHAR(10) NOT NULL
);

CREATE TABLE dobavljac (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    id_adresa INTEGER NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    broj_mob VARCHAR(10) NOT NULL UNIQUE,
    vrsta_usluge VARCHAR(50) NOT NULL,
    FOREIGN KEY (id_adresa) REFERENCES adresa (id)
);
    
CREATE TABLE stol (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    broj_stola VARCHAR(4) NOT NULL,
    rajon_stola VARCHAR(4) NOT NULL,
    broj_gostiju_kapacitet INTEGER
);

CREATE TABLE nacini_placanja (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(10) NOT NULL
);
    
CREATE TABLE racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	sifra VARCHAR(10) NOT NULL,
    id_nacin_placanja INTEGER NOT NULL,
	id_stol INTEGER NOT NULL,
	id_djelatnik INTEGER NOT NULL,
	vrijeme_izdavanja DATETIME NOT NULL DEFAULT NOW(),
	iznos_hrk DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id_nacin_placanja) REFERENCES nacini_placanja (id),
    FOREIGN KEY (id_stol) REFERENCES stol (id),
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id)
);

CREATE TABLE alergen (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	naziv VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv_stavke VARCHAR(70) NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
    aktivno CHAR(1) DEFAULT "D",
    CHECK (aktivno IN ("D", "N"))
);
    
CREATE TABLE sadrzi_alergen (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_meni INTEGER NOT NULL,
    id_alergen INTEGER NOT NULL,
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    FOREIGN KEY (id_alergen) REFERENCES alergen (id)
);

CREATE TABLE kategorija_namirnica (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL
);
    
CREATE TABLE namirnica (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL UNIQUE,
    id_kategorija INTEGER NOT NULL,
    kolicina_na_zalihi DECIMAL (10, 2) NOT NULL,
    mjerna_jedinica VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_kategorija) REFERENCES kategorija_namirnica (id),
    CHECK (kolicina_na_zalihi >= 0)
);

CREATE TABLE stavka_meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_namirnica INTEGER NOT NULL,
    kolicina DECIMAL (10, 2),
    id_meni INTEGER NOT NULL,
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    UNIQUE (id_namirnica, id_meni),
    CHECK (kolicina > 0)
);

CREATE TABLE stavka_racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_racun INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    UNIQUE (id_racun, id_meni)
);

CREATE TABLE rezervacija (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_stol INTEGER NOT NULL,
	id_osoba INTEGER NOT NULL,
    zeljeni_datum DATE NOT NULL,
    vrijeme_od TIME NOT NULL,
    vrijeme_do TIME NOT NULL,
	broj_gostiju INTEGER NOT NULL,
	FOREIGN KEY (id_stol) REFERENCES stol (id),
	FOREIGN KEY (id_osoba) REFERENCES osoba (id)
);

CREATE TABLE catering_narucitelj (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_osoba INTEGER NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    FOREIGN KEY (id_osoba) REFERENCES osoba (id)
);

CREATE TABLE catering_zahtjev (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_narucitelj INTEGER NOT NULL,
    id_adresa INTEGER NOT NULL,
    opis TEXT,
    zeljeni_datum DATE NOT NULL,
    datum_zahtjeva TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_narucitelj) REFERENCES catering_narucitelj (id),
    FOREIGN KEY (id_adresa) REFERENCES adresa (id)
);

CREATE TABLE catering (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_zahtjev INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) DEFAULT 0.00,
    datum_izvrsenja TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    uplaceno CHAR(1) NOT NULL,
    FOREIGN KEY (id_zahtjev) REFERENCES catering_zahtjev (id),
    CHECK (uplaceno IN ("D", "N"))
);
    
CREATE TABLE catering_stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_catering INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_catering) REFERENCES catering (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    CHECK (kolicina > 0)
);

CREATE TABLE djelatnici_catering (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_catering INTEGER NOT NULL,
    id_djelatnik INTEGER NOT NULL,
    UNIQUE(id_catering, id_djelatnik),
    FOREIGN KEY (id_catering) REFERENCES catering (id),
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id)
);
    
CREATE TABLE nabava (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_dobavljac INTEGER NOT NULL,
    opis TEXT,
    iznos_hrk DECIMAL(10, 2) DEFAULT 0.00,
    podmireno CHAR(1) NOT NULL,
    datum DATE NOT NULL,
    FOREIGN KEY (id_dobavljac) REFERENCES dobavljac (id),
    CHECK (podmireno IN ("D", "N"))
);

CREATE TABLE nabava_stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_nabava INTEGER NOT NULL,
    id_namirnica INTEGER NOT NULL,
    kolicina DECIMAL(10, 2) NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (id_nabava) REFERENCES nabava (id),
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id),
    CHECK (kolicina > 0)
); 

CREATE TABLE otpis (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    datum TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    opis TEXT
);    

CREATE TABLE otpis_stavka (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_otpis INTEGER NOT NULL,
    id_namirnica INTEGER NOT NULL,
	kolicina DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (id_otpis) REFERENCES otpis (id),
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id),
    CHECK (kolicina > 0)
);    

CREATE TABLE kategorija_rezije (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE rezije (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    iznos_hrk DECIMAL(10, 2) NOT NULL,
    datum DATE NOT NULL,
    id_kategorija INTEGER NOT NULL,
    placeno CHAR(1) NOT NULL,
    FOREIGN KEY (id_kategorija) REFERENCES kategorija_rezije (id),
    CHECK (placeno IN ("D", "N"))
);

CREATE TABLE smjena (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR (50) NOT NULL, 
    pocetak_radnog_vremena TIME NOT NULL,
    kraj_radnog_vremena TIME NOT NULL
);    
    
CREATE TABLE djelatnik_smjena (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_djelatnik INTEGER NOT NULL,
	id_smjena INTEGER NOT NULL, 
	datum DATE NOT NULL,
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id),
    FOREIGN KEY (id_smjena) REFERENCES smjena (id)
);    

CREATE TABLE dostava (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_osoba INTEGER NOT NULL,
	id_adresa INTEGER NOT NULL, 
	datum DATE NOT NULL, 
	cijena_hrk DECIMAL(10, 2) DEFAULT 0.00,
	izvrsena CHAR(1) NOT NULL,
    FOREIGN KEY (id_osoba) REFERENCES osoba (id),
    FOREIGN KEY (id_adresa) REFERENCES adresa (id),
    CHECK (izvrsena IN ("D", "N"))
);

CREATE TABLE dostava_stavka (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_dostava INTEGER NOT NULL,
	id_meni INTEGER NOT NULL,
	kolicina INTEGER NOT NULL, 
	cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_dostava) REFERENCES dostava (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id),
    CHECK (kolicina > 0)
); 






-- /////////////////////////////////////////
-- //////////      TRIGGERI       //////////
-- /////////////////////////////////////////

-- Provjerava da li je količina namirnica na zalihi dostatna
-- Izračunava iznos stavke računa i ukupni iznos računa
-- Smanjuje količinu namirnica na zalihi
DROP TRIGGER IF EXISTS bi_stavka_racun;

DELIMITER //
CREATE TRIGGER bi_stavka_racun
    BEFORE INSERT ON stavka_racun
    FOR EACH ROW
BEGIN	
    DECLARE l_cijena_stavke DECIMAL (10, 2);
    
    CALL provjeri_kolicinu_na_zalihi(new.id_meni, new.kolicina);
    
    SELECT cijena_hrk INTO l_cijena_stavke
		FROM meni
        WHERE meni.id = new.id_meni;
        
	SET new.cijena_hrk = l_cijena_stavke * new.kolicina;
    
    UPDATE racun
		SET iznos_hrk = iznos_hrk + new.cijena_hrk
		WHERE id = new.id_racun;
        
	CALL smanji_kolicinu_na_zalihi(new.id_meni, new.kolicina);
END//
DELIMITER ;

-- Provjerava da li je količina namirnica na zalihi dostatna
-- Izračunava iznos stavke cateringa i ukupni iznos cateringa
-- Smanjuje količinu namirnica na zalihi
DROP TRIGGER IF EXISTS bi_catering_stavka;

DELIMITER //
CREATE TRIGGER bi_catering_stavka
    BEFORE INSERT ON catering_stavka
    FOR EACH ROW
BEGIN	
	DECLARE l_cijena_stavke DECIMAL (10, 2);
    
    CALL provjeri_kolicinu_na_zalihi(new.id_meni, new.kolicina);
    
    SELECT cijena_hrk INTO l_cijena_stavke
		FROM meni
        WHERE meni.id = new.id_meni;
        
	SET new.cijena_hrk = l_cijena_stavke * new.kolicina; 
    
    UPDATE catering
		SET cijena_hrk = cijena_hrk + new.cijena_hrk
		WHERE id = new.id_catering;
	
    CALL smanji_kolicinu_na_zalihi(new.id_meni, new.kolicina);
END//
DELIMITER ;

-- Izračunava ukupni iznos nabave
-- Povećava količinu namirnica na zalihi
DROP TRIGGER IF EXISTS bi_nabava_stavka;

DELIMITER //
CREATE TRIGGER bi_nabava_stavka
    BEFORE INSERT ON nabava_stavka
    FOR EACH ROW
BEGIN	
    UPDATE nabava
		SET iznos_hrk = iznos_hrk + new.cijena_hrk
		WHERE id = new.id_nabava;
	
    UPDATE namirnica
		SET kolicina_na_zalihi = kolicina_na_zalihi + new.kolicina
        WHERE namirnica.id = new.id_namirnica;
END//
DELIMITER ;
  
-- Provjerava da li je količina namirnica na zalihi dostatna
-- Izračunava iznos stavke dostave i ukupni iznos dostave
-- Smanjuje količinu namirnica na zalihi
DROP TRIGGER IF EXISTS bi_dostava_stavka;

DELIMITER //
CREATE TRIGGER bi_dostava_stavka
    BEFORE INSERT ON dostava_stavka
    FOR EACH ROW
BEGIN	
	DECLARE l_cijena_stavke DECIMAL (10, 2);
    
    CALL provjeri_kolicinu_na_zalihi(new.id_meni, new.kolicina);
    
    SELECT cijena_hrk INTO l_cijena_stavke
		FROM meni
        WHERE meni.id = new.id_meni;
        
	SET new.cijena_hrk = l_cijena_stavke * new.kolicina;
    
    UPDATE dostava
		SET cijena_hrk = cijena_hrk + new.cijena_hrk
		WHERE id = new.id_dostava;
        
	CALL smanji_kolicinu_na_zalihi(new.id_meni, new.kolicina);
END//
DELIMITER ;

-- Provjerava da li je količina namirnica na zalihi dostatna
-- Smanjuje količinu na zalihi
DELIMITER //
CREATE TRIGGER bi_otpis_stavka
	BEFORE INSERT ON otpis_stavka
    FOR EACH ROW
BEGIN

DECLARE l_kolicina_na_zalihi DECIMAL(10, 2);

SELECT kolicina_na_zalihi INTO l_kolicina_na_zalihi
	FROM namirnica
    WHERE id = new.id_namirnica;

	IF l_kolicina_na_zalihi - new.kolicina < 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = "Količina na zalihi preniska!";
	ELSE
		UPDATE namirnica
		SET kolicina_na_zalihi = kolicina_na_zalihi - new.kolicina
			WHERE new.id_namirnica = namirnica.id;
    END IF;
		
END//
DELIMITER ;




-- /////////////////////////////////////////
-- /////////      FUNKCIJE       ///////////
-- /////////////////////////////////////////

-- 1. Funkcija koja kreira šifru računa

DROP FUNCTION IF EXISTS kreiraj_sifru_racuna;

DELIMITER //
CREATE FUNCTION kreiraj_sifru_racuna (id_racuna INTEGER) RETURNS CHAR(6)
DETERMINISTIC
BEGIN

	IF (id_racuna BETWEEN 1 AND 9) THEN
		RETURN CONCAT("00000", id_racuna);
	ELSEIF (id_racuna BETWEEN 10 AND 99) THEN
		RETURN CONCAT("0000", id_racuna);
	ELSEIF (id_racuna BETWEEN 100 AND 999) THEN
		RETURN CONCAT("000", id_racuna);
	ELSEIF (id_racuna BETWEEN 1000 AND 9999) THEN
		RETURN CONCAT("00", id_racuna);
	ELSEIF (id_racuna BETWEEN 10000 AND 99999) THEN
		RETURN CONCAT("0", id_racuna);
	ELSEIF (id_racuna BETWEEN 100000 AND 999999) THEN
		RETURN CONVERT(id_racuna, CHAR);
    END IF;

END //
DELIMITER ;

/*
Primjer

SELECT kreiraj_sifru_racuna(53);
SELECT * FROM racun;
INSERT INTO racun (id, sifra, id_nacin_placanja, id_stol, id_djelatnik, vrijeme_izdavanja) VALUES
	(100001, kreiraj_sifru_racuna(id), 3, 5, 7, STR_TO_DATE('18.12.2020. 12:00:00', '%d.%m.%Y. %H:%i:%s'));
*/


-- 2. Funkcija koja kreira šifru računa u slučaju da koristimo autoincrement (ne prima id kao parametar)

DROP FUNCTION IF EXISTS kreiraj_sifru_racuna_autoincrement;

DELIMITER //
CREATE FUNCTION kreiraj_sifru_racuna_autoincrement () RETURNS CHAR(6)
DETERMINISTIC
BEGIN

	DECLARE novi_id INTEGER DEFAULT NULL;
    
    SELECT (id + 1) INTO novi_id
		FROM racun
		ORDER BY id DESC
		LIMIT 1;
        
	IF novi_id IS NULL THEN
		SET novi_id = 1;
	END IF;
        
	RETURN kreiraj_sifru_racuna(novi_id);

END //
DELIMITER ;

/*
Primjer

SELECT kreiraj_sifru_racuna_autoincrement();
SELECT * FROM racun;
INSERT INTO racun (sifra, id_nacin_placanja, id_stol, id_djelatnik, vrijeme_izdavanja) VALUES
	(kreiraj_sifru_racuna_autoincrement(), 3, 5, 7, STR_TO_DATE('18.12.2020. 12:00:00', '%d.%m.%Y. %H:%i:%s'));
*/


-- 3. Funkcija koja za uneseni datum i vrijeme vraća podatak o tome da li je određeni stol slobodan (nema rezervacije)

DROP FUNCTION IF EXISTS stol_dostupan;

DELIMITER //
CREATE FUNCTION stol_dostupan (p_id_stol INTEGER, p_datum DATE, p_vrijeme_od TIME, p_vrijeme_do TIME) RETURNS CHAR(2)
DETERMINISTIC
BEGIN

	IF (SELECT COUNT(*)
			FROM rezervacija
			WHERE zeljeni_datum = p_datum
				AND (p_vrijeme_od BETWEEN vrijeme_od AND vrijeme_do
				OR p_vrijeme_do BETWEEN vrijeme_od AND vrijeme_do)
				AND id_stol = p_id_stol) > 0
	THEN
		RETURN "NE";
	ELSE
		RETURN "DA";
	END IF;
	
END //
DELIMITER ;

/*
SELECT * FROM rezervacija;
SELECT stol_dostupan (1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "17:00", "19:00");
SELECT stol_dostupan (1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "17:00", "17:30");
*/


-- 4. Funkcija koja vraća da li je kapacitet nekog stola dovoljan za određen broj osoba

DROP FUNCTION IF EXISTS kapacitet_stola_dovoljan;

DELIMITER //
CREATE FUNCTION kapacitet_stola_dovoljan (p_id_stol INTEGER, p_broj_gostiju INTEGER) RETURNS CHAR(2)
DETERMINISTIC
BEGIN

IF (SELECT COUNT(*)
		FROM stol
		WHERE p_broj_gostiju <= broj_gostiju_kapacitet
		AND id = p_id_stol) = 1
	THEN
		RETURN "DA";
	ELSE
		RETURN "NE";
	END IF;

END //
DELIMITER ;

/*
SELECT *, kapacitet_stola_dovoljan(id, 6)
	FROM stol;
*/






-- /////////////////////////////////////////
-- ///////////      UPITI       ////////////
-- /////////////////////////////////////////

-- 1. Upit koji prikazuje ukupnu zaradu po mjesecima (racun + dostava + catering)

SELECT mjesec, SUM(ukupno) AS ukupna_zarada
	FROM (
		(SELECT CONCAT(MONTH(vrijeme_izdavanja), "/", YEAR(vrijeme_izdavanja)) AS mjesec, SUM(iznos_hrk) AS ukupno
			FROM racun
			GROUP BY mjesec)
		UNION ALL    
		(SELECT CONCAT(MONTH(datum), "/", YEAR(datum)) AS mjesec, SUM(cijena_hrk) AS ukupno
			FROM dostava
			GROUP BY mjesec)
		UNION ALL
		(SELECT CONCAT(MONTH(datum_izvrsenja), "/", YEAR(datum_izvrsenja)) AS mjesec, SUM(cijena_hrk) AS ukupno
			FROM catering
			GROUP BY mjesec)
	) AS zarade
    GROUP BY mjesec
    ORDER BY STR_TO_DATE((CONCAT("01/", mjesec)),'%d/%m/%Y') DESC;


-- 2. Upit koji prikazuje koje namirnice se najviše koriste u jelima na trenutno aktivnom meniju (uzimajući u obzir količinu
-- u kojoj se namirnice koriste)

SELECT namirnica.*
	FROM stavka_meni
    INNER JOIN namirnica
    ON namirnica.id = stavka_meni.id_namirnica
    INNER JOIN meni
    ON meni.id = stavka_meni.id_meni
    WHERE meni.aktivno = "D"
	GROUP BY id_namirnica
    ORDER BY SUM(kolicina) DESC
    LIMIT 3;


-- 3. Upit koji prikazuje sva jela i alergene koje sadrže (uz pomoć funkcije)

DROP FUNCTION IF EXISTS sadrzi_alergene;

DELIMITER //
CREATE FUNCTION sadrzi_alergene (p_id_meni INTEGER) RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
	RETURN (SELECT GROUP_CONCAT(" ", a.naziv)
				FROM meni m
				LEFT JOIN sadrzi_alergen sa
				ON m.id = sa.id_meni
				LEFT JOIN alergen a
				ON a.id = sa.id_alergen
				WHERE m.id = p_id_meni);
END //
DELIMITER ;

SELECT naziv_stavke AS jelo, sadrzi_alergene(id) AS alergeni_u_jelu
	FROM meni;


-- 4. Upit koji prikazuje sve stavke u meniju izdane na računima u ukupnoj količini većoj od 30

DROP FUNCTION IF EXISTS br_prodanih_veci_od;

DELIMITER //
CREATE FUNCTION br_prodanih_veci_od (p_id_meni INTEGER, p_kolicina INTEGER) RETURNS CHAR(2)
DETERMINISTIC
BEGIN
	IF p_kolicina < (SELECT SUM(kolicina)
						FROM stavka_racun
						WHERE id_meni = p_id_meni)
	THEN
		RETURN "DA";
	ELSE
		RETURN "NE";
	END IF;
END //
DELIMITER ;

SELECT *
	FROM meni
    HAVING br_prodanih_veci_od(id, 30) = "DA";


-- 5. Upit (funkcija) koji prikazuje broj izdanih računa između dva datuma

DROP FUNCTION IF EXISTS br_racuna_izmedu;

DELIMITER //
CREATE FUNCTION br_racuna_izmedu (p_datum_od DATETIME, p_datum_do DATETIME) RETURNS INTEGER
DETERMINISTIC
BEGIN
	RETURN (SELECT COUNT(*)
				FROM racun
				WHERE vrijeme_izdavanja
				BETWEEN p_datum_od AND p_datum_do);
END //
DELIMITER ;

SELECT br_racuna_izmedu(STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'));


-- 6. Upit koji prikazuje ime i prezime svakog zaposlenika, njihov email, posao koji obavljaju u restoranu i broj odrađenih sati
-- u prosincu 2021. godine

SELECT d.id, ime, prezime, email, z.naziv, COALESCE(SUM(HOUR(SUBTIME(kraj_radnog_vremena, pocetak_radnog_vremena))), 0) AS broj_odradenih_sati
	FROM djelatnik d
    LEFT JOIN osoba o
    ON d.id_osoba = o.id
    LEFT JOIN zanimanje z
    ON d.id_zanimanje = z.id
    LEFT JOIN djelatnik_smjena ds
    ON ds.id_djelatnik = d.id
    LEFT JOIN smjena s
    ON ds.id_smjena = s.id
    WHERE (YEAR(ds.datum) = 2021 AND MONTH(ds.datum) = 12) OR (ds.datum) IS NULL
    GROUP BY (d.id);
    
    
-- 7. Upit koji prikazuje iznos režija po kvartalu tijekom 2021. godine

SELECT CONCAT(kvartali.kvartal, ". kvartal") AS kvartal, COALESCE(tmp.ukupno, 0) AS ukupan_iznos
	FROM (SELECT 1 AS kvartal UNION SELECT 2 UNION SELECT 3 UNION SELECT 4) AS kvartali
			LEFT JOIN (SELECT QUARTER(datum) AS kvartal, SUM(iznos_hrk) AS ukupno
						FROM rezije
						WHERE YEAR(datum) = 2021
						GROUP BY QUARTER(datum)) AS tmp
			ON kvartali.kvartal = tmp.kvartal;


-- 8. Upit koji prikazuje sve namirnice sa dodatnim stupcem u kojem je navedeno da li je ta namirnica barem jednom otpisana,
-- te ako je, u kolikoj ukupnoj količini

SELECT namirnica.naziv, 
		(CASE WHEN otpis_stavka.id IS NOT NULL
			THEN "Postoji otpis za namirnicu"
			ELSE "Nema otpisa" END) AS otpis,
		COALESCE(SUM(otpis_stavka.kolicina), 0) AS otpisana_kolicina
	FROM namirnica
    LEFT JOIN otpis_stavka
    ON namirnica.id = otpis_stavka.id_namirnica
    GROUP BY namirnica.id
    ORDER BY otpis DESC;


-- 9. Upit koji prikazuje sve djelatnike koji su barem jednom bili gosti restorana (tj. ako su barem jednom napravili rezervaciju,
-- naručili catering ili dostavu)

SELECT osoba.*
	FROM djelatnik
    INNER JOIN osoba
    ON djelatnik.id_osoba = osoba.id
    WHERE osoba.id IN (SELECT DISTINCT id_osoba
							FROM rezervacija
						UNION    
						SELECT DISTINCT id_osoba
							FROM catering_narucitelj
						UNION    
						SELECT DISTINCT id_osoba
							FROM dostava);


-- 10. upit koji prikazuje zaradu po stolu u 2021. godine, te broj računa i broj srednja zarada po kapacitetu i računu (ako je taj broj nizak, to bi mogla biti indikacija da pozicija zbog nekog
-- razloga privlači manje grupe)

SELECT id_stol, zarada_stola, iznos_hrk, ROUND(zarada_stola/broj_racuna/broj_gostiju_kapacitet,2) as zarada_po_kapacitetu_i_računu
	FROM (SELECT id_stol, iznos_hrk, broj_gostiju_kapacitet, SUM(iznos_hrk) as zarada_stola, count(iznos_hrk) as broj_racuna
		FROM racun
		LEFT JOIN stol on racun.id_stol=stol.id
		WHERE (YEAR(vrijeme_izdavanja) = 2021)
		GROUP BY (id_stol)) as tmp
		ORDER BY (zarada_stola) DESC;
  
  
  -- 11. upit koji prikazuje datum kada je zadnje prodana svaka stavka menija
  
  SELECT naziv_stavke, MAX(temp.vrijeme_izdavanja) as zadnji_datum_prodaje
	FROM(SELECT vrijeme_izdavanja, naziv_stavke
			FROM racun
			LEFT JOIN stavka_racun
            ON racun.id= stavka_racun.id_racun
			LEFT JOIN meni
            ON stavka_racun.id_meni=meni.id) as temp
	group by temp.naziv_stavke
	order by zadnji_datum_prodaje DESC;
 
 
-- 12. Upit koji prikazuje prosječnu nabavnu cijenu za namirnice koje su se barem jednom nabavile

SELECT namirnica.naziv,
		CONCAT(ROUND((SUM(cijena_hrk) / SUM(kolicina)), 2), " kn / ", mjerna_jedinica) AS prosjecna_nabavna_cijena
	FROM nabava_stavka
    INNER JOIN namirnica
    ON namirnica.id = nabava_stavka.id_namirnica
    GROUP BY namirnica.id;
    

-- 13 upit koji prikazuje kategorija namirnica s najvećom potrošnjom po kvartalu

SELECT naziv as kategorija_namirnica, MAX(suma) as ukupna_potrosnja, 
CONCAT(
(CASE
 WHEN MONTH(vrijeme_izdavanja) IN (1,2,3)
 THEN "Kvartal 1. "
 WHEN MONTH(vrijeme_izdavanja) IN (4,5,6)
 THEN "Kvartal 2. "
  WHEN MONTH(vrijeme_izdavanja) IN (7,8,9)
 THEN "Kvartal 3. "
  WHEN MONTH(vrijeme_izdavanja) IN (10,11,12)
 THEN "Kvartal 4. "
 END),
 YEAR(vrijeme_izdavanja)) AS Kvartal
FROM
(SELECT naziv, vrijeme_izdavanja, TOT, SUM(TOT) as suma
FROM
(SELECT * 
FROM (SELECT stavka_meni.kolicina*stavka_racun.kolicina AS TOT, mjerna_jedinica, kategorija_namirnica.naziv, vrijeme_izdavanja 
	FROM stavka_meni
		JOIN stavka_racun
        ON stavka_meni.id_meni=stavka_racun.id_meni
		JOIN racun 
        ON stavka_racun.id_racun=racun.id
		JOIN namirnica 
        ON namirnica.id= stavka_meni.id_namirnica
		JOIN kategorija_namirnica 
        ON kategorija_namirnica.id= namirnica.id_kategorija) as temp
        WHERE mjerna_jedinica NOT IN ("komad")
UNION
SELECT *
FROM (SELECT stavka_meni.kolicina*stavka_racun.kolicina*.5 AS TOT, mjerna_jedinica, kategorija_namirnica.naziv, vrijeme_izdavanja 
	FROM stavka_meni
		JOIN stavka_racun
        ON stavka_meni.id_meni=stavka_racun.id_meni
		JOIN racun 
        ON stavka_racun.id_racun=racun.id
		JOIN namirnica 
        ON namirnica.id= stavka_meni.id_namirnica
		JOIN kategorija_namirnica 
        ON kategorija_namirnica.id= namirnica.id_kategorija) as temp
        WHERE mjerna_jedinica IN ("komad")) as temp
GROUP BY QUARTER (vrijeme_izdavanja), naziv) as temp
GROUP BY QUARTER (vrijeme_izdavanja);


-- 14. upit koji prikazuje cijenu sastojka svakog jela da su svi nabavljeni na najgoru cijenu dosad, te računa marginu za taj najgori slučaj.
-- Sastojci za koju nemamo upisanu nabavu su izabačeni, a jelo ako nemamo upisanu nabavu za nijedan sastojak

SELECT naziv_stavke, cijena_hrk, SUM(najveca_cijena*kolicina) AS najveca_cijena_sastojka, (cijena_hrk - najveca_cijena*kolicina) AS najmanja_margina,
(CASE WHEN (cijena_hrk - najveca_cijena*kolicina) >= 0
    THEN " "
    ELSE "Mogući gubitak!" END) AS napomena
FROM meni
JOIN stavka_meni
ON stavka_meni.id_meni=meni.id
LEFT JOIN 
(SELECT id_namirnica,
		MAX(cijena_hrk/kolicina) AS najveca_cijena
	FROM nabava_stavka
    INNER JOIN namirnica
    ON namirnica.id = nabava_stavka.id_namirnica
    GROUP BY namirnica.id) as temp
ON temp.id_namirnica=stavka_meni.id_namirnica
WHERE najveca_cijena IS NOT NULL
GROUP BY naziv_stavke
ORDER BY najmanja_margina
;


-- 15. upit koji prikazuje ukupne rashode po mjesecu (plaće+rezije+nabava)

SELECT mjesec, ukup+SUM(placa_hrk) as Ukupni_rashodi
FROM
(SELECT mjesec, SUM(ukupno) as ukup
	FROM (
		(SELECT CONCAT(MONTH(datum), "/", YEAR(datum)) AS mjesec, SUM(iznos_hrk) AS ukupno
			FROM rezije 
			GROUP BY mjesec)
		UNION ALL    
		(SELECT CONCAT(MONTH(datum), "/", YEAR(datum)) AS mjesec, SUM(iznos_hrk) AS ukupno
			FROM nabava
			GROUP BY mjesec)
	) AS zarade
    GROUP BY mjesec
    ORDER BY STR_TO_DATE((CONCAT("01/", mjesec)),'%d/%m/%Y') DESC) as temp
    JOIN djelatnik
    JOIN zanimanje
    ON zanimanje.id=djelatnik.id_zanimanje
    WHERE zaposlen="D"
    GROUP BY mjesec;
    ;


-- 16. upit koji računa srednju zaradu preko računa po danu podijeljena po satima

SELECT ROUND(SUM(tot)/(SELECT COUNT(DISTINCT DATE(vrijeme_izdavanja)) FROM racun), 2), sat
FROM
(SELECT SUM(iznos_hrk) as tot, HOUR(vrijeme_izdavanja) AS sat, COUNT(DATE(vrijeme_izdavanja)) AS datum
FROM racun
GROUP BY sat, vrijeme_izdavanja) AS temp
GROUP BY sat
ORDER BY sat;





-- /////////////////////////////////////////
-- //////////      POGLEDI       ///////////
-- /////////////////////////////////////////

-- 1. Pogled koji prikazuje trenutni meni

CREATE VIEW aktivni_meni AS
SELECT *
	FROM meni
    WHERE aktivno = "D";

-- SELECT * FROM aktivni_meni;
-- CALL obrisi_jelo(3);


-- 2. Pogled koji prikazuje sve cateringe u budućnosti (te za koje zahtjeve su vezani) zajedno sa brojem zaposlenika koji su
-- zaduženi za taj catering

CREATE VIEW nadolazeci_caterinzi AS
SELECT c.id catering_id,
		c.datum_izvrsenja,
        c.uplaceno,
        cz.id zahtjev_id,
        cz.zeljeni_datum,
        cz.datum_zahtjeva,
        COUNT(dc.id) AS broj_zaposlenika
	FROM catering c
	INNER JOIN djelatnici_catering dc
    ON c.id = dc.id_catering
    INNER JOIN catering_zahtjev cz
    ON c.id_zahtjev = cz.id
    WHERE datum_izvrsenja IS NULL
    GROUP BY c.id;

-- SELECT * FROM nadolazeci_caterinzi;


-- 3. Pogled koji prikazuje sve trenutne djelatnike

CREATE VIEW trenutni_djelatnici AS
	SELECT *
		FROM djelatnik
		WHERE zaposlen = "D";
        
-- SELECT * FROM trenutni_djelatnici;


-- 4. Pogled koji prikazuje goste koji su napravili najveći broj rezervacija, te prikazuje da li je ta osoba ujedno i zaposlenik

CREATE VIEW najveci_br_rezervacija AS
SELECT osoba.*, COUNT(*) AS broj_rezervacija,
		(CASE WHEN osoba.id IN (SELECT id_osoba FROM djelatnik)
			THEN "Da"
            ELSE "Ne" END) AS osoba_je_djelatnik
	FROM rezervacija
    INNER JOIN osoba
    ON osoba.id = rezervacija.id_osoba
    GROUP BY osoba.id
    ORDER BY broj_rezervacija DESC
    LIMIT 5;
    
-- SELECT * FROM najveci_br_rezervacija;
    

-- 5. Pogled koji prikazuje na koje adrese se najčešće vrši dostava

CREATE VIEW najcesce_adrese_dostave AS
SELECT adresa.*
	FROM dostava
    INNER JOIN adresa ON adresa.id = dostava.id_adresa
    GROUP BY adresa.id
    ORDER BY COUNT(*) DESC
    LIMIT 3;
    
-- SELECT * FROM najcesce_adrese_dostave;


-- 6. Pogled koji prikazuje prosječan iznos računa po mjesecu tijekom prošle godine

CREATE VIEW prosjecan_iznos_racuna AS
SELECT CONCAT(MONTH(vrijeme_izdavanja), "/", YEAR(vrijeme_izdavanja)) AS mjesec,
		ROUND(AVG(iznos_hrk), 2) AS prosjecan_iznos
	FROM racun
    WHERE YEAR(vrijeme_izdavanja) = YEAR(CURRENT_TIMESTAMP) - 1
    GROUP BY MONTH(vrijeme_izdavanja);

-- SELECT * FROM prosjecan_iznos_racuna;


-- 7. Pogled koji prikazuje namirnice čija je količina na zalihi niska u odnosu na količinu u kojoj se koriste u jelima
-- (tj. prikazuje namirnice koje bi trebalo nabaviti) - uzimaju se podaci jela izdanih na računima u periodu od zadnjih godinu dana

CREATE VIEW namirnice_za_nabavu AS
SELECT namirnica.naziv,
		namirnica.kolicina_na_zalihi,
        (kolicina * SUM(br_narucenih_jela)) AS utroseno_zadnjih_god_dana,
        (namirnica.kolicina_na_zalihi / (kolicina * SUM(br_narucenih_jela))) AS omjer
	FROM stavka_meni
    INNER JOIN (SELECT id_meni, SUM(kolicina) AS br_narucenih_jela
					FROM stavka_racun
					INNER JOIN racun ON racun.id = stavka_racun.id_racun
					WHERE vrijeme_izdavanja >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
					GROUP BY id_meni) AS br_narucenih_jela
	ON stavka_meni.id_meni = br_narucenih_jela.id_meni
    INNER JOIN namirnica ON namirnica.id = id_namirnica
    GROUP BY id_namirnica
    ORDER BY omjer ASC
    LIMIT 10;

-- SELECT * FROM namirnice_za_nabavu;

/*
-- ako gledamo samo kolicinu_na_zalihi bez obzira na to koliko se troši:
SELECT *
	FROM namirnica
    ORDER BY kolicina_na_zalihi ASC
    LIMIT 10;
*/









-- /////////////////////////////////////////
-- /////////      PROCEDURE       //////////
-- /////////////////////////////////////////

-- 1. Procedura koja za određeno jelo prikazuje koje namirnice se koriste i u kolikoj količini za to jelo

DROP PROCEDURE IF EXISTS sastojci;
DELIMITER //
CREATE PROCEDURE sastojci (IN p_id_meni INTEGER, OUT status_jela VARCHAR(100))
BEGIN
	DROP TABLE IF EXISTS sastojci_jela;
    CREATE TEMPORARY TABLE sastojci_jela (
		naziv_jela VARCHAR(70),
        naziv_namirnice VARCHAR(50),
        kolicina DECIMAL (10, 2),
        mjerna_jedinica VARCHAR(20),
        kolicina_na_zalihi DECIMAL (10, 2),
        status_jela VARCHAR(100)
    );
    
    SET status_jela = "Jelo se nalazi na trenutnom meniju.";
    
    IF (SELECT COUNT(*)
			FROM meni
			WHERE id = p_id_meni AND aktivno = "N") > 0
	THEN
		SET status_jela = "Jelo se ne nalazi u trenutnom meniju!";
	END IF;
    
 INSERT INTO sastojci_jela   
    SELECT meni.naziv_stavke, namirnica.naziv, stavka_meni.kolicina, mjerna_jedinica, kolicina_na_zalihi, status_jela
		FROM meni
		INNER JOIN stavka_meni
		ON meni.id = stavka_meni.id_meni
		INNER JOIN namirnica
		ON stavka_meni.id_namirnica = namirnica.id
		WHERE meni.id = p_id_meni;
END //
DELIMITER ;

/*
primjer
CALL sastojci(13, @status_jela);
SELECT * FROM sastojci_jela;
*/


-- 2. Procedura koja smanjuje količinu namirnica na zalihi za određeni meni

DROP PROCEDURE IF EXISTS smanji_kolicinu_na_zalihi;
DELIMITER //
CREATE PROCEDURE smanji_kolicinu_na_zalihi (IN p_id_meni INTEGER, IN p_kolicina_jela INTEGER)
BEGIN

DECLARE l_id_namirnica INTEGER;
DECLARE l_kolicina DECIMAL (10, 2);

DECLARE cur CURSOR FOR
	SELECT id_namirnica, kolicina
		FROM stavka_meni
		WHERE id_meni = p_id_meni;

DECLARE EXIT HANDLER FOR NOT FOUND BEGIN END;

OPEN cur;

smanji_kolicinu: LOOP
	FETCH cur INTO l_id_namirnica, l_kolicina;
    UPDATE namirnica
		SET kolicina_na_zalihi = kolicina_na_zalihi - l_kolicina * p_kolicina_jela
        WHERE namirnica.id = l_id_namirnica;
	END LOOP smanji_kolicinu;
    
CLOSE cur;

END //
DELIMITER ;

/*
provjera
CALL sastojci(1, @status_jela);
SELECT * FROM sastojci_jela;

CALL smanji_kolicinu_na_zalihi (1);
*/


-- 3. Procedura koja provjerava da li za određeno jelo postoji dovoljna količina namirnica na zalihi 

DROP PROCEDURE IF EXISTS provjeri_kolicinu_na_zalihi;
DELIMITER //
CREATE PROCEDURE provjeri_kolicinu_na_zalihi (IN p_id_meni INTEGER, IN p_kolicina_jela INTEGER)
BEGIN

DECLARE l_kolicina_na_zalihi DECIMAL (10, 2);
DECLARE l_id_namirnica INTEGER;
DECLARE l_naziv_namirnice VARCHAR (50);
DECLARE l_kolicina DECIMAL (10, 2);
DECLARE error_kolicina VARCHAR(100) DEFAULT "Količina na zalihi preniska za namirnicu: ";

DECLARE cur CURSOR FOR
	SELECT id_namirnica, kolicina
		FROM stavka_meni
		WHERE id_meni = p_id_meni;
        
DECLARE EXIT HANDLER FOR NOT FOUND BEGIN END;

OPEN cur;

provjeri_kolicinu: LOOP
	FETCH cur INTO l_id_namirnica, l_kolicina;
    SELECT kolicina_na_zalihi INTO l_kolicina_na_zalihi
		FROM namirnica
        WHERE id = l_id_namirnica;
    IF (l_kolicina_na_zalihi - l_kolicina * p_kolicina_jela) < 0 THEN
		SELECT naziv INTO l_naziv_namirnice
			FROM namirnica
			WHERE id = l_id_namirnica;
        SET error_kolicina = CONCAT(error_kolicina, l_naziv_namirnice);
        SIGNAL SQLSTATE "45000"
        SET MESSAGE_TEXT = error_kolicina;
    END IF;
END LOOP provjeri_kolicinu;

CLOSE cur;
    
END //
DELIMITER ;


-- 4. Procedura koja "briše" jelo s menija -> postavlja atribut 'aktivno' na "N"

DROP PROCEDURE IF EXISTS obrisi_jelo;
DELIMITER //
CREATE PROCEDURE obrisi_jelo (p_id_jela INTEGER)
BEGIN
	IF (SELECT COUNT(*)
			FROM meni
            WHERE id = p_id_jela) = 0
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jelo sa tim id-em ne postoji u tablici meni!';
	ELSEIF (SELECT COUNT(*)
			FROM meni
            WHERE id = p_id_jela
				AND aktivno = "N") = 1
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jelo je već neaktivno!';
	ELSE
		UPDATE meni
		SET aktivno = "N"
        WHERE id = p_id_jela;
    END IF;
END //
DELIMITER ;

/*
SELECT * FROM meni;
CALL obrisi_jelo(1);
*/


-- 5. Procedura koja dodaje jelo na meni

DROP PROCEDURE IF EXISTS dodaj_jelo;
DELIMITER //
CREATE PROCEDURE dodaj_jelo (p_naziv_stavke VARCHAR(70), p_cijena_hrk DECIMAL(10, 2))
BEGIN
	-- aktivno jelo s tim nazivom već postoji -> javlja grešku:
	IF (SELECT COUNT(*)
			FROM meni
			WHERE naziv_stavke = p_naziv_stavke
            AND aktivno = "D") > 0
	THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Jelo već postoji!';
	-- neaktivno jelo s tim nazivom već postoji -> aktivira ga:
	ELSEIF (SELECT COUNT(*)
			FROM meni
			WHERE naziv_stavke = p_naziv_stavke
				AND aktivno = "N") > 0
	THEN
		UPDATE meni
			SET aktivno = "D"
            WHERE naziv_stavke = p_naziv_stavke;
	-- inače, dodaje jelo:
    ELSE
		INSERT INTO meni (naziv_stavke, cijena_hrk) VALUES (p_naziv_stavke, p_cijena_hrk);
    END IF;
END //
DELIMITER ;

/*
SELECT * FROM meni;
CALL obrisi_jelo(1);
CALL dodaj_jelo("Jadranska orada sa žara s gratiniranim povrćem", 95.00);
CALL dodaj_jelo("Novo jelo", 125.99);
*/

-- 6. Procedura koja modificira tablicu stavka_meni za određeno jelo (uređuje popis namirnica za to jelo)
--    Ako je p_kolicina NULL, briše stavku

DROP PROCEDURE IF EXISTS uredi_stavka_meni;

DELIMITER //
CREATE PROCEDURE uredi_stavka_meni
(p_naziv_jela VARCHAR(70),
p_naziv_namirnice VARCHAR(50),
p_kolicina DECIMAL(10, 2),
OUT status_procedure VARCHAR(100))
BEGIN

DECLARE l_id_meni INTEGER DEFAULT NULL;
DECLARE l_id_namirnica INTEGER DEFAULT NULL;

SELECT id INTO l_id_meni
	FROM meni
	WHERE naziv_stavke = p_naziv_jela;
    
SELECT id INTO l_id_namirnica
	FROM namirnica
	WHERE naziv = p_naziv_namirnice;

IF l_id_meni IS NULL THEN
	SET status_procedure = "Jelo tog naziva ne postoji!";
ELSEIF l_id_namirnica IS NULL THEN
	SET status_procedure = "Namirnica tog naziva ne postoji!";
ELSEIF p_kolicina IS NULL THEN
	DELETE FROM stavka_meni
		WHERE id_namirnica = l_id_namirnica AND id_meni = l_id_meni;
	SET status_procedure = "Stavka obrisana!";
ELSEIF p_kolicina <= 0 THEN
	SET status_procedure = "Količina mora biti pozitivan broj!";
ELSEIF (SELECT COUNT(*)
		FROM stavka_meni
		WHERE id_namirnica = l_id_namirnica
			AND id_meni = l_id_meni) > 0
THEN
	SET status_procedure = "Već postoji unos za to jelo i namirnicu!";
ELSE
	INSERT INTO stavka_meni (id_namirnica, kolicina, id_meni) VALUES
		(l_id_namirnica, p_kolicina, l_id_meni);
	SET status_procedure = "Stavka dodana!";
END IF;

END //
DELIMITER ;

/*
CALL dodaj_jelo("Novo jelo", 125.99);

SELECT * FROM meni;

SELECT *
	FROM stavka_meni
    WHERE id_meni = (SELECT MAX(id) FROM meni);

-- Primjer za dodavanje stavki
CALL uredi_stavka_meni ("Novo jelo", "Krumpir", 0.3, @status_procedure);
SELECT @status_procedure FROM DUAL;
CALL uredi_stavka_meni ("Novo jelo", "Rajčica", 0.2, @status_procedure);
SELECT @status_procedure FROM DUAL;

-- Primjer za uklanjanje stavke
CALL uredi_stavka_meni ("Novo jelo", "Krumpir", NULL, @status_procedure);
SELECT @status_procedure FROM DUAL;
*/


-- 7. Procedura koja stvara novi zahtjev za catering

DROP PROCEDURE IF EXISTS stvori_catering_zahtjev;
DELIMITER //
CREATE PROCEDURE stvori_catering_zahtjev
(IN p_id_narucitelj INTEGER,
IN p_id_adresa INTEGER,
IN p_opis TEXT,
IN p_zeljeni_datum DATE,
OUT status_zahtjeva VARCHAR(100))
BEGIN

	DECLARE l_id_narucitelj INTEGER DEFAULT NULL;
	DECLARE l_id_adresa INTEGER DEFAULT NULL;

	SELECT id INTO l_id_narucitelj
		FROM catering_narucitelj
		WHERE id = p_id_narucitelj;
		
	SELECT id INTO l_id_adresa
		FROM adresa
		WHERE id = p_id_adresa;

	IF (p_zeljeni_datum) < CURRENT_TIMESTAMP THEN
		SET status_zahtjeva = "Zahtjev odbijen; željeni datum ne može biti u prošlosti!";
	ELSEIF l_id_narucitelj IS NULL THEN
		SET status_zahtjeva = "Zahtjev odbijen; naručitelj ne postoji u evidenciji!";
	ELSEIF l_id_adresa IS NULL THEN
		SET status_zahtjeva = "Zahtjev odbijen; adresa ne postoji u evidenciji!";
	ELSE
		INSERT INTO catering_zahtjev (id_narucitelj, id_adresa, opis, zeljeni_datum) VALUES
			(l_id_narucitelj, l_id_adresa, p_opis, p_zeljeni_datum);
		SET status_zahtjeva = "Catering zahtjev stvoren.";
	END IF;

END //
DELIMITER ;

/*
CALL stvori_catering_zahtjev(1, 1, NULL, STR_TO_DATE('15.02.2022.', '%d.%m.%Y.'), @status_zahtjeva);
SELECT @status_zahtjeva FROM DUAL;
SELECT * FROM catering_zahtjev;
SELECT * FROM catering_narucitelj;
SELECT * FROM adresa;
*/


-- 8. / 9. Procedure koja stvaraju novi otpis

DROP PROCEDURE IF EXISTS dodaj_stavku_za_otpis;
DELIMITER //
CREATE PROCEDURE dodaj_stavku_za_otpis (p_naziv_namirnice VARCHAR(50), p_kolicina DECIMAL(10, 2))
BEGIN

	DECLARE l_id_namirnica INTEGER DEFAULT NULL;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS tmp_otpis_stavka (
		id_namirnica INTEGER NOT NULL,
		kolicina DECIMAL(10, 2)
	);

	SELECT id INTO l_id_namirnica
		FROM namirnica
		WHERE naziv = p_naziv_namirnice;

	IF l_id_namirnica IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Namirnica sa tog naziva ne postoji!';
	ELSEIF p_kolicina <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Količina mora biti pozitivan broj!';
	ELSE
		INSERT INTO tmp_otpis_stavka VALUES (l_id_namirnica, p_kolicina);
	END IF;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS stvori_otpis;
DELIMITER //
CREATE PROCEDURE stvori_otpis ()
BEGIN

	DECLARE l_id_otpis INTEGER;
    DECLARE l_id_namirnica INTEGER;
    DECLARE l_kolicina DECIMAL(10, 2);
    
	DECLARE cur CURSOR FOR
		SELECT id_namirnica, kolicina
			FROM tmp_otpis_stavka;
            
	DECLARE EXIT HANDLER FOR NOT FOUND
	BEGIN
		DELETE FROM tmp_otpis_stavka;
	END;

	-- stvara novi otpis
	INSERT INTO otpis VALUES ();
    
    -- dohvaća id zadnje unesenog otpisa
    SELECT id INTO l_id_otpis
		FROM otpis
		ORDER BY id DESC
		LIMIT 1;
    
    OPEN cur;
    
    unesi_stavke: LOOP
		FETCH cur INTO l_id_namirnica, l_kolicina;
		INSERT INTO otpis_stavka (id_otpis, id_namirnica, kolicina)
			VALUES (l_id_otpis, l_id_namirnica, l_kolicina);
	END LOOP unesi_stavke;
    
	CLOSE cur;

END //
DELIMITER ;


-- Primjer izvođenja:
/*
CALL dodaj_stavku_za_otpis("Orada", 5.00);
CALL dodaj_stavku_za_otpis("Krumpir", 6.90);
CALL dodaj_stavku_za_otpis("Rajčica", 9.50);
SELECT * FROM tmp_otpis_stavka;
SELECT * FROM namirnica;
CALL stvori_otpis();
SELECT * FROM otpis;
SELECT * FROM otpis_stavka;
*/


-- 10. Procedura koja za upisani vrijeme i datum prikazuje djelatnike koji su bili na poslu

DROP PROCEDURE IF EXISTS prisustvo_radnika;
DELIMITER //
CREATE PROCEDURE prisustvo_radnika(IN p_datum DATE, p_sat TIME)
BEGIN
	DROP TABLE IF EXISTS prisutni_radnici;
    CREATE TEMPORARY TABLE prisutni_radnici(id_radnika INTEGER, ime VARCHAR(20), prezime VARCHAR(20), zanimanje VARCHAR(30));
	INSERT INTO prisutni_radnici
	SELECT djelatnik.id, osoba.ime, osoba.prezime, zanimanje.naziv
		FROM djelatnik
		JOIN osoba 
		ON djelatnik.id_osoba=osoba.id
		JOIN zanimanje
		ON djelatnik.id_zanimanje=zanimanje.id
		JOIN djelatnik_smjena
		ON djelatnik_smjena.id_djelatnik = djelatnik.id_osoba
        JOIN smjena
        ON djelatnik_smjena.id_smjena = smjena.id
        WHERE p_sat >= smjena.pocetak_radnog_vremena AND
        p_sat <= smjena.kraj_radnog_vremena AND
        djelatnik_smjena.datum = p_datum;
END //
DELIMITER ;

/*
Primjer izvođenja:
CALL prisustvo_radnika (STR_TO_DATE('15.12.2021.', '%d.%m.%Y.'), "10:00");
SELECT * FROM prisutni_radnici;
*/


-- 11. Procedura koja stornira zadani račun tako da stvori račun sa jednakim i negativnim stavkama

DROP PROCEDURE IF EXISTS storno_racuna;
DELIMITER //
CREATE PROCEDURE storno_racuna(IN p_id INTEGER, p_djelatnik INTEGER)
BEGIN
DECLARE l_id INTEGER;
DECLARE l_datum DATETIME;
DECLARE l_stol INTEGER;
DECLARE l_plac INTEGER;
DECLARE l_id2 INTEGER;
DECLARE size INTEGER;
DECLARE begginning INTEGER;
DECLARE meni INTEGER;
DECLARE l_kolicina INTEGER;



SET l_id= (SELECT MAX(id)+1 FROM racun);
SET l_datum = (SELECT vrijeme_izdavanja FROM racun WHERE id=p_id);
SET l_stol = (SELECT id_stol FROM racun WHERE id=p_id);
SET l_plac = (SELECT id_nacin_placanja FROM racun WHERE id=p_id);
SET l_id2= (SELECT MAX(id)+1 FROM stavka_racun);


INSERT INTO racun VALUES(l_id, kreiraj_sifru_racuna_autoincrement(), l_plac, l_stol, p_djelatnik, l_datum, 0);
SELECT COUNT(id_meni) FROM stavka_racun WHERE id_racun=p_id INTO size;
SELECT MIN(id) FROM stavka_racun WHERE id_racun=p_id INTO begginning;

REPEAT
SELECT id_meni FROM (SELECT MIN(id), id_meni FROM stavka_racun WHERE id_racun=p_id)AS temp INTO meni;
SELECT kolicina FROM stavka_racun WHERE begginning=id INTO l_kolicina;
INSERT INTO stavka_racun VALUES(l_id2,l_id, meni, -l_kolicina, 0); -- INSERT INTO stavka_racun VALUES(l_id2,l_id, meni, kolicina, 0);
SET l_id2=l_id2+1;
SET begginning=begginning+1;
SET size=size-1;
UNTIL size<=0
END REPEAT;


END //
DELIMITER ;


/* testiranje
CALL storno_racuna(28, 7);
SELECT * FROM stavka_racun
Order by id_racuna*/


-- 12. Procedura koja za određeni catering u privremenu tablicu sprema sve zaposlenike koji su zaduženi za taj catering

DROP PROCEDURE IF EXISTS prikazi_djelatnike_catering;

DELIMITER //
CREATE PROCEDURE prikazi_djelatnike_catering (p_id_catering INTEGER)
BEGIN

DROP TABLE IF EXISTS tmp_djelatnici_catering;
CREATE TEMPORARY TABLE tmp_djelatnici_catering (
	ime VARCHAR(50),
    prezime VARCHAR(50),
    broj_mob VARCHAR(10),
    email VARCHAR(30),
    oib CHAR(11),
    datum_zaposlenja DATE
);

INSERT INTO tmp_djelatnici_catering
	SELECT osoba.ime, osoba.prezime, osoba.broj_mob, osoba.email, djelatnik.oib, djelatnik.datum_zaposlenja
		FROM djelatnici_catering
		INNER JOIN djelatnik ON djelatnik.id = id_djelatnik
		INNER JOIN osoba ON osoba.id = id_osoba
		WHERE id_catering = p_id_catering;

END //
DELIMITER ;

/*
CALL prikazi_djelatnike_catering(1);
SELECT * FROM tmp_djelatnici_catering;
*/


-- 13. Procedura koja postavlja datum_izvrsenja za određeni catering na trenutni datum (ako kao parametar p_datum_izvrsenja primi NULL),
-- a inače postavlja datum_izvrsenja na vrijednost tog parametra

DROP PROCEDURE IF EXISTS postavi_datum_izvrsenja_catering;

DELIMITER //
CREATE PROCEDURE postavi_datum_izvrsenja_catering (p_id_catering INTEGER, p_datum_izvrsenja DATE, OUT p_status VARCHAR(100))
BEGIN

	DECLARE l_id_catering INTEGER DEFAULT NULL;
    DECLARE l_datum_izvrsenja DATE DEFAULT NULL;

	SELECT id, datum_izvrsenja INTO l_id_catering, l_datum_izvrsenja
		FROM catering
        WHERE id = p_id_catering;
        
	IF l_id_catering IS NULL THEN
		SET p_status = "Catering sa tim id-em ne postoji!";
	ELSEIF l_datum_izvrsenja IS NOT NULL THEN
		SET p_status = "Catering već ima datum izvršenja!";
	ELSEIF p_datum_izvrsenja IS NULL THEN
		UPDATE catering
			SET datum_izvrsenja = CURRENT_TIMESTAMP
            WHERE id = l_id_catering;
		SET p_status = CONCAT("Postavljen datum izvršenja na današnji datum za catering s id-em: ", l_id_catering);
    ELSEIF p_datum_izvrsenja > CURRENT_TIMESTAMP THEN
		SET p_status = "Datum izvršenja ne može biti u budućnosti!";
	ELSE
		UPDATE catering
			SET datum_izvrsenja = p_datum_izvrsenja
            WHERE id = l_id_catering;
		SET p_status = CONCAT("Postavljen datum izvršenja na ", p_datum_izvrsenja,  " za catering s id-em: ", l_id_catering);
    END IF;
    
END //
DELIMITER ;

/*
SELECT * FROM catering;
CALL postavi_datum_izvrsenja_catering(3, NULL, @p_status);
SELECT @p_status FROM DUAL;
CALL postavi_datum_izvrsenja_catering(4, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), @p_status);
SELECT @p_status FROM DUAL;
*/


-- 14. Procedura za kreiranje rezervacije

DROP PROCEDURE IF EXISTS kreiraj_rezervaciju;

DELIMITER //
CREATE PROCEDURE kreiraj_rezervaciju
(p_id_stol INTEGER,
p_id_osoba INTEGER,
p_zeljeni_datum DATE,
p_vrijeme_od TIME,
p_vrijeme_do TIME,
p_broj_gostiju INTEGER,
OUT status_rezervacije VARCHAR(100))
BEGIN

DECLARE l_id_stol INTEGER DEFAULT NULL;
DECLARE l_id_osoba INTEGER DEFAULT NULL;

SELECT id INTO l_id_osoba
	FROM osoba
    WHERE id = p_id_osoba;
    
SELECT id INTO l_id_stol
	FROM stol
    WHERE id = p_id_stol;

IF l_id_osoba IS NULL THEN
	SET status_rezervacije = "Osoba sa navedenim id-em ne postoji!";
ELSEIF l_id_stol IS NULL THEN
	SET status_rezervacije = "Stol sa navedenim id-em ne postoji!";
ELSEIF p_broj_gostiju <= 0 THEN
	SET status_rezervacije = "Broj gostiju mora biti pozitivan broj!";
ELSEIF p_zeljeni_datum < CURRENT_TIMESTAMP THEN
	SET status_rezervacije = "Željeni datum mora biti u budućnosti!";
ELSEIF p_vrijeme_od < "10:00" OR p_vrijeme_do > "23:00" THEN
	SET status_rezervacije = "Željeno vrijeme nije unutar radnog vremena restorana!";
ELSEIF kapacitet_stola_dovoljan(p_id_stol, p_broj_gostiju) = "NE" THEN
	SET status_rezervacije = "Broj gostiju prevelik za odabrani stol!";
ELSEIF (stol_dostupan (p_id_stol, p_zeljeni_datum, p_vrijeme_od, p_vrijeme_do)) = "NE" THEN
	SET status_rezervacije = "Odabrani stol je zauzet u željenom vremenu!";
ELSE
	INSERT INTO rezervacija (id_stol, id_osoba, zeljeni_datum, vrijeme_od, vrijeme_do, broj_gostiju)
		VALUES (l_id_stol, l_id_osoba, p_zeljeni_datum, p_vrijeme_od, p_vrijeme_do, p_broj_gostiju);
	SET status_rezervacije = "Rezervacija kreirana!";
END IF;

END //
DELIMITER ;

/*
SELECT * FROM rezervacija;

INSERT INTO rezervacija (id_stol, id_osoba, zeljeni_datum, vrijeme_od, vrijeme_do, broj_gostiju) VALUES
	(1, 1, STR_TO_DATE('01.04.2022.', '%d.%m.%Y.'), "18:00", "23:00", 4);
    
CALL kreiraj_rezervaciju(1, 35, STR_TO_DATE('01.04.2022.', '%d.%m.%Y.'), "17:00", "17:30", 10, @status_rezervacije);

SELECT @status_rezervacije FROM DUAL;
*/


-- 15. Procedura za dodavanje novog djelatnika

DROP PROCEDURE IF EXISTS dodaj_djelatnika;

DELIMITER //
CREATE PROCEDURE dodaj_djelatnika
(p_ime VARCHAR(50),
p_prezime VARCHAR(50),
p_broj_mob VARCHAR(10),
p_email VARCHAR (30),
p_oib CHAR(11),
p_datum_rodenja DATE,
p_id_zanimanje INTEGER,
OUT status_transakcije VARCHAR(100))
BEGIN

DECLARE l_id_osoba INTEGER;

DECLARE unique_ogranicenje_prekrseno CONDITION FOR 1062;
DECLARE zanimanje_ne_postoji CONDITION FOR 1452;

DECLARE EXIT HANDLER FOR unique_ogranicenje_prekrseno
	BEGIN
		ROLLBACK;
			SET status_transakcije = CONCAT("Već postoji djelatnik sa oib-om: ", p_oib);
    END;
    
DECLARE EXIT HANDLER FOR zanimanje_ne_postoji
	BEGIN
		ROLLBACK;
		SET status_transakcije = "Zanimanje sa tim id-em ne postoji!";
	END;

SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;

INSERT INTO osoba (ime, prezime, broj_mob, email) VALUES
	(p_ime, p_prezime, p_broj_mob, p_email);
    
SELECT MAX(id) INTO l_id_osoba
	FROM osoba;

INSERT INTO djelatnik (id_osoba, oib, datum_rodenja, id_zanimanje) VALUES
	(l_id_osoba, p_oib, p_datum_rodenja, p_id_zanimanje);
    
SET status_transakcije = "Djelatnik dodan!";

COMMIT;

END //
DELIMITER ;

/*
SELECT * FROM osoba;
SELECT * FROM djelatnik;

CALL dodaj_djelatnika
	("Ime", "Prezime", "1234567", "a@a.com", "56214852651", STR_TO_DATE('22.11.1988.', '%d.%m.%Y.'), 1, @status_transakcije);
SELECT @status_transakcije FROM DUAL; -- postojeći oib

CALL dodaj_djelatnika
	("Ime", "Prezime", "1234567", "a@a.com", "56214812345", STR_TO_DATE('22.11.1988.', '%d.%m.%Y.'), 555, @status_transakcije); 
SELECT @status_transakcije FROM DUAL; -- nepostojeće zanimanje

CALL dodaj_djelatnika
	("Ime", "Prezime", "1234567", "a@a.com", "56214812345", STR_TO_DATE('22.11.1988.', '%d.%m.%Y.'), 1, @status_transakcije);
SELECT @status_transakcije FROM DUAL; -- djelatnik dodan
*/

-- Procedure 16/17 koje stvaraju stavku za nabavu
DROP PROCEDURE IF EXISTS dodaj_stavku_za_nabavu;
DELIMITER //
CREATE PROCEDURE dodaj_stavku_za_nabavu (p_naziv_namirnice VARCHAR(50), p_kolicina DECIMAL(10, 2), p_cijena_hrk NUMERIC(10,2))
BEGIN

	DECLARE l_id_namirnica INTEGER DEFAULT NULL;
    
	
    CREATE TEMPORARY TABLE IF NOT EXISTS tmp_nabava_stavka (
		id_namirnica INTEGER NOT NULL,
		kolicina DECIMAL(10, 2),
        cijena_hrk NUMERIC(10,2)
	);

	SELECT id INTO l_id_namirnica
		FROM namirnica
		WHERE naziv = p_naziv_namirnice;

	IF l_id_namirnica IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Namirnica sa tog naziva ne postoji!';
	ELSEIF p_kolicina <= 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Količina mora biti pozitivan broj!';
	ELSEIF p_cijena_hrk = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cijena ne može biti negativna!';
	ELSE
		INSERT INTO tmp_nabava_stavka VALUES (l_id_namirnica, p_kolicina, p_cijena_hrk);
	END IF;

END //
DELIMITER ;


DROP PROCEDURE IF EXISTS stvori_nabavu;
DELIMITER //
CREATE PROCEDURE stvori_nabavu (p_dobavljac INTEGER, p_opis VARCHAR(300), p_podmireno CHAR(1), p_datum DATE)
BEGIN

	DECLARE l_id_nabava INTEGER;
    DECLARE l_id_namirnica INTEGER;
    DECLARE l_kolicina DECIMAL(10, 2);
    DECLARE l_cijena NUMERIC(10, 2);
    
	DECLARE cur CURSOR FOR
		SELECT id_namirnica, kolicina, cijena_hrk
			FROM tmp_nabava_stavka;
            
	DECLARE EXIT HANDLER FOR NOT FOUND
		BEGIN
			DELETE FROM tmp_nabava_stavka;
		END;
	IF p_dobavljac IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Obavezan je upis dobavljaca!';
	ELSEIF p_podmireno NOT IN('D', 'N') THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status podmireno more biti "D" ili "N"!';
	ELSEIF p_datum IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Obavezan je upis datuma!';
	ELSE
		
		
		INSERT  INTO  nabava (id_dobavljac, opis, podmireno, datum)
		VALUES (p_dobavljac, p_opis, p_podmireno, p_datum);
    
		-- dohvaća id zadnje unesene nabave
		SELECT id INTO l_id_nabava
			FROM nabava
			ORDER BY id DESC
			LIMIT 1;
    
		OPEN cur;
    
		unesi_stavke: LOOP
			FETCH cur INTO l_id_namirnica, l_kolicina, l_cijena;
			INSERT INTO nabava_stavka (id_nabava, id_namirnica, kolicina, cijena_hrk)
				VALUES (l_id_nabava, l_id_namirnica, l_kolicina, l_cijena);
		END LOOP unesi_stavke;
    
		CLOSE cur;
	END IF;

END //
DELIMITER ;

-- Primjer izvođenja:
/*
CALL dodaj_stavku_za_nabavu("fuži", 50, 400.00);
CALL dodaj_stavku_za_nabavu("paprika", 10, 50);
SELECT * FROM tmp_nabava_stavka;
SELECT * FROM namirnica;
CALL stvori_nabavu(10, "nabava fuža i paprika", "D", STR_TO_DATE('22.11.2021.' , '%d.%m.%Y.'));
SELECT * FROM nabava;
SELECT * FROM nabava_stavka;
*/
-- stvori nabavu provjerava unose, ali se tablica tmp_nabava_stavka prazni neovisno o prolasku, što bi moglo biti irritantno za koristiti, ali smanjuje šansu duplih unosa

-- 18. procedura koji stavlja zadanu nabavu u status podmireno

DROP PROCEDURE IF EXISTS podmiri_nabavu;
DELIMITER //
CREATE PROCEDURE podmiri_nabavu (p_id INTEGER)
BEGIN

DECLARE l_podmireno CHAR(1);

SELECT podmireno INTO l_podmireno
FROM nabava
WHERE p_id=id;
IF l_podmireno='D'THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'nabava je već u statusu podmireno!'; 
ELSEIF l_podmireno IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ne postoji nabava sa zadani ID-om!';
ELSE
	UPDATE nabava
    SET podmireno='D'
    WHERE id=p_id;
END IF;
END //
DELIMITER ;

-- primjer izvođenja. 
/*
SELECT * FROM nabava;
CALL podmiri_nabavu(6);
SELECT * FROM nabava;
*/

-- 19. procedura koji stavlja zadanu reziju u status podmireno

DROP PROCEDURE IF EXISTS podmiri_reziju;
DELIMITER //
CREATE PROCEDURE podmiri_reziju (p_id INTEGER)
BEGIN

DECLARE l_placeno CHAR(1);

SELECT placeno INTO l_placeno
FROM rezije
WHERE p_id=id;
IF l_placeno='D'THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'režija je već u statusu podmireno!'; 
ELSEIF l_placeno IS NULL THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'ne postoji režija sa zadani ID-om!';
ELSE
	UPDATE rezije
    SET placeno='D'
    WHERE id=p_id;
END IF;
END //
DELIMITER ;

-- primjer izvođenja
/*
SELECT * FROM rezije;
CALL podmiri_reziju(34);
SELECT * FROM rezije;
*/









-- /////////////////////////////////////////
-- //////////      INSERTOVI       /////////
-- /////////////////////////////////////////

-- id, ime, prezime, broj_mob, email
INSERT INTO osoba VALUES
	(1, "Ana", "Anić", "0975698542", "anaanic@gmail.com"),
    (2, "Milena", "Kakoli", "0911122334", "kakolisepreziva@mojamilena.com"),
    (3, "Marko", "Afrić", "092785425", "mafric@gmail.com"),
    (4, "Ive", "Kacavida", "099456585", "krizna_glava@gmail.com"),
    (5, "Slavica", "Sladić", "098452457", "1s_s1@hotmail.com"),
    (6, "Gertruda", "Bitić", "097456285", "bitic.g@yahoo.com"),
    (7, "Jasmina", "Starvos", "09874525", "mawa_crnka@net.hr"),
    (8, "David", "Bekam", "0913322554", "dbek47@gmail.com"),
    (9, "Roberto", "Fagioli", "0925544125", "fagioli.r@outlook.com"),
    (10, "Serđo", "Valić", "09236525", "rimonika885@gmail.com"),
    (11, "Melisa", "Fabijanić", "099542618", "melyf@gmail.com"),
    (12, "Lejla", "Ačimović", "091556512", "laci1@gmail.com"),
    (13, "Vanesa", "Gojtanić", "09745524", "vanesag@gmail.com"),
    (14, "Marina", "Lakošeljac", "01556442", "marina111@hotmail.com"),
    (15, "Ana", "Belac", "0984525", "ana_baana@gmail.com"),
    (16, "Igor", "Mijandrušić", "0994526", "igorm54@gmail.com"),
    (17, "Žarko", "Miletić", "09145265", "zac@hotmail.com"),
    (18, "Natanel", "Vitasović", "092665522", "vitan@net.hr"),
    (19, "Ivan", "Bernobić", "09733526", "bero69@gmail.com"),
    (20, "Nikola", "Krajcar", "099263255", "nix@outlook.com"),
    (21, "Franko", "Peruško", "0994525", "frankop33@gmail.com"),
    (22, "Šime", "Lanča", "095566221", "slanaca@gmail.com"),
    (23, "Kate", "Matošević", "098325625", "mato_sevic@gmail.com"),
    (24, "Marija", "Švić", "092889897", "maricka@yahoo.com"),
    (25, "Lorena", "Kocijančić", "0915006002", "lory89@gmail.com"),
    (26, "Dimitri", "Grgeta", "0912236544", "ultron1@gmail.com"),
    (27, "Leon", "Maružin", "098001145", "leon.m@gmail.com"),
    (28, "Erik", "Višković", "09755226", "eviskovic1@gmail.com"),
    (29, "Mirko", "Mikac", "091330311", "mik_mik@gmail.com"),
    (30, "Slavko", "Mikac", "091330312", "smik_smik@gmail.com"),
    (31, "Frane", "Kosir", "0916471320", "f.kosir@gmail.com"),
    (32, "Vesna", "Petrović", "0991233211", "vpetrovic@tvnova.hr"),
    (33, "Igor", "Pamić", "0915554444", "boskarin@outlook.com"),
    (34, "Rino", "Pavletić", "0951234444", "rpavletic@gmail.com"),
    (35, "Zlatan", "Ibrahimović", "0990001111", "ibro@gmail.com"),
    (36, "Drago", "Orlić", "0943331212", "orlic.drago@gmail.com"),
    (37, "Dragan", "Matika", "0976661233", "matika@hotmail.com"),
    (38, "Tone", "Štraca", "0912223333", "tonestraca@gmail.com"),
    (39, "Daniele", "Portafoglio", "0995551111", "daniele@gmail.com"),
    (40, "Zorica", "Rankun", "0910997777", "zoryy@gmail.com"),
    (41, "Matko", "Batko", "092452451", "batak@gmail.com"),
    (42, "Toto", "Wolf", "0914559952", "no_michael@gmail.com"),
    (43, "Lidija", "Bačić", "0994179793", "lile69@gmail.com"),
    (44, "Verbatim", "Traxdata", "097004300", "dvd_rw@gmail.com"),
    (45, "Alen", "Vitasović", "099236525", "bevanda033@yahoo.com"),
    (46, "Philosophia", "Uremović", "0914455268", "phil@gmail.com"),
    (47, "Đorđe", "Čika", "0996200352", "djcika@gmail.com"),
    (48, "Verica", "Kramar", "092458522", "krama98@gmail.com"),
    (49, "Magdalena", "Efrem", "098452564", "megi774@gmail.com"),
    (50, "Maja", "Šipak", "098125256", "cajic@hotmail.com");
    

-- id, naziv, placa_hrk
INSERT INTO zanimanje VALUES   
	(1, "kuhar", 9054.45),
	(2, "konobar", 8640.85),
    (3, "pomoćni kuhar", 4654.45),
    (4, "pomoćni konobar", 4654.45),
    (5, "servir", 4551.23),
    (6, "operater na posuđu", 6054.45),
    (7, "barmen", 6054.45),
    (8, "poslovođa", 16054.75),
    (9, "skladištar", 7453.65),
    (10, "dostavljač", 8135.24),
    (11, "blagajnik", 7500.00);

-- id, id_osoba, oib, datum_rodenja, datum_zaposlenja, id_zanimanje
INSERT INTO djelatnik VALUES
	(1, 1, "56214852651", STR_TO_DATE('22.11.1988.', '%d.%m.%Y.'), STR_TO_DATE('19.05.2021.', '%d.%m.%Y.'), 2, "D"),
	(2, 2, "42685138412", STR_TO_DATE('13.05.1978.', '%d.%m.%Y.'), STR_TO_DATE('15.03.2018.', '%d.%m.%Y.'), 1, "D"),
	(3, 3, "87426514895", STR_TO_DATE('11.11.1999.', '%d.%m.%Y.'), STR_TO_DATE('17.04.2021.', '%d.%m.%Y.'), 3, "D"),
    (4, 4, "93571964576", STR_TO_DATE('04.09.1970.', '%d.%m.%Y.'), STR_TO_DATE('04.04.2015.', '%d.%m.%Y.'), 1, "D"),
    (5, 5, "48654207991", STR_TO_DATE('11.11.1991.', '%d.%m.%Y.'), STR_TO_DATE('24.01.2017.', '%d.%m.%Y.'), 2, "D"),
    (6, 6, "24600726742", STR_TO_DATE('21.01.1986.', '%d.%m.%Y.'), STR_TO_DATE('19.08.2019.', '%d.%m.%Y.'), 2, "D"),
    (7, 7, "39839635272", STR_TO_DATE('18.10.2003.', '%d.%m.%Y.'), STR_TO_DATE('22.06.2016.', '%d.%m.%Y.'), 11, "D"),
    (8, 8, "22911268228", STR_TO_DATE('08.04.1988.', '%d.%m.%Y.'), STR_TO_DATE('22.03.2017.', '%d.%m.%Y.'), 3, "D"),
    (9, 9, "37746108986", STR_TO_DATE('05.03.1973.', '%d.%m.%Y.'), STR_TO_DATE('22.03.2017.', '%d.%m.%Y.'), 4, "D"),
    (10, 10, "27772129672", STR_TO_DATE('16.01.1980.', '%d.%m.%Y.'), STR_TO_DATE('07.01.2016.', '%d.%m.%Y.'), 3, "D"),
    (11, 11, "11299270874", STR_TO_DATE('04.11.1982.', '%d.%m.%Y.'), STR_TO_DATE('15.11.2019.', '%d.%m.%Y.'), 4, "D"),
    (12, 12, "57834292478", STR_TO_DATE('01.09.1992.', '%d.%m.%Y.'), STR_TO_DATE('19.08.2019.', '%d.%m.%Y.'), 3, "D"),
    (13, 13, "36828047884", STR_TO_DATE('18.05.1989.', '%d.%m.%Y.'), STR_TO_DATE('28.06.2020.', '%d.%m.%Y.'), 4, "D"),
    (14, 14, "91290805782", STR_TO_DATE('21.07.1982.', '%d.%m.%Y.'), STR_TO_DATE('10.03.2019.', '%d.%m.%Y.'), 5, "D"),
    (15, 15, "10740162574", STR_TO_DATE('02.12.1990.', '%d.%m.%Y.'), STR_TO_DATE('16.07.2018.', '%d.%m.%Y.'), 6, "D"),
    (16, 16, "38596616074", STR_TO_DATE('23.04.1992.', '%d.%m.%Y.'), STR_TO_DATE('14.06.2016.', '%d.%m.%Y.'), 11, "D"),
    (17, 17, "07998924475", STR_TO_DATE('01.03.1980.', '%d.%m.%Y.'), STR_TO_DATE('28.01.2017.', '%d.%m.%Y.'), 5, "D"),
    (18, 18, "49803937625", STR_TO_DATE('25.11.2000.', '%d.%m.%Y.'), STR_TO_DATE('22.05.2017.', '%d.%m.%Y.'), 11, "D"),
    (19, 19, "23060440711", STR_TO_DATE('18.07.2001.', '%d.%m.%Y.'), STR_TO_DATE('16.09.2020.', '%d.%m.%Y.'), 6, "N"),
    (20, 20, "26189778531", STR_TO_DATE('12.02.1992.', '%d.%m.%Y.'), STR_TO_DATE('23.12.2015.', '%d.%m.%Y.'), 6, "D"),
    (21, 21, "54869054022", STR_TO_DATE('13.05.1975.', '%d.%m.%Y.'), STR_TO_DATE('18.07.2015.', '%d.%m.%Y.'), 1, "N"),
    (22, 22, "45283348931", STR_TO_DATE('01.04.1970.', '%d.%m.%Y.'), STR_TO_DATE('18.07.2015.', '%d.%m.%Y.'), 7, "D"),
    (23, 23, "40089923150", STR_TO_DATE('14.09.1993.', '%d.%m.%Y.'), STR_TO_DATE('16.07.2018.', '%d.%m.%Y.'), 7, "D"),
    (24, 24, "65542493102", STR_TO_DATE('28.02.1987.', '%d.%m.%Y.'), STR_TO_DATE('14.03.2021.', '%d.%m.%Y.'), 8, "D"),
    (25, 25, "70204223826", STR_TO_DATE('06.06.1986.', '%d.%m.%Y.'), STR_TO_DATE('29.08.2018.', '%d.%m.%Y.'), 8, "D"),
    (26, 26, "81795403405", STR_TO_DATE('14.02.2002.', '%d.%m.%Y.'), STR_TO_DATE('10.03.2019.', '%d.%m.%Y.'), 3, "D"),
    (27, 27, "65412651204", STR_TO_DATE('26.06.1988.', '%d.%m.%Y.'), STR_TO_DATE('22.02.2021.', '%d.%m.%Y.'), 7, "D"),
    (28, 28, "02369844521", STR_TO_DATE('16.05.2000.', '%d.%m.%Y.'), STR_TO_DATE('23.04.2021.', '%d.%m.%Y.'), 10, "D"),
    (29, 29, "36554789521", STR_TO_DATE('01.01.2001.', '%d.%m.%Y.'), STR_TO_DATE('14.07.2021.', '%d.%m.%Y.'), 10, "D"),
    (30, 30, "33655478895", STR_TO_DATE('01.01.2001.', '%d.%m.%Y.'), STR_TO_DATE('14.07.2021.', '%d.%m.%Y.'), 9, "D"),
    (31, 31, "64084659928", STR_TO_DATE('12.05.1999.', '%d.%m.%Y.'), STR_TO_DATE('18.06.2015.', '%d.%m.%Y.'), 3, "D"),
    (32, 32, "62672005876", STR_TO_DATE('05.05.1995.', '%d.%m.%Y.'), STR_TO_DATE('17.07.2017.', '%d.%m.%Y.'), 4, "D"),
    (33, 33, "25977293327", STR_TO_DATE('12.05.2000.', '%d.%m.%Y.'), STR_TO_DATE('20.11.2020.', '%d.%m.%Y.'), 5, "D"),
    (34, 34, "19279229706", STR_TO_DATE('16.03.1994.', '%d.%m.%Y.'), STR_TO_DATE('19.09.2019.', '%d.%m.%Y.'), 6, "D"),
    (35, 35, "02392747164", STR_TO_DATE('07.10.1990.', '%d.%m.%Y.'), STR_TO_DATE('16.03.2015', '%d.%m.%Y.'), 6, "D"),
    (36, 36, "22231425931", STR_TO_DATE('25.07.1988.', '%d.%m.%Y.'), STR_TO_DATE('17.04.2018.', '%d.%m.%Y.'), 7, "D"),
    (37, 37, "14356583214", STR_TO_DATE('13.12.1991.', '%d.%m.%Y.'), STR_TO_DATE('15.05.2019.', '%d.%m.%Y.'), 10, "D"),
    (38, 38, "79787408178", STR_TO_DATE('16.09.1978.', '%d.%m.%Y.'), STR_TO_DATE('16.07.2018.', '%d.%m.%Y.'), 11, "D"),
    (39, 39, "88042605055", STR_TO_DATE('02.02.2002.', '%d.%m.%Y.'), STR_TO_DATE('10.03.2019.', '%d.%m.%Y.'), 10, "D"),
    (40, 40, "41079660133", STR_TO_DATE('13.11.1985.', '%d.%m.%Y.'), STR_TO_DATE('14.07.2016.', '%d.%m.%Y.'), 11, "N");

-- id, drzava, grad, ulica, post_broj
INSERT INTO adresa VALUES
	(1, "Hrvatska", "Pula", "Rovinjska ulica 14", "52100"),
    (2, "Hrvatska", "Lanišće", "Podgaće 15", "52422"),
    (3, "Hrvatska", "Pazin", "Kršikla 85", "52000"),
    (4, "Hrvatska", "Labin", "Marceljani 8", "52220"),
    (5, "Hrvatska", "Pula", "Kolhiđanska 12", "52100"),
    (6, "Hrvatska", "Bale", "Bobići 6", "52211"),
    (7, "Hrvatska", "Vodnjan", "Antifašističkih boraca 28", "52215"),
    (8, "Hrvatska", "Galižana", "Toro 49", "52216"),
    (9, "Hrvatska", "Poreč", "Jasenova 145", "52440"),
    (10, "Hrvatska", "Raša", "Istarska 88", "52223"),
    (11, "Hrvatska", "Lupoglav", "Brajuhi 4", "52426"),
    (12, "Hrvatska", "Umag", "Kvarnerska 1", "52470"),
    (13, "Hrvatska", "Nova Vas", "Brčići 14", "52446"),
    (14, "Hrvatska", "Oprtalj", "Škeri 9", "52428"),
    (15, "Hrvatska", "Cerovlje", "Jerončići 3", "52402"),
    (16, "Hrvatska", "Pula", "Coppova 5", "52100"),
    (17, "Hrvatska", "Pazin", "Jukani 109", "52000"),
    (18, "Hrvatska", "Poreč", "Pionirska 8", "52440"),
    (19, "Hrvatska", "Umag", "Komunela 70", "52470"),
    (20, "Hrvatska", "Vrsar", "Jadranska 9", "52450"),
    (21, "Hrvatska", "Žminj", "Hrušteti 84", "52341"),
    (22, "Hrvatska", "Pazin", "Sergovići 88", "52000"),
    (23, "Hrvatska", "Motovun", "Kanal 3", "52424"),
    (24, "Hrvatska", "Nedešćina", "Vrećari 116", "52231"),
    (25, "Hrvatska", "Funtana", "Coki 2A", "52452"),
    (26, "Hrvatska", "Buzet", "Paladini 98", "52420"),
    (27, "Hrvatska", "Buzet", "Marinci 57", "52420"),
    (28, "Hrvatska", "Labin", "Šćiri 39", "52220"),
    (29, "Hrvatska", "Ližnjan", "Muntić 16", "52203"),
    (30, "Hrvatska", "Krnica", "Suhača 9", "52208"),
    (31, "Hrvatska", "Fažana", "Braće Ilić 54", "52212"),
    (32, "Hrvatska", "Pazin", "Heki 18", "52000"),
    (33, "Hrvatska", "Karojba", "Margaroti 78", "52423"),
    (34, "Hrvatska", "Buje", "Bibali 88", "52460"),
    (35, "Hrvatska", "Pazin", "Baničići 114", "52000"),
    (36, "Hrvatska", "Žminj", "Krničari 68", "52341"),
    (37, "Hrvatska", "Sv. Petar u Šumi", "Glavica 3", "52404"),
    (38, "Hrvatska", "Gračišće", "Škljonki 55", "52208"),
    (39, "Hrvatska", "Kršan", "Čambarelići 74", "52208"),
    (40, "Hrvatska", "Pula", "Rovinjska 9", "52100"),
    (41, "Hrvatska", "Pula", "Radićeva 16", "52100"),
    (42, "Hrvatska", "Pula", "Bečka 28", "52100"),
    (43, "Hrvatska", "Pula", "Fižela 69", "52100"),
    (44, "Hrvatska", "Pula", "Valovine 8", "52100"),
    (45, "Hrvatska", "Pula", "Uskočka 14", "52100"),
    (46, "Hrvatska", "Pula", "Supilova 9", "52100"),
    (47, "Hrvatska", "Pula", "Varaždinska 17", "52100"),
    (48, "Hrvatska", "Pula", "Bože Gumpca 40", "52100"),
    (49, "Hrvatska", "Pula", "Kastavska 17", "52100"),
    (50, "Hrvatska", "Pula", "Braće Levak 149", "52100");
    
        
-- id, naziv, id_adresa, oib, broj_mob, vrsta_usluge        
INSERT INTO dobavljac VALUES
	(1, 'Velpro', 1, "21759184842", "0912345678", "namirnice"),
	(2, 'Ljubica', 2, "77428959704", "09852415", "salata"),
    (3, 'Sokić-mokić', 3, "56424113287", "098888445", "sokovi"),
    (4, 'Sirko', 4, "34873876896", "09854522", "sir"),
    (5, 'Vinko', 5, "74653243500", "09255441", "vino"),
    (6, 'Export.doo', 6, "68387340952", "091441155", "potrošni materjal"),
    (7, 'Telac', 7, "60554772341", "0915661", "meso"),
    (8, 'Kobaso', 8, "21942161460", "09912452", "meso"),
    (9, 'Nemo', 9, "96731891024", "099417895", "riba"),
    (10, 'Metro', 10, "44517556343", "09236521", "namirnice"),
    (11, 'Franko', 11, "59711810772", "09755221", "kava"),
    (12, 'Gertruda', 12, "98007480833", "09555262", "kumpiri"),
    (13, 'Albatros', 13, "58274911145", "095552314", "riba"),
    (14, 'Fianona', 14, "92720437532", "0951236", "školjke"),
    (15, 'Plamenko', 15, "62952663861", "09944521", "sir"),
    (16, 'Adolf', 16, "33271926773", "09123652", "plin"),
    (17, 'Toro', 17, "73591779518", "09132562", "meso"),
    (18, 'Oink', 18, "21224636908", "09126524", "meso"),
    (19, 'Ljuštura', 19, "31639353187", "09202352", "rakovi"),
    (20, 'Gricko', 20, "94675840247", "0923195265", "rakovi"),
    (21, 'Fido', 21, "64505084129", "091445662", "salata"),
    (22, 'Max', 22, "82426680225", "09766552", "piće"),
    (23, 'Aljeti Azimi', 23, "95823027745", "092145200", "sladoled"),
    (24, 'Jure', 24, "76249661604", "098215624", "vino"),
    (25, 'Blejko', 25, "38605079167", "09745625", "salata"),
    (26, 'Konzun', 26, "87274585839", "097563251", "namirnice"),
    (27, 'Liedel', 27, "98470400212", "09565425", "piće"),
    (28, 'Mrvica', 28, "00982878048", "09963452", "kruh"),
    (29, 'Kruhko', 29, "84663302364", "0984623", "kruh"),
    (30, 'Salamko', 30, "70891711781", "097665521", "suhomesnati proizvodi");
    
	

-- id, broj_stola, rajon_stola, broj_gostiju_kapacitet
INSERT INTO stol VALUES
	(1, "1", "1", 6),
    (2, "2", "1", 6),
    (3, "3", "1", 4),
    (4, "4", "1", 4),
    (5, "5", "1", 8),
    (6, "6", "1", 6),
    (7, "7", "1", 6),
    (8, "8", "1", 6),
    (9, "9", "1", 4),
    (10, "10", "1", 8),
    (11, "1", "2", 6),
    (12, "2", "2", 4),
    (13, "3", "2", 8),
    (14, "4", "2", 8),
    (15, "5", "2", 8),
    (16, "1", "3", 4),
    (17, "2", "3", 4),
    (18, "3", "3", 6),
    (19, "4", "3", 8),
    (20, "5", "3", 6),
    (21, "6", "3", 4),
    (22, "7", "3", 10),
    (23, "8", "3", 8),
    (24, "1", "4", 4),
    (25, "2", "4", 6),
    (26, "3", "4", 4),
    (27, "4", "4", 6),
    (28, "5", "4", 6),
    (29, "6", "4", 4),
    (30, "7", "4", 4);

-- id, naziv    
INSERT INTO nacini_placanja VALUES
	(1, "gotovina"),
    (2, "kartica"),
    (3, "crypto");

-- id, sifra, id_nacin_placanja, id_stol, id_djelatnik, vrijeme_izdavanja, iznos_hrk
-- id-evi djelatnika koji su blagajnici: 18, 7, 16, 38, 40
INSERT INTO racun (id, sifra, id_nacin_placanja, id_stol, id_djelatnik, vrijeme_izdavanja) VALUES
	(1, "000001", 3, 5, 7, STR_TO_DATE('18.12.2020. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (2, "000002", 1, 13, 7, STR_TO_DATE('18.12.2020. 13:30:00', '%d.%m.%Y. %H:%i:%s')),
    (3, "000003", 1, 19, 18, STR_TO_DATE('18.12.2020. 15:00:00', '%d.%m.%Y. %H:%i:%s')),
    (4, "000004", 1, 26, 18, STR_TO_DATE('18.12.2020. 16:00:00', '%d.%m.%Y. %H:%i:%s')),
    (5, "000005", 1, 1, 7, STR_TO_DATE('18.12.2020. 17:00:00', '%d.%m.%Y. %H:%i:%s')),
    (6, "000006", 2, 4, 16, STR_TO_DATE('19.12.2020. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (7, "000007", 1, 6, 16, STR_TO_DATE('19.12.2020. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (8, "000008", 1, 15, 7, STR_TO_DATE('19.12.2020. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (9, "000009", 1, 21, 16, STR_TO_DATE('19.12.2020. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (10, "000010", 1, 28, 7, STR_TO_DATE('20.01.2021. 10:00:00', '%d.%m.%Y. %H:%i:%s')),
    (11, "000011", 1, 12, 18, STR_TO_DATE('20.01.2021. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (12, "000012", 1, 22, 7, STR_TO_DATE('20.01.2021. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (13, "000013", 2, 24, 18, STR_TO_DATE('20.01.2021. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (14, "000014", 1, 10, 18, STR_TO_DATE('20.01.2021. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (15, "000015", 2, 9, 16, STR_TO_DATE('21.02.2021. 10:00:00', '%d.%m.%Y. %H:%i:%s')),
    (16, "000016", 1, 16, 16, STR_TO_DATE('21.02.2021. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (17, "000017", 1, 21, 16, STR_TO_DATE('21.02.2021. 12:00:00', '%d.%m.%Y. %H:%i:%s')),
    (18, "000018", 1, 29, 7, STR_TO_DATE('21.02.2021. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (19, "000019", 1, 23, 18, STR_TO_DATE('21.02.2021. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (20, "000020", 1, 7, 7, STR_TO_DATE('21.02.2021. 15:00:00', '%d.%m.%Y. %H:%i:%s')),
    (21, "000021", 2, 27, 18, STR_TO_DATE('21.02.2021. 16:00:00', '%d.%m.%Y. %H:%i:%s')),
    (22, "000022", 2, 30, 16, STR_TO_DATE('21.02.2021. 16:30:00', '%d.%m.%Y. %H:%i:%s')),
    (23, "000023", 1, 25, 7, STR_TO_DATE('21.02.2021. 17:00:00', '%d.%m.%Y. %H:%i:%s')),
    (24, "000024", 2, 7, 16, STR_TO_DATE('22.03.2021. 10:00:00', '%d.%m.%Y. %H:%i:%s')),
    (25, "000025", 3, 18, 7, STR_TO_DATE('22.03.2021. 10:30:00', '%d.%m.%Y. %H:%i:%s')),
    (26, "000026", 1, 24, 18, STR_TO_DATE('22.03.2021. 11:00:00', '%d.%m.%Y. %H:%i:%s')),
    (27, "000027", 2, 7, 16, STR_TO_DATE('22.03.2021. 11:30:00', '%d.%m.%Y. %H:%i:%s')),
    (28, "000028", 1, 3, 7, STR_TO_DATE('22.04.2021. 12:30:00', '%d.%m.%Y. %H:%i:%s')),
    (29, "000029", 1, 17, 16, STR_TO_DATE('22.04.2021. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (30, "000030", 2, 9, 16, STR_TO_DATE('22.04.2021. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (31, "000031", 2, 8, 7, STR_TO_DATE('22.04.2021. 13:30:00', '%d.%m.%Y. %H:%i:%s')),
    (32, "000032", 1, 28, 16, STR_TO_DATE('22.04.2021. 14:00:00', '%d.%m.%Y. %H:%i:%s')),
    (33, "000033", 1, 30, 16, STR_TO_DATE('22.04.2021. 14:30:00', '%d.%m.%Y. %H:%i:%s')),
    (34, "000034", 1, 11, 18, STR_TO_DATE('23.04.2021. 11:30:00', '%d.%m.%Y. %H:%i:%s')),
    (35, "000035", 2, 10, 16, STR_TO_DATE('23.05.2021. 13:00:00', '%d.%m.%Y. %H:%i:%s')),
    (36, "000036", 1, 2, 18, STR_TO_DATE('23.05.2021. 13:30:00', '%d.%m.%Y. %H:%i:%s')),
    (37, "000037", 2, 19, 16, STR_TO_DATE('23.05.2021. 14:30:00', '%d.%m.%Y. %H:%i:%s')),
    (38, "000038", 1, 20, 7, STR_TO_DATE('23.05.2021. 15:30:00', '%d.%m.%Y. %H:%i:%s')),
    (39, "000039", 1, 11, 7, STR_TO_DATE('23.06.2021. 17:00:00', '%d.%m.%Y. %H:%i:%s'));

-- id, naziv    
INSERT INTO alergen VALUES
	(1, "Riba"),
    (2, "Mlijeko"),
    (3, "Pšenica"), 
    (4, "Jaja"), 
    (5, "Kikiriki"), 
    (6, "Cimet"), 
    (7, "Rakovi"), 
    (8, "Školjke"), 
    (9, "Soja"), 
    (10, "Celer"), 
    (11, "Gorušnica"), 
    (12, "Sezam"), 
    (13, "Lupina");  
    
    
-- id, naziv_stavke, cijena_hrk, aktivno (po defaultu "D") 
INSERT INTO meni (id, naziv_stavke, cijena_hrk) VALUES
	(1, "Jadranska orada sa žara s gratiniranim povrćem", 95),
    (2, "Vino Teran 0.1 l", 38),
    (3, "Vino Malvazija 0.1 l", 28),
    (4, "Salata od jadranske hobotnice s krumpirom i rajčicom", 95),
    (5, "Juha od rajčice", 35),
    (6, "Istarski fuži s jadranskim kozicama i tartufima", 98),
    (7, "Dalmatinska pašticada s domaćim njokima", 96),
    (8, "Spaghetti Carbonara", 43),
    (9, "Spaghetti Bolognese", 43),
    (10, "Pečena teletina s gratiniranim krumpirom", 125),
    (11, "Biftek s gratiniranim krumpirom i povrćem sa žara", 185),
    (12, "Pečena svinjetina s gratiniranim krumpirom", 125),
    (13, "Goveđa juha", 30),
    (14, "Soparnik", 42),
    (15, "Njoki u umaku od sira", 50),
    (16, "Rumpsteak sa šparogama i krumpir ploškama", 90),
    (17, "Lignje na žaru", 47),
    (18, "Pohani oslić", 50),
    (19, "Miješana salata", 17),
    (20, "Pileća plata za 4 osobe", 150),
    (21, "Grill plata za 4 osobe", 160),
    (22, "Pommes frites", 17),
    (23, "Jaja na oko", 15),
    (24, "Miješano meso", 60),
    (25, "Čokoladni soufle", 20),
    (26, "Pohane bukovače uz rizibizi", 40),
    (27, "Tripice s kumpirom i špekom", 40),
    (28, "Maneštra s bobići", 60),
    (29, "Jota", 60),
    (30, "Vege kvinoja burrito bowl", 40),
    (31, "Vinski gulaš", 35),
    (32, "Piletina u sezamu uz šarenu salatu", 40),
    (33, "Marinirani ražnjići", 40),
    (34, "Pileći medaljoni u umaku od gorgonzole sa kroketima", 68),
    (35, "Lungić u umaku od gljiva sa kroketima", 90),
    (36, "Leskovačka ruža", 60),
    (37, "Pljeskavica Djevojački san", 70),
    (38, "Leskovački ćevapi", 48),
    (39, "Pivo Favorit 0.5 l", 18),
    (40, "Istarsko pivo 0.5 l", 20),
    (41, "Coca Cola 0.5 l", 26),
    (42, "Fanta 0.25 l", 18),
    (43, "Ledeni čaj", 16),
    (44, "Negazirani sok", 15),
    (45, "Cedevita", 10),
    (46, "Jägermeister 0.03 l", 5),
    (47, "Amaro 0.03 l", 5),
    (48, "Medica", 5),
    (49, "Kava", 9),
    (50, "Cappuccino", 9),
    (51, "Čaj", 9);
    

-- id, id_meni, id_alergen
INSERT INTO sadrzi_alergen VALUES
	(1, 1, 1),
	(2, 4, 1),
	(3, 4, 10),
	(4, 5, 4),
	(5, 5, 2),
	(6, 6, 7),
	(7, 6, 1),
	(8, 6, 3),
	(9, 6, 4),
	(10, 7, 4),
	(11, 7, 9),
	(12, 8, 2),
	(13, 8, 3),
	(14, 9, 2),
	(15, 9, 3),
	(16, 9, 9),
	(17, 15, 3),
	(18, 15, 2),
	(19, 17, 1),
	(20, 18, 1),
	(21, 19, 13),
	(22, 19, 10),
	(23, 19, 11),
	(24, 23, 4),
	(25, 25, 2),
	(26, 25, 5),
	(27, 25, 6),
	(28, 26, 10),
	(29, 31, 11),
	(30, 32, 12),
	(31, 33, 9),
	(32, 33, 11),
	(33, 34, 1),
	(34, 34, 4),
	(35, 35, 13),
	(36, 35, 9);
    
-- id, naziv    
INSERT INTO kategorija_namirnica VALUES
	(1, "Riba"),
    (2, "Meso"),
    (3, "Voće"),
    (4, "Povrće"),
    (5, "Piće"),
	(6, "Tjestenina"),
	(7, "Gljive"),
	(8, "Jaja"),
	(9, "Mlječni proizvodi"),
	(10, "Pekarski proizvodi");

-- id, naziv, id_kategorija, kolicina_na_zalihi, mjerna_jedinica    
INSERT INTO namirnica VALUES
	(1, "Orada", 1, 60, "komad"),
    (2, "Biftek", 2, 50, "komad"),
    (3, "Jagoda", 3, 4, "kilogram"),
    (4, "Vino Teran", 5, 60, "litra"),
    (5, "Vino Malvazija", 5, 60, "litra"),
	(6, "Hobotnica", 1, 60, "komad"),
	(7, "Krumpir", 4, 500, "kilogram"),
	(8, "Rajčica", 4, 300, "kilogram"),
	(9, "Fuži", 5, 60, "kilogram"),
	(10, "Kozice", 1, 60, "kilogram"),
	(11, "Tartufi", 7, 2, "kilogram"),
	(12, "Njoki", 6, 50, "kilogram"),
	(13, "Spaghetti", 6, 30, "kilogram"),
	(14, "Mljeveno meso", 2, 80, "kilogram"),
	(15, "Teletina", 2, 60, "kilogram"),
	(16, "Paprika", 4, 100, "kilogram"),
	(17, "Tikvice", 4, 70, "kilogram"),
	(18, "Patliđan", 4, 49, "kilogram"),
	(19, "Sir", 9, 60, "kilogram"),
	(20, "Šparoge", 4, 6, "kilogram"),
	(21, "Lignje", 1, 86, "kilogram"),
	(22, "Oslić", 1, 25, "kilogram"),
	(23, "Salata", 4, 98, "kilogram"),
	(24, "Svinjetina", 2, 135, "kilogram"),
	(25, "Piletina", 2, 96, "kilogram"),
	(26, "Gljive", 7, 44, "kilogram"),
	(27, "Čokolada", 10, 60, "kilogram"),
	(28, "Tripice", 2, 12, "kilogram"),
	(29, "Kukuruz", 4, 88, "kilogram"),
	(30, "Kupus", 4, 74, "kilogram"),
	(31, "Lungić", 2, 36, "kilogram"),
	(32, "Favorit", 5, 300, "litra"),
	(33, "Istarsko pivo", 5, 1245, "litra"),
	(34, "Coca Cola", 5, 3000, "litra"),
	(35, "Fanta", 5, 200, "litra"),
	(36, "Sprite", 5, 200, "litra"),
	(37, "Ledeni čaj", 5, 60, "litra"),
	(38, "Pago", 5, 689, "litra"),
	(39, "Medica", 5, 59, "litra"),
	(40, "Amaro", 5, 18, "litra"),
	(41, "Mlijeko", 5, 45, "litra"),
	(42, "Riža", 4, 60, "kilogram"),
	(43, "Cedevita", 5, 60, "litra"),
	(44, "Jägermeister", 5, 10, "litra"),
	(45, "Začini", 4, 888, "kilogram"),
	(46, "Kruh", 10, 159, "komada"),
	(47, "Jaja", 8, 145, "komada"),
	(48, "Grašak", 4, 69, "kilogram"),
    (49, "Brokula", 4, 15, "kilogram"),
    (50, "Mrkva", 3, 20, "kilogram"),
	(51, "Luk", 4, 300, "kilogram"),
	(52, "Suhe šljive", 4, 30, "kilogram"),
	(53, "Blitva", 4, 5, "kilogram"),
    (54, "Kvinoja", 4, 9, "kilogram"),
    (55, "Kava", 5, 400, "litara"),
    (56, "Čaj", 5, 80, "litara");

-- id, id_namirnica, kolicina, id_meni    
INSERT INTO stavka_meni (id_namirnica, kolicina, id_meni) VALUES
	(1, 1, 1),
	(49, 0.1, 1),
    (50, 0.1, 1),
    (18, 0.1, 1),
    (17, 0.1, 1),
    (16, 1, 1),
    (7, 0.3, 1),
    (4, 0.1, 2),
    (5, 0.1, 3),
    (6, 1, 4),
    (7, 0.4, 4),
    (8, 0.2, 4),
    (8, 0.7, 5),
    (9, 0.25, 6),
    (10, 0.1, 6),
    (11, 0.03, 6),
    (12, 0.5, 7),
    (15, 0.1, 7),
    (4, 0.02, 7),
    (50, 0.1, 7),
    (51, 0.1, 7),
    (52, 0.1, 7),
    (45, 0.1, 7),
    (13, 0.4, 8),
    (19, 0.5, 8),
    (47, 1, 8),
    (45, 0.1, 8),
    (45, 0.1, 9),
    (13, 0.4, 9),
    (14, 0.2, 9),
    (8, 0.1, 9),
    (51, 0.1, 9),
    (15, 0.3, 10),
    (7, 0.4, 10),
    (45, 0.1, 10),
    (45, 0.1, 11),
    (2, 1, 11),
    (7, 0.3, 11),
    (16, 0.1, 11),
    (17, 0.1, 11),
    (18, 0.1, 11),
    (49, 0.1, 11),
    (51, 0.1, 11),
    (24, 0.3, 12),
    (7, 0.3, 12),
    (51, 0.1, 12),
    (45, 0.1, 12),
    (15, 0.3, 13),
    (51, 0.3, 13),
    (45, 0.1, 13),
    (53, 0.1, 14),
    (51, 0.1, 14),
    (45, 0.1, 14),
    (12, 0.6, 15),
    (19, 0.4, 15),
    (15, 0.4, 16),
    (7, 0.3, 16),
    (20, 0.2, 16),
    (21, 0.4, 17),
    (7, 0.3, 17),
    (22, 0.3, 18),
    (47, 1, 18),
    (45, 0.1, 18),
    (45, 0.3, 19),
    (30, 0.4, 19),
    (23, 0.6, 19),
    (25, 1, 20),
    (7, 1, 20),
    (25, 0.5, 21),
    (24, 0.5, 21),
    (7, 1, 21),
    (45, 0.1, 21),
    (7, 0.5, 22),
    (45, 0.1, 22),
    (47, 2, 23),
    (45, 0.1, 23),
    (25, 0.2, 24),
    (7, 0.5, 24),
    (15, 0.2, 24),
    (24, 0.2, 24),
    (45, 0.1, 24),
    (47, 1, 25),
    (27, 0.2, 25),
    (41, 0.5, 25),
    (26, 0.5, 26),
    (47, 1, 26),
    (45, 0.1, 26),
    (41, 0.2, 26),
    (28, 0.5, 27),
    (7, 0.3, 27),
    (45, 0.1, 27),
    (24, 0.2, 27),
    (29, 0.5, 28),
    (45, 0.5, 28),
    (28, 0.5, 28),
    (50, 0.3, 28),
    (51, 0.5, 28),
    (45, 0.5, 29),
    (50, 0.3, 29),
    (51, 0.5, 29),
    (30, 0.5, 29),
    (54, 0.5, 30),
    (45, 0.2, 30),
    (29, 0.3, 30),
    (49, 0.3, 30),
    (42, 0.1, 30),
    (17, 0.3, 30),
    (5, 0.2, 31),
    (15, 0.5, 31),
    (45, 0.2, 31),
    (7, 0.2, 31),
    (51, 0.2, 31),
    (25, 0.4, 32),
    (23, 0.4, 32),
    (45, 0.2, 32),
    (51, 0.2, 32),
    (45, 0.2, 33),
    (31, 0.2, 33),
    (25, 0.2, 33),
    (24, 0.2, 33),
    (17, 0.2, 33),
    (18, 0.2, 33),
    (25, 0.4, 34),
    (45, 0.1, 34),
    (7, 0.3, 34),
    (19, 0.4, 34),
    (50, 0.2, 34),
    (47, 1, 34),
    (31, 0.4, 35),
    (7, 0.3, 35),
    (26, 0.4, 35),
    (45, 0.1, 35),
    (51, 0.4, 35),
    (24, 0.3, 36),
    (14, 0.3, 36),
    (7, 0.5, 36),
    (45, 0.2, 36),
    (51, 0.4, 36),
    (24, 0.3, 37),
    (14, 0.3, 37),
    (7, 0.5, 37),
    (45, 0.2, 37),
    (51, 0.4, 37),
    (24, 0.3, 38),
    (14, 0.3, 38),
    (7, 0.5, 38),
    (45, 0.2, 38),
    (51, 0.4, 38),
    (32, 0.5, 39),
    (33, 0.5, 40),
    (34, 0.5, 41),
    (35, 0.25, 42),
    (37, 0.25, 43),
    (38, 0.25, 44),
    (43, 0.25, 45),
    (44, 0.03, 46),
    (40, 0.03, 47),
    (39, 0.03, 48),
    (55, 0.1, 49),
    (41, 0.1, 49),
    (55, 0.1, 50),
    (41, 0.1, 50),
    (56, 0.2, 51),
    (42, 0.2, 26),
    (48, 0.1, 26);
    
    

-- id, id_racun, id_meni, kolicina, cijena_hrk
INSERT INTO stavka_racun (id, id_racun, id_meni, kolicina) VALUES
    (1, 1, 1, 1),
    (2, 1, 3, 2),
    (3, 2, 1, 1),
    (4, 2, 15, 3),
    (5, 2, 3, 1),
    (6, 3, 7, 2),
    (7, 3, 5, 1),
    (8, 4, 15, 1),
    (9, 4, 14, 2),
    (10, 5, 13, 1),
    (11, 5, 1, 1),
    (12, 6, 10, 3),
    (13, 7, 13, 1),
    (14, 7, 7, 3),
    (15, 7, 1, 3),
    (16, 8, 10, 1),
    (17, 8, 4, 5),
    (18, 8, 2, 1),
    (19, 8, 1, 1),
    (20, 9, 2, 5),
    (21, 9, 4, 6),
    (22, 9, 7, 2),
    (23, 9, 5, 3),
    (24, 10, 8, 2),
    (25, 11, 2, 2),
    (26, 11, 3, 2),
    (27, 11, 4, 2),
    (28, 12, 1, 2),
    (29, 12, 4, 2),
    (30, 13, 9, 1),
    (31, 14, 11, 3),
    (32, 14, 9, 5),
    (33, 15, 12, 5),
    (34, 15, 10, 2),
    (35, 16, 2, 1),
    (36, 17, 3, 3),
    (37, 17, 8, 5),
    (38, 17, 14, 2),
    (39, 18, 14, 1),
    (40, 19, 10, 2),
    (41, 20, 4, 2),
    (42, 20, 5, 2),
    (43, 21, 3, 1),
    (44, 21, 2, 1),
    (45, 21, 16, 1),
    (46, 21, 17, 1),
    (47, 22, 12, 3),
    (48, 22, 8, 1),
    (49, 23, 2, 2),
    (50, 23, 3, 2),
    (51, 24, 18, 3),
    (52, 24, 16, 2),
    (53, 24, 9, 1),
    (54, 24, 3, 4),
    (55, 24, 2, 1),
    (56, 25, 9, 2),
    (57, 25, 7, 2),
    (58, 25, 16, 2),
    (59, 25, 24, 2),
    (60, 25, 2, 3),
    (61, 25, 25, 4),
    (62, 26, 8, 2),
    (63, 26, 2, 4),
    (64, 26, 3, 2),
    (65, 27, 13, 2),
    (66, 27, 21, 1),
    (67, 27, 17, 1),
    (68, 27, 3, 2),
    (69, 28, 1, 1),
    (70, 29, 21, 2),
    (71, 29, 2, 1),
    (72, 29, 3, 1),
    (73, 30, 4, 1),
    (74, 30, 5, 1),
    (75, 30, 15, 1),
    (76, 30, 13, 1),
    (77, 31, 6, 2),
    (78, 31, 1, 1),
    (79, 31, 18, 1),
    (80, 31, 14, 1),
    (81, 31, 19, 2),
    (82, 31, 5, 2),
    (83, 31, 3, 3),
    (84, 31, 2, 3),
    (85, 31, 4, 3),
    (86, 31, 7, 3),
    (87, 32, 14, 1),
    (88, 32, 18, 1),
    (89, 32, 11, 1),
    (90, 33, 8, 1),
    (91, 33, 9, 2),
    (92, 33, 22, 2),
    (93, 33, 17, 1),
    (94, 33, 3, 4),
    (95, 34, 6, 2),
    (96, 34, 12, 2),
    (97, 34, 13, 1),
    (98, 34, 4, 1),
    (99, 34, 3, 3),
    (100, 35, 20, 1),
	(101, 35, 21, 1),
    (102, 35, 22, 4),
    (103, 35, 3, 8),
    (104, 35, 2, 8),
    (105, 36, 4, 1),
    (106, 36, 7, 2),
    (107, 36, 11, 2),
    (108, 36, 14, 1),
    (109, 36, 5, 2),
    (110, 37, 1, 2),
    (111, 37, 8, 1),
    (112, 37, 12, 1),
    (113, 37, 15, 2),
    (114, 37, 17, 1),
    (115, 37, 2, 7),
    (116, 38, 21, 1),
    (117, 38, 22, 4),
    (118, 38, 13, 1),
    (119, 39, 1, 3),
    (120, 39, 2, 3),
    (121, 39, 3, 5),
    (122, 39, 19, 1),
    (123, 39, 9, 1),
    (124, 39, 14, 1),
    (125, 39, 13, 1),
	(126, 39, 16, 1),
	(127, 39, 6, 1),
	(128, 39, 20, 6);


INSERT INTO rezervacija (id_stol, id_osoba, zeljeni_datum, vrijeme_od, vrijeme_do, broj_gostiju) VALUES
	(1, 1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "18:00", "23:00", 4),
    (2, 40, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "19:00", "23:00", 6),
    (3, 41, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "16:00", "18:00", 2),
    (5, 43, STR_TO_DATE('10.01.2021.', '%d.%m.%Y.'), "19:00", "23:00", 7),
    (6, 44, STR_TO_DATE('12.01.2021.', '%d.%m.%Y.'), "17:00", "22:00", 6),
    (9, 50, STR_TO_DATE('20.01.2021.', '%d.%m.%Y.'), "18:00", "21:00", 2),
    (20, 46, STR_TO_DATE('14.02.2021.', '%d.%m.%Y.'), "15:00", "17:00", 5),
    (14, 49, STR_TO_DATE('14.02.2021.', '%d.%m.%Y.'), "19:00", "22:00", 4),
    (15, 47, STR_TO_DATE('14.02.2021.', '%d.%m.%Y.'), "18:00", "21:00", 8),
    (29, 48, STR_TO_DATE('16.02.2021.', '%d.%m.%Y.'), "16:30", "19:00", 3),
    (27, 40, STR_TO_DATE('04.03.2021.', '%d.%m.%Y.'), "18:30", "22:00", 6),
    (9, 50, STR_TO_DATE('06.04.2021.', '%d.%m.%Y.'), "19:30", "21:30", 4),
    (8, 49, STR_TO_DATE('08.04.2021.', '%d.%m.%Y.'), "14:00", "19:00", 6),
    (22, 40, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), "12:00", "23:00", 10),
    (27, 43, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), "15:00", "19:30", 5),
    (3, 42, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), "16:00", "17:30", 3),
    (1, 44, STR_TO_DATE('10.05.2021.', '%d.%m.%Y.'), "19:00", "22:00", 5),
    (18, 46, STR_TO_DATE('15.05.2021.', '%d.%m.%Y.'), "15:00", "19:00", 6),
    (26, 48, STR_TO_DATE('14.06.2021.', '%d.%m.%Y.'), "14:00", "18:00", 4),
    (22, 46, STR_TO_DATE('17.06.2021.', '%d.%m.%Y.'), "17:00", "19:00", 9),
    (6, 47, STR_TO_DATE('24.06.2021.', '%d.%m.%Y.'), "12:00", "23:00", 6),
    (5, 45, STR_TO_DATE('01.07.2021.', '%d.%m.%Y.'), "17:30", "23:00", 8),
    (18, 46, STR_TO_DATE('28.07.2021.', '%d.%m.%Y.'), "16:00", "22:00", 6),
    (30, 44, STR_TO_DATE('06.08.2021.', '%d.%m.%Y.'), "14:00", "20:30", 4),
    (24, 40, STR_TO_DATE('08.08.2021.', '%d.%m.%Y.'), "11:00", "13:00", 2),
    (14, 49, STR_TO_DATE('20.08.2021.', '%d.%m.%Y.'), "12:00", "23:00", 7),
    (8, 50, STR_TO_DATE('28.09.2021.', '%d.%m.%Y.'), "17:00", "20:00", 6),
    (6, 41, STR_TO_DATE('24.12.2021.', '%d.%m.%Y.'), "18:30", "22:00", 5),
    (2, 50, STR_TO_DATE('24.12.2021.', '%d.%m.%Y.'), "18:30", "21:00", 5),
    (14, 48, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), "12:00", "18:00", 8),
    (5, 46, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), "13:00", "22:00", 8),
    (14, 40, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), "19:00", "23:00", 8),
    (30, 45, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), "15:00", "17:30", 3);
    
-- id, id_osoba, oib
INSERT INTO catering_narucitelj VALUES
	(1, 40, "46445221484"),
    (2, 41, "26578511258"),
    (3, 44, "65993227367"),
    (4, 42, "21074357447"),
    (5, 43, "88712578515"),
    (6, 48, "13935956833"),
    (7, 47, "63447625433"),
    (8, 50, "02442784430"),
    (9, 47, "61447645433"),
    (10, 46, "17266697748"),
    (11, 43, "88796678515"),
    (12, 42, "21077357447"),
    (13, 40, "38407121484"),
    (14, 41, "26583611258"),
    (15, 49, "75019388217"),
    (16, 47, "63447645433"),
    (17, 48, "14935956833"),
    (18, 50, "92442784430"),
    (19, 43, "88713678515"),
    (20, 40, "48407121484");
    
-- id, id_narucitelj, id_adresa, opis, zeljeni_datum, datum_zahtjeva
INSERT INTO catering_zahtjev VALUES
	(1, 1, 40, NULL, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), STR_TO_DATE('15.12.2020.', '%d.%m.%Y.')),
    (2, 2, 42, NULL, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), STR_TO_DATE('16.12.2020.', '%d.%m.%Y.')),
    (3, 3, 50, NULL, STR_TO_DATE('10.03.2021.', '%d.%m.%Y.'), STR_TO_DATE('13.02.2021.', '%d.%m.%Y.')),
    (4, 4, 46, NULL, STR_TO_DATE('15.04.2021.', '%d.%m.%Y.'), STR_TO_DATE('15.03.2021.', '%d.%m.%Y.')),
    (5, 5, 48, NULL, STR_TO_DATE('16.04.2021.', '%d.%m.%Y.'), STR_TO_DATE('01.04.2021.', '%d.%m.%Y.')),
    (6, 6, 39, NULL, STR_TO_DATE('17.04.2021.', '%d.%m.%Y.'), STR_TO_DATE('02.04.2021.', '%d.%m.%Y.')),
    (7, 7, 37, "pasulj ako ga ima", STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), STR_TO_DATE('25.04.2021.', '%d.%m.%Y.')),
    (8, 8, 41, NULL, STR_TO_DATE('23.06.2021.', '%d.%m.%Y.'), STR_TO_DATE('15.05.2021.', '%d.%m.%Y.')),
    (9, 9, 43, NULL, STR_TO_DATE('28.06.2021.', '%d.%m.%Y.'), STR_TO_DATE('25.5.2021.', '%d.%m.%Y.')),
    (10, 10, 41, NULL, STR_TO_DATE('14.08.2021.', '%d.%m.%Y.'), STR_TO_DATE('17.07.2021.', '%d.%m.%Y.')),
    (11, 11, 50, NULL, STR_TO_DATE('17.10.2021.', '%d.%m.%Y.'), STR_TO_DATE('16.09.2021.', '%d.%m.%Y.')),
    (12, 12, 50, NULL, STR_TO_DATE('22.11.2021.', '%d.%m.%Y.'), STR_TO_DATE('27.10.2021.', '%d.%m.%Y.')),
    (13, 13, 48, NULL, STR_TO_DATE('23.12.2021.', '%d.%m.%Y.'), STR_TO_DATE('30.11.2021.', '%d.%m.%Y.')),
    (14, 14, 38, "sretna nova godina", STR_TO_DATE('31.12.2021.', '%d.%m.%Y.'), STR_TO_DATE('01.12.2021.', '%d.%m.%Y.')),
    (15, 15, 38, NULL, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), STR_TO_DATE('10.12.2021.', '%d.%m.%Y.')),
    (16, 16, 40, NULL, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), STR_TO_DATE('11.12.2021.', '%d.%m.%Y.')),
    (17, 17, 40, NULL, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), STR_TO_DATE('12.12.2021.', '%d.%m.%Y.')),
    (18, 18, 44, NULL, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (19, 19, 48, NULL, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (20, 20, 46, NULL, STR_TO_DATE('06.01.2022.', '%d.%m.%Y.'), STR_TO_DATE('28.12.2021.', '%d.%m.%Y.')),
    (21, 8, 44, NULL, STR_TO_DATE('10.02.2022.', '%d.%m.%Y.'), STR_TO_DATE('29.12.2021.', '%d.%m.%Y.')),
    (22, 9, 50, NULL, STR_TO_DATE('22.03.2022.', '%d.%m.%Y.'), STR_TO_DATE('30.12.2021.', '%d.%m.%Y.')),
    (23, 5, 41, NULL, STR_TO_DATE('14.04.2022.', '%d.%m.%Y.'), STR_TO_DATE('31.12.2021.', '%d.%m.%Y.'));

-- id, id_zahtjev, cijena_hrk, datum_izvrsenja, uplaceno
-- ako je datum_izvrsenja NULL, znači da je taj catering u budućnosti
INSERT INTO catering (id, id_zahtjev, datum_izvrsenja, uplaceno) VALUES
	(1, 1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "D"),
    (2, 2, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "D"),
	(3, 3, STR_TO_DATE('10.03.2021.', '%d.%m.%Y.'), "N"),
    (4, 4, STR_TO_DATE('15.04.2021.', '%d.%m.%Y.'), "N"),
    (5, 5, STR_TO_DATE('16.04.2021.', '%d.%m.%Y.'), "N"),
    (6, 6, STR_TO_DATE('17.04.2021.', '%d.%m.%Y.'), "N"),
    (7, 7, STR_TO_DATE('01.05.2021', '%d.%m.%Y.'), "D"),
    (8, 8, STR_TO_DATE('23.06.2021.', '%d.%m.%Y.'), "D"),
    (9, 9, STR_TO_DATE('28.06.2021.', '%d.%m.%Y.'), "D"),
    (10, 10, STR_TO_DATE('14.08.2021.', '%d.%m.%Y.'), "D"),
    (11, 11, STR_TO_DATE('17.10.2021.', '%d.%m.%Y.'), "D"),
    (12, 12, STR_TO_DATE('22.11.2021.', '%d.%m.%Y.'), "D"),
    (13, 13, STR_TO_DATE('23.12.2021.', '%d.%m.%Y.'), "D"),
    (14, 14, STR_TO_DATE('31.12.2021.', '%d.%m.%Y.'), "D"),
    (15, 15, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "N"),
    (16, 16, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "D"),
    (17, 17, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "D"),
    (18, 18, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "D"),
    (19, 19, STR_TO_DATE('01.01.2022.', '%d.%m.%Y.'), "D"),
    (20, 20, STR_TO_DATE('06.01.2022.', '%d.%m.%Y.'), "D"),
    (21, 21, STR_TO_DATE('10.02.2022.', '%d.%m.%Y.'), "N"),
    (22, 22, STR_TO_DATE('22.03.2022.', '%d.%m.%Y.'),"N"),
    (23, 23, STR_TO_DATE('14.04.2022.', '%d.%m.%Y.'),"N");
    
    
-- id, id_catering, id_meni, kolicina, cijena_hrk
INSERT INTO catering_stavka (id, id_catering, id_meni, kolicina) VALUES
	(1, 1, 1, 10),
    (2, 1, 2, 10),
    (3, 1, 6, 8),
    (4, 1, 7, 20),
    (5, 1, 10, 5),
    (6, 1, 15, 9),
    (7, 1, 21, 10),
    (8, 2, 29, 11),
    (9, 2, 24, 10),
    (10, 2, 30, 1),
    (11, 2, 32, 5),
    (12, 2, 6, 7),
    (13, 2, 16, 3),
    (14, 3, 20, 1),
    (15, 3, 21, 1),
    (16, 3, 22, 2),
    (17, 3, 19, 8),
    (18, 4, 1, 8),
    (19, 4, 3, 10),
    (20, 4, 4, 5),
    (21, 4, 17, 2),
    (22, 5, 27, 3),
    (23, 5, 28, 4),
    (24, 5, 31, 2),
    (25, 6, 37, 2),
    (26, 6, 30, 1),
    (27, 6, 9, 5),
    (28, 6, 15, 3),
    (29, 7, 6, 8),
    (30, 7, 26, 5),
    (31, 7, 25, 10),
    (32, 8, 1, 2),
    (33, 8, 6, 2),
    (34, 8, 16, 3),
    (35, 9, 17, 4),
    (36, 9, 14, 5),
    (37, 9, 18, 4),
    (38, 9, 15, 3),
    (39, 9, 34, 4),
    (40, 10, 29, 3),
    (41, 10, 27, 4),
    (42, 10, 24, 5),
    (43, 10, 2, 6),
    (44, 11, 33, 4),
    (45, 11, 32, 8),
    (46, 11, 38, 2),
    (47, 12, 15, 8),
    (48, 12, 14, 4),
    (49, 12, 13, 1),
    (50, 13, 35, 1),
    (51, 13, 16, 1),
    (52, 14, 24, 2),
    (53, 14, 25, 3),
    (54, 15, 17, 4),
    (55, 15, 19, 4),
    (56, 16, 26, 6),
    (57, 16, 28, 2),
    (58, 17, 9, 4),
    (59, 17, 40, 15),
    (60, 18, 7, 2),
    (61, 18, 3, 5),
    (62, 18, 25, 4),
    (63, 18, 10, 2),
    (64, 19, 6, 5),
    (65, 19, 12, 5),
    (66, 19, 30, 1),
    (67, 20, 36, 2),
    (68, 20, 21, 4);


-- id, id_catering, id_djelatnik
INSERT INTO djelatnici_catering VALUES
	(1, 1, 28),
    (2, 1, 9),
    (3, 1, 11),
    (4, 1, 13),
    (5, 2, 29),
    (6, 2, 11),
    (7, 2, 13),
    (8, 3, 37),
    (9, 3, 9),
    (10, 3, 11),
    (11, 4, 28),
    (12, 4, 9),
    (13, 4, 13),
    (14, 5, 37),
    (15, 5, 11),
    (16, 5, 13),
    (17, 6, 29),
    (18, 6, 9),
    (19, 6, 13),
    (20, 7, 28),
    (21, 8, 29),
    (22, 8, 9),
    (24, 8, 13),
    (25, 9, 37),
    (26, 9, 11),
    (27, 9, 13),
    (28, 9, 9),
    (29, 10, 28),
    (30, 10, 9),
    (31, 10, 13),
    (32, 11, 29),
    (33, 11, 13),
    (34, 11, 11),
    (35, 12, 37),
    (36, 12, 9),
    (37, 12, 11),
    (38, 13, 28),
    (39, 13, 11),
    (40, 13, 13),
    (41, 14, 29),
    (42, 14, 9),
    (43, 14, 13),
    (44, 15, 29),
    (45, 15, 11),
    (46, 15, 13),
    (47, 16, 37),
    (48, 16, 9),
    (49, 16, 11),
    (50, 17, 28),
    (51, 17, 9),
    (52, 17, 11),
    (53, 18, 29),
    (54, 18, 13),
    (55, 18, 11),
    (56, 19, 28),
    (57, 19, 9),
    (58, 19, 11),
    (59, 20, 37),
    (60, 20, 13),
    (61, 20, 11);
    
    

-- id, id_dobavljac, opis, iznos_hrk, podmireno, datum
INSERT INTO nabava (id, id_dobavljac, opis, podmireno, datum) VALUES
	(1, 13, "Nabavka 10 orada", "D", STR_TO_DATE('01.01.2021.', '%d.%m.%Y.')),
    (2, 13, NULL, "D", STR_TO_DATE('15.02.2021.', '%d.%m.%Y.')),
	(3, 10, "Nabavka 10 kila teletine", "N", STR_TO_DATE('28.02.2021.', '%d.%m.%Y.'));
    
-- id, id_nabava, id_namirnica, kolicina, cijena_hrk
INSERT INTO nabava_stavka VALUES
	(1, 1, 1, 10, 250.00),
    (2, 2, 1, 15, 350.00),
    (3, 2, 21, 10, 950.00),
    (4, 3, 15, 10, 500.00);

-- id, datum, opis
INSERT INTO otpis VALUES
	(1, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), NULL),
    (2, STR_TO_DATE('15.02.2021.', '%d.%m.%Y.'), NULL);

-- id, id_otpis, id_namirnica, kolicina
INSERT INTO otpis_stavka VALUES
	(1, 1, 3, 1),
    (2, 1, 19, 5),
    (3, 2, 5, 10),
    (4, 2, 19, 2);

-- id, naziv
INSERT INTO kategorija_rezije VALUES
	(1, "struja"),
    (2, "voda"),
    (3, "internet i telefon"),
    (4, "komunalna naknada"),
    (5, "odvoz smeća"),
    (6, "Uređenje slivne vode");

-- id, iznos_hrk, datum, id_kategorija, placeno
INSERT INTO rezije VALUES
	(1, 5000.00, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), 1, "D"),
    (2, 299.00, STR_TO_DATE('01.05.2021.', '%d.%m.%Y.'), 3, "D"),
	(3, 600.00, STR_TO_DATE('04.05.2021.', '%d.%m.%Y.'), 2, "D"),
	(4, 299.00, STR_TO_DATE('01.06.2021.', '%d.%m.%Y.'), 3, "D"),
	(5, 240.00, STR_TO_DATE('01.06.2021.', '%d.%m.%Y.'), 5, "D"),
    (6, 4500.00, STR_TO_DATE('02.06.2021.', '%d.%m.%Y.'), 1, "D"),
	(7, 340.00, STR_TO_DATE('04.06.2021.', '%d.%m.%Y.'), 4, "D"),
    (8, 160.00, STR_TO_DATE('04.06.2021.', '%d.%m.%Y.'), 6, "D"),
    (9, 400.00, STR_TO_DATE('05.06.2021.', '%d.%m.%Y.'), 2, "D"),
    (10, 5400.00, STR_TO_DATE('01.07.2021.', '%d.%m.%Y.'), 1, "D"),
    (11, 550.00, STR_TO_DATE('01.07.2021.', '%d.%m.%Y.'), 2, "D"),
    (12, 299.00, STR_TO_DATE('01.07.2021.', '%d.%m.%Y.'), 3, "D"),
    (13, 6100.00, STR_TO_DATE('03.08.2021.', '%d.%m.%Y.'), 1, "D"),
	(14, 299.00, STR_TO_DATE('01.08.2021.', '%d.%m.%Y.'), 3, "D"),
	(15, 240.00, STR_TO_DATE('01.08.2021.', '%d.%m.%Y.'), 5, "D"),
    (16, 600.00, STR_TO_DATE('04.08.2021.', '%d.%m.%Y.'), 2, "D"),
	(17, 500.00, STR_TO_DATE('01.09.2021.', '%d.%m.%Y.'), 2, "D"),
    (18, 299.00, STR_TO_DATE('01.09.2021.', '%d.%m.%Y.'), 3, "D"),
    (19, 5250.00, STR_TO_DATE('02.09.2021.', '%d.%m.%Y.'), 1, "D"),
    (20, 340.00, STR_TO_DATE('03.09.2021.', '%d.%m.%Y.'), 4, "D"),
    (21, 160.00, STR_TO_DATE('03.09.2021.', '%d.%m.%Y.'), 6, "D"),
    (22, 4800.00, STR_TO_DATE('01.10.2021.', '%d.%m.%Y.'), 1, "D"),
    (23, 299.00, STR_TO_DATE('01.10.2021.', '%d.%m.%Y.'), 3, "D"),
    (24, 450.00, STR_TO_DATE('02.10.2021.', '%d.%m.%Y.'), 2, "D"),
    (25, 240.00, STR_TO_DATE('02.10.2021.', '%d.%m.%Y.'), 5, "D"),
	(26, 299.00, STR_TO_DATE('01.11.2021.', '%d.%m.%Y.'), 3, "D"),
    (27, 6000.00, STR_TO_DATE('03.11.2021.', '%d.%m.%Y.'), 1, "D"),
    (28, 650.00, STR_TO_DATE('06.11.2021.', '%d.%m.%Y.'), 2, "D"),
	(29, 299.00, STR_TO_DATE('01.12.2021.', '%d.%m.%Y.'), 3, "D"),
	(30, 240.00, STR_TO_DATE('01.12.2021.', '%d.%m.%Y.'), 5, "D"),
    (31, 5800.00, STR_TO_DATE('02.12.2021.', '%d.%m.%Y.'), 1, "D"),
    (32, 500.00, STR_TO_DATE('04.12.2021.', '%d.%m.%Y.'), 2, "D"),
	(33, 340.00, STR_TO_DATE('04.12.2021.', '%d.%m.%Y.'), 4, "D"),
    (34, 160.00, STR_TO_DATE('04.12.2021.', '%d.%m.%Y.'), 6, "N");

-- id, naziv, pocetak_radnog_vremena, kraj_radnog_vremena
INSERT INTO smjena VALUES
	(1, "kuhinja - prijepodne", "08:00", "15:00"),
    (2, "kuhinja - poslijepodne", "17:00", "23:00"),
    (3, "sala - dvoktratno", "10:00", "23:00"),
    (4, "poslovođa - prijepodne", "9:00", "16:00"),
    (5, "poslovođa - prijepodne", "16:00", "23:00"),
    (6, "skladište", "8:00", "16:00");


-- id, id_djelatnik, id_smjena, datum
INSERT INTO djelatnik_smjena VALUES
	(1, 2, 1,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
    (2, 4, 2,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
    (3, 4, 1,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (4, 2, 2,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (5, 2, 1,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(6, 4, 2,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
    (7, 4, 1,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
    (8, 2, 2,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
    (9, 2, 1,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (10, 4, 2,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (11, 4, 1,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (12, 2, 2,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (13, 2, 1,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (14, 4, 2,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (15, 3, 1,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(16, 8, 1,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(17, 10, 1,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(18, 12, 2,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(19, 26, 2,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(20, 12, 1,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(21, 26, 1,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (22, 31, 1,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(23, 3, 2,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(24, 8, 2,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(25, 3, 1,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(26, 8, 1,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(27, 10, 1,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
    (28, 12, 2,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(29, 31, 2,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(30, 12, 1,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(31, 26, 1,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(32, 31, 1,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(33, 3, 2,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(34, 10, 2,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(35, 3, 1,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
	(36, 8, 1,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
	(37, 10, 1,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (38, 26, 2,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
	(39, 31, 2,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (40, 12, 1,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(41, 26, 1,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(42, 31, 1,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(43, 8, 2,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(44, 10, 2,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (45, 3, 1,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
	(46, 8, 1,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
	(47, 10, 1,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (48, 12, 2,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
	(49, 26, 2,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (50, 24, 4,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.'));
    
    /*

    
	
	
	
	
	(25, 5,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(24, 4,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(25, 5,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(24, 4,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(25, 5,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
	(24, 4,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(25, 5,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(25, 4,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
	(25, 5,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
	(24, 4,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(24, 5,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(24, 4,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
	(25, 5,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (28, 6,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
	(29, 6,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
	(37, 6,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
	(39, 6,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
	(37, 6,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
	(29, 6,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (28, 3,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
    (39, 3,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
    (29, 4,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
    (37, 4,STR_TO_DATE('15.12.2021.', '%d.%m.%Y.')),
    (29, 3,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (28, 3,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (37, 4,STR_TO_DATE('16.12.2021.', '%d.%m.%Y.')),
    (37, 3,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
    (39, 4,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
    (28, 4,STR_TO_DATE('17.12.2021.', '%d.%m.%Y.')),
    (37, 3,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
    (29, 3,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
    (39, 4,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
    (28, 4,STR_TO_DATE('18.12.2021.', '%d.%m.%Y.')),
    (39, 3,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (37, 4,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (29, 4,STR_TO_DATE('19.12.2021.', '%d.%m.%Y.')),
    (37, 3,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (39, 3,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (28, 4,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (29, 4,STR_TO_DATE('20.12.2021.', '%d.%m.%Y.')),
    (39, 3,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (29, 3,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.')),
    (28, 4,STR_TO_DATE('21.12.2021.', '%d.%m.%Y.'));
    */
    
-- id, id_osoba, id_adresa, datum, cijena_hrk, izvrsena
INSERT INTO dostava (id, id_osoba, id_adresa, datum, izvrsena) VALUES
	(1, 31, 22, STR_TO_DATE('01.11.2020.', '%d.%m.%Y.'), "D"),
    (2, 34, 1, STR_TO_DATE('15.11.2020.', '%d.%m.%Y.'), "D"),
    (3, 35, 17, STR_TO_DATE('22.12.2020.', '%d.%m.%Y.'), "D"),
    (4, 39, 25, STR_TO_DATE('01.01.2021.', '%d.%m.%Y.'), "D"),
    (5, 40, 12, STR_TO_DATE('03.01.2021.', '%d.%m.%Y.'), "D"),
    (6, 33, 11, STR_TO_DATE('06.01.2021.', '%d.%m.%Y.'), "D"),
    (7, 32, 10, STR_TO_DATE('01.02.2021.', '%d.%m.%Y.'), "D"),
    (8, 38, 11, STR_TO_DATE('01.03.2021.', '%d.%m.%Y.'), "D"),
    (9, 35, 28, STR_TO_DATE('01.04.2021.', '%d.%m.%Y.'), "D"),
    (10, 35, 2, STR_TO_DATE('02.05.2021.', '%d.%m.%Y.'), "D"),
    (11, 32, 3, STR_TO_DATE('02.06.2021.', '%d.%m.%Y.'), "D"),
    (12, 31, 4, STR_TO_DATE('01.07.2021.', '%d.%m.%Y.'), "D"),
    (13, 39, 5, STR_TO_DATE('01.08.2021.', '%d.%m.%Y.'), "D"),
    (14, 40, 26, STR_TO_DATE('01.09.2021.', '%d.%m.%Y.'), "D"),
    (15, 32, 21, STR_TO_DATE('01.10.2021.', '%d.%m.%Y.'), "D"),
    (16, 32, 12, STR_TO_DATE('01.11.2021.', '%d.%m.%Y.'), "D"),
    (17, 35, 15, STR_TO_DATE('01.12.2021.', '%d.%m.%Y.'), "D");

-- id, id_dostava, id_meni, kolicina, cijena_hrk
INSERT INTO dostava_stavka (id, id_dostava, id_meni, kolicina) VALUES
	(1, 1, 18, 1),
    (2, 1, 21, 2),
    (3, 2, 2, 2),
    (4, 2, 3, 3),
    (5, 3, 5, 2),
    (6, 3, 7, 3),
    (7, 3, 4, 2),
    (8, 4, 9, 1),
    (9, 4, 19, 2),
    (10, 5, 20, 4),
    (11, 6, 5, 2),
    (12, 6, 2, 1),
    (13, 6, 9, 2),
    (14, 6, 11, 3),
    (15, 7, 23, 2),
    (16, 7, 5, 4),
    (17, 8, 7, 2),
    (18, 9, 12, 1),
    (19, 10, 13, 2),
    (20, 11, 14, 3),
    (21, 11, 17, 1),
    (22, 11, 11, 3),
    (23, 12, 12, 2),
    (24, 12, 5, 1),
    (25, 12, 25, 2),
    (26, 13, 24, 2),
    (27, 13, 23, 1),
    (28, 14, 11, 2),
    (29, 15, 22, 1),
    (30, 15, 12, 3),
    (31, 16, 23, 5),
    (32, 17, 10, 5);




    
    
    
    
    
    
    
    
    
    
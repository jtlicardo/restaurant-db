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
    oib CHAR(11) NOT NULL UNIQUE,
    datum_rodenja DATE NOT NULL,
    datum_zaposlenja DATE NOT NULL,
    id_zanimanje INTEGER NOT NULL,
    FOREIGN KEY (id_osoba) REFERENCES osoba (id),
    FOREIGN KEY (id_zanimanje) REFERENCES zanimanje (id)
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
	vrijeme_izdavanja DATETIME NOT NULL,
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
    naziv_stavke VARCHAR(50) NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL
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
    naziv VARCHAR(50) NOT NULL,
    id_kategorija INTEGER NOT NULL,
    kolicina_na_zalihi INTEGER NOT NULL,
    mjerna_jedinica VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_kategorija) REFERENCES kategorija_namirnica (id)
);

CREATE TABLE stavka_meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_namirnica INTEGER NOT NULL,
    kolicina DECIMAL (10, 2),
    mjerna_jedinica VARCHAR(20) NOT NULL,
    id_meni INTEGER NOT NULL,
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);

CREATE TABLE stavka_racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_racun INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);

CREATE TABLE rezervacija (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_stol INTEGER NOT NULL,
	id_gost INTEGER NOT NULL,
    zeljeni_datum DATE NOT NULL,
    vrijeme_od TIME NOT NULL,
    vrijeme_do TIME NOT NULL,
	broj_gostiju INTEGER NOT NULL,
	FOREIGN KEY (id_stol) REFERENCES stol (id),
	FOREIGN KEY (id_gost) REFERENCES osoba (id)
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
    datum_zahtjeva DATE NOT NULL,
    FOREIGN KEY (id_narucitelj) REFERENCES catering_narucitelj (id),
    FOREIGN KEY (id_adresa) REFERENCES adresa (id)
);

CREATE TABLE catering (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_zahtjev INTEGER NOT NULL,
    cijena_hrk DECIMAL(10, 2) DEFAULT 0.00,
    datum_izvrsenja DATE,
    opis TEXT,
    uplaceno CHAR(1) NOT NULL,
    FOREIGN KEY (id_zahtjev) REFERENCES catering_zahtjev (id),
    CHECK (uplaceno IN ("D", "N"))
);
    
CREATE TABLE catering_stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_catering INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_catering) REFERENCES catering (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);

CREATE TABLE djelatnici_catering (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_catering INTEGER NOT NULL,
    id_djelatnik INTEGER NOT NULL,
    FOREIGN KEY (id_catering) REFERENCES catering (id),
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id)
);
    
CREATE TABLE nabava (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_dobavljac INTEGER NOT NULL,
    opis TEXT,
    iznos_hrk DECIMAL(10, 2) NOT NULL,
    podmireno CHAR(1) NOT NULL,
    datum DATE NOT NULL,
    FOREIGN KEY (id_dobavljac) REFERENCES dobavljac (id),
    CHECK (podmireno IN ("D", "N"))
);

CREATE TABLE nabava_stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_nabava INTEGER NOT NULL,
    id_namirnica INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    mjerna_jedinica VARCHAR(20) NOT NULL,
    cijena_hrk DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (id_nabava) REFERENCES nabava (id),
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id)
); 

CREATE TABLE otpis (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    datum DATE NOT NULL,
    opis TEXT
);    

CREATE TABLE otpis_stavka (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_otpis INTEGER NOT NULL,
    id_namirnica INTEGER NOT NULL,
	kolicina INTEGER NOT NULL,
	mjerna_jedinica VARCHAR(20) NOT NULL,
	FOREIGN KEY (id_otpis) REFERENCES otpis (id),
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id)
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
	id_gost INTEGER NOT NULL,
	id_adresa INTEGER NOT NULL, 
	datum DATE NOT NULL, 
	cijena_hrk DECIMAL(10, 2) NOT NULL,
	izvrsena CHAR(1) NOT NULL,
    FOREIGN KEY (id_gost) REFERENCES osoba (id),
    FOREIGN KEY (id_adresa) REFERENCES adresa (id),
    CHECK (izvrseno IN ("D", "N"))
);

CREATE TABLE dostava_stavka (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_dostava INTEGER NOT NULL,
	id_meni INTEGER NOT NULL,
	kolicina INTEGER NOT NULL, 
	cijena_hrk DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_dostava) REFERENCES dostava (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
); 

-- id, naziv, placa_hrk
INSERT INTO zanimanje VALUES   
	(1, "kuhar", 9054,45 ),
	(2, "konobar", 8640,85 ),
    (3, "pomoćni kuhar", 4654,45 ),
    (4, "pomoćni konobar", 4654,45 ),
    (5, "servir", 4551,23 ),
    (6, "operater na posuđu", 6054,45 ),
    (7, "barmen", 6054,45 ),
    (8, "poslovođa", 16054,75 ),
    (9, "skladištar", 7453,65 ),
    (10, "dostavljač", 8135,24 );

-- id, ime, prezime, datum_rodenja, oib, broj_mob, datum_zaposlenja, id_zanimanje
INSERT INTO djelatnik VALUES
	(1, 'Ana', 'Anić', 1988-11-22, 56214852651, 0975698542, 2021-05-19, 2 ),
	(2, 'Milena', 'Kakoli', 1978-05-13, 42685138412, 0911122334, 2018-03-15, 1 ),
	(3, 'Marko', 'Afrić', 1999-11-11, 87426514895, 092785425, 2021-04-17, 3 );
        
-- id, naziv, adresa, oib, broj_mob, vrsta_usluge        
INSERT INTO dobavljac VALUES
	(1, 'Velpro', 'Zagrebačka 4', 74125621458, 0912345678, "namirnice"),
	(2, 'Ljubica', 'Flanatička 7', 51254785214, 09852415, "salata");
    
INSERT INTO nacini_placanja VALUES
	(1, "gotovina"),
    (2, "kartica"),
    (3, "crypto");
    
INSERT INTO alergen VALUES
	(1, "Riba"),
    (2, "Mlijeko"),
    (3, "Pšenica");    
    
INSERT INTO meni VALUES
	(1, "Jadranska orada sa žara s gratiniranim povrćem", 95),
    (2, "Vino Teran 0.1 l", 38),
    (3, "Vino Malvazija 0.1 l", 28);    

INSERT INTO sadrzi_alergen VALUES
	(1, 1, 1);
    
INSERT INTO kategorija_namirnica VALUES
	(1, "Riba"),
    (2, "Meso"),
    (3, "Voće"),
    (4, "Povrće"),
    (5, "Piće");
    
INSERT INTO namirnica VALUES
	(1, "Orada", 1, 30, "komad"),
    (2, "Biftek", 2, 50, "komad"),
    (3, "Jagoda", 3, 4, "kilogram"),
    (4, "Vino Teran", 5, 60, "litra"),
    (5, "Vino Malvazija", 5, 60, "litra");
    
INSERT INTO stavka_meni VALUES
	(1, 1, 1, "komad", 1),
    (2, 4, 0.1, "litra", 2),
    (3, 5, 0.1, "litra", 3);
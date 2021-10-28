DROP DATABASE IF EXISTS restoran;
CREATE DATABASE restoran;
USE restoran;

CREATE TABLE djelatnik (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    datum_rodenja DATE NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    broj_mob VARCHAR(10) NOT NULL UNIQUE,
    datum_zaposlenja DATE NOT NULL
);

CREATE TABLE dobavljac (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    broj_mob VARCHAR(10) NOT NULL UNIQUE,
    vrsta_usluge VARCHAR(50) NOT NULL
);
    
CREATE TABLE stol (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    broj_stola VARCHAR(4) NOT NULL,
    rajon_stola VARCHAR(4) NOT NULL,
    broj_gostiju INTEGER
);
    
CREATE TABLE racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	sifra VARCHAR(10) NOT NULL,
	id_stol INTEGER NOT NULL,
	id_djelatnik INTEGER NOT NULL,
	datum_vrijeme DATETIME NOT NULL,
	iznos DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id_stol) REFERENCES stol (id),
    FOREIGN KEY (id_djelatnik) REFERENCES djelatnik (id)
);

CREATE TABLE alergen (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	naziv VARCHAR(50) NOT NULL
);

CREATE TABLE meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv_jela VARCHAR(50) NOT NULL,
    cijena DECIMAL(10, 2) NOT NULL,
    id_alergen INTEGER,
    FOREIGN KEY (id_alergen) REFERENCES alergen (id)
);

CREATE TABLE stavka_racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_racun INTEGER NOT NULL,
    id_meni INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);

CREATE TABLE gost (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	ime VARCHAR(50) NOT NULL,
	prezime VARCHAR(50) NOT NULL
);

CREATE TABLE rezervacija (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	id_stol INTEGER NOT NULL,
	id_gost INTEGER NOT NULL,
	broj_gostiju INTEGER NOT NULL,
	FOREIGN KEY (id_stol) REFERENCES stol (id),
	FOREIGN KEY (id_gost) REFERENCES gost (id)
);

CREATE TABLE catering (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ponuda VARCHAR(50) NOT NULL,
    cijena DECIMAL(10, 2) NOT NULL,
    kolicina INTEGER NOT NULL
);
    
CREATE TABLE kategorija_namirnica (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL
);

INSERT INTO kategorija_namirnica VALUES
	(1, "Riba"),
    (2, "Meso"),
    (3, "Voće"),
    (4, "Povrće"),
    (5, "Piće");
    
CREATE TABLE namirnica (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    id_kategorija INTEGER NOT NULL,
    FOREIGN KEY (id_kategorija) REFERENCES kategorija_namirnica (id)
);

INSERT INTO namirnica VALUES
	(1, "Orada", 1),
    (2, "Biftek", 2),
    (3, "Jagoda", 3),
    (4, "Vino Teran", 5),
    (5, "Vino Malvazija", 5);

CREATE TABLE stavka_meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_namirnica INTEGER NOT NULL,
    kolicina DECIMAL (10, 3),
    id_meni INTEGER NOT NULL,
	FOREIGN KEY (id_namirnica) REFERENCES namirnica (id),
    FOREIGN KEY (id_meni) REFERENCES meni (id)
);
    
CREATE TABLE skladiste (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_namirnica INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    mjerna_jedinica VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_namirnica) REFERENCES namirnica (id)
);

INSERT INTO skladiste VALUES
	(1, 1, 30, "komada"),
    (2, 2, 50, "komada"),
    (3, 3, 4, "kilograma"),
    (4, 4, 60, "litara"),
    (5, 5, 60, "litara");
    
    
    
    
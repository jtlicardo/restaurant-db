DROP DATABASE IF EXISTS restoran;
CREATE DATABASE restoran;
USE restoran;

CREATE TABLE djelatnik (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
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
    broj_gostiju INTEGER,
    rezervacija VARCHAR(50) NOT NULL,
    meni VARCHAR(50) NOT NULL
);
    
CREATE TABLE racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	sifra VARCHAR(10) NOT NULL,
	id_stol INTEGER UNSIGNED NOT NULL,
	id_djelatnik INTEGER UNSIGNED NOT NULL,
	datum_vrijeme DATETIME NOT NULL,
	iznos DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id_stol) REFERENCES stol (id)
);

CREATE TABLE alergeni (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
	naziv VARCHAR(50) NOT NULL
);

CREATE TABLE stavka (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    cijena DECIMAL(10, 2) NOT NULL,
    id_alergen INTEGER,
    FOREIGN KEY (id_alergen) REFERENCES alergen (id)
);

CREATE TABLE stavka_racun (
	id INTEGER PRIMARY KEY AUTO_INCREMENT,
    id_racun INTEGER NOT NULL,
    id_stavka INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun (id),
    FOREIGN KEY (id_stavka) REFERENCES stavka (id)
);
    


    
DROP DATABASE IF EXISTS restoran;
CREATE DATABASE restoran;
USE restoran;

CREATE TABLE djelatnik (
	id INTEGER PRIMARY KEY,
    ime VARCHAR(50) NOT NULL,
    prezime VARCHAR(50) NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    broj_mob VARCHAR(10) NOT NULL UNIQUE,
    datum_zaposlenja DATE NOT NULL
);

CREATE TABLE dobavljac(
	id INTEGER PRIMARY KEY,
    ime VARCHAR(50) NOT NULL,
    adresa VARCHAR(50) NOT NULL,
    oib CHAR(11) NOT NULL UNIQUE,
    broj_mob VARCHAR(10) NOT NULL UNIQUE,
    vrsta_usluge VARCHAR(50) NOT NULL
    
    );
    
CREATE TABLE racun (
	id_racun SERIAL AUTO_INCREMENT,
	sifra VARCHAR(10) NOT NULL,
	id_stol BIGINT UNSIGNED NOT NULL,
	id_djelatnik BIGINT UNSIGNED NOT NULL,
	datum_i_vrijeme_izdavanja DATETIME NOT NULL,
	ukupna_cijena DECIMAL(10,2) DEFAULT 0.00
);

CREATE TABLE stol(
	id INTEGER PRIMARY KEY,
    broj_stola VARCHAR(50) NOT NULL,
    rajon_stola VARCHAR(50) NOT NULL,
    broj_gostiju INTEGER,
    rezervacija VARCHAR(50) NOT NULL,
    meni VARCHAR(50) NOT NULL
    );
    
     CREATE TABLE alergeni (
     id INTEGER PRIMARY KEY,
     vrsta VARCHAR(50) NOT NULL,
     CONSTRAINT id
	
    );
    
    
    CREATE TABLE meni(
    id_meni INTEGER PRIMARY KEY,
    ime_jela VARCHAR(50) NOT NULL,
    cijena DECIMAL (10,2),
    porcija INTEGER NOT NULL,
    REFERENCES alergeni(id)
    
    );
    
   
    
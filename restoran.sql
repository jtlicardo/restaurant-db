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
    id_stavka INTEGER NOT NULL,
    kolicina INTEGER NOT NULL,
    FOREIGN KEY (id_racun) REFERENCES racun (id),
    FOREIGN KEY (id_stavka) REFERENCES stavka (id)
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
    kolicina INTEGER,
    FOREIGN KEY (kolicina) REFERENCES meni (id)
    );
    
    CREATE TABLE skladiste (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime_robe VARCHAR(50) NOT NULL,
    kolicina INTEGER,
    rok_trajanja DATE NOT NULL,
    FOREIGN KEY (ime_robe) REFERENCES dobavljac(id)
    );
    
    CREATE TABLE riba(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime_ribe VARCHAR(50) NOT NULL,
    tezina DECIMAL (10, 3),
    FOREIGN KEY (ime_ribe) REFERENCES skladiste(id)
    );
    
    CREATE TABLE meso(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime_mesa VARCHAR(50) NOT NULL,
    tezina DECIMAL (10, 3),
    FOREIGN KEY (ime_mesa) REFERENCES skladiste(id)
    );
    
    CREATE TABLE voce(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime_voca VARCHAR(50) NOT NULL,
    tezina DECIMAL (10, 3),
    FOREIGN KEY (ime_voce) REFERENCES skladiste(id)
    );
    
    CREATE TABLE povrce(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    ime_povrca VARCHAR(50) NOT NULL,
    tezina DECIMAL (10, 3),
    FOREIGN KEY (ime_povrca) REFERENCES skladiste (id)
    );
    
    CREATE TABLE tekucine(
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    vrsta VARCHAR(50) NOT NULL,
    kolicina DECIMAL (10, 3),
    alkohol BOOLEAN,
    FOREIGN KEY (vrsta) REFERENCES skladiste (id)
    );
    
    CREATE TABLE stavka_meni (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    kolicina DECIMAL (10, 3),
    FOREIGN KEY (id) REFERENCES meni(naziv_jela)
    );
    
    
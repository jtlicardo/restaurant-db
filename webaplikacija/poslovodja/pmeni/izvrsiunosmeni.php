<?php 
    include_once '../poslovodja_konekcija.php';
    if (isset($_SESSION['id_poslovodja']) && mysqli_num_rows(mysqli_query($con,"SELECT * FROM namirnicenoves"))>0 && isset($_SESSION['s_novastavka'])) {
        mysqli_query($con,"INSERT INTO meni (naziv_stavke,cijena_hrk,aktivno) VALUES ('$_SESSION[s_novastavka]','$_SESSION[s_cijena]','D');");
        $nadjiid = mysqli_fetch_assoc(mysqli_query($con,"SELECT * FROM meni WHERE naziv_stavke='$_SESSION[s_novastavka]';"));
        $namirnice = mysqli_query($con,"SELECT * FROM namirnicenoves");
        while ($namirnica = mysqli_fetch_assoc($namirnice)){
            if ($namirnica['kolicina']>0){
            $ubaci = mysqli_query($con,"INSERT INTO stavka_meni (id_namirnica,kolicina,id_meni) VALUES ('$namirnica[id]','$namirnica[kolicina]','$nadjiid[id]');");
        }}
        $alergeni = mysqli_query($con,"SELECT * FROM tablicaalergeni");
        while ($alergen = mysqli_fetch_assoc($alergeni)){
            $ubaci = mysqli_query($con,"INSERT INTO sadrzi_alergen(id_meni,id_alergen) VALUES ('$nadjiid[id]', '$alergen[id]');");
        }
        mysqli_query($con, "DROP TABLE namirnicenoves");
        mysqli_query($con, "DROP TABLE tablicaalergeni");
        unset($_SESSION['s_novastavka']);
        unset($_SESSION['s_cijena']);
    }
    header("Location: poslovodja_dodajmeni.php?unos=1");

/*id	int Auto Increment	
naziv_stavke	varchar(70)	
cijena_hrk	decimal(10,2)	
aktivno*/
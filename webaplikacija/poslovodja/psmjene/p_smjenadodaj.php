<?php
//dodaje tablicama operacija 1-jutro 2-vecer 3-smjena koja je samo jedna
    include_once '../poslovodja_konekcija.php';
//hardcodiran ulaz u smjene, potreban update ukoliko stavimo da poslovođa stvori nove vrste smjena
    if (isset($_SESSION['id_poslovodja'])){
        $op = mysqli_real_escape_string($con,$_GET['operacija']);
        $djelatnikid = mysqli_real_escape_string($con,$_GET['did']);
        $podaci = mysqli_fetch_assoc(mysqli_query($con, "SELECT * FROM djelatnik JOIN osoba ON djelatnik.id_osoba=osoba.id JOIN zanimanje ON  djelatnik.id_zanimanje=zanimanje.id WHERE djelatnik.id='$djelatnikid';"));
        switch ($op){
            case 1:
                if (!mysqli_num_rows(mysqli_query($con, "SELECT * FROM tablicajutro WHERE id=$djelatnikid;"))) {
                    mysqli_query($con, "INSERT INTO tablicajutro (id,ime,prezime,naziv) VALUES ('$djelatnikid','$podaci[ime]','$podaci[prezime]','$podaci[naziv]')");
                }
                break;
            case 2:
                if (!mysqli_num_rows(mysqli_query($con, "SELECT * FROM tablicavecer WHERE id=$djelatnikid;"))) {
                    mysqli_query($con, "INSERT INTO tablicavecer (id,ime,prezime,naziv) VALUES ('$djelatnikid','$podaci[ime]','$podaci[prezime]','$podaci[naziv]')");
                }
                break;
            case 3:
                if ($podaci['naziv']=='skladištar'){
                    mysqli_query($con, "INSERT INTO tablicajutro (id,ime,prezime,naziv) VALUES ('$djelatnikid','$podaci[ime]','$podaci[prezime]','$podaci[naziv]')");
                } else {
                    mysqli_query($con, "INSERT INTO tablicavecer (id,ime,prezime,naziv) VALUES ('$djelatnikid','$podaci[ime]','$podaci[prezime]','$podaci[naziv]')");
                }

        }
        header("Location: poslovodja_smjene.php?update=1");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
?>
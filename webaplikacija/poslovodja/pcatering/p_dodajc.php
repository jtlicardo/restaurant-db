<?php
    include_once '../gost_konekcija.php';
    if (isset($_SESSION['id_poslovodja'])) {
        $op = mysqli_real_escape_string($con, $_GET['operacija']);
        $djelatnikid = mysqli_real_escape_string($con, $_GET['did']);
        $podaci = mysqli_fetch_assoc(mysqli_query($con, "SELECT * FROM djelatnik JOIN osoba ON djelatnik.id_osoba=osoba.id JOIN zanimanje ON  djelatnik.id_zanimanje=zanimanje.id WHERE djelatnik.id='$djelatnikid';"));
        if (!mysqli_num_rows(mysqli_query($con,"SELECT * FROM tablicadjelatnika WHERE id_djelatnik=$djelatnikid;")) && $op==1){
            mysqli_query($con, "INSERT INTO tablicadjelatnika (id_djelatnik,ime,prezime,zanimanje) VALUES ('$djelatnikid','$podaci[ime]','$podaci[prezime]','$podaci[naziv]')");
        } elseif ($op==2){
            mysqli_query($con, "DELETE FROM tablicadjelatnika WHERE id_djelatnik='$djelatnikid')");
        }
        header("Location: p_zahtjevcatering.php?update=1");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
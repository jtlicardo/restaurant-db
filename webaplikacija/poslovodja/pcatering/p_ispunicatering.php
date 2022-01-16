<?php 
    include_once '../poslovodja_konekcija.php';
    if (isset($_SESSION['id_poslovodja'])) {
        mysqli_query($con, "INSERT INTO catering (id_zahtjev,uplaceno) VALUES ('$_SESSION[s_idcatering]','N');");
        $upit = mysqli_query($con, "SELECT * FROM trenutni_catering");
        $idcat = mysqli_fetch_assoc(mysqli_query($con, "SELECT id FROM catering WHERE id_zahtjev = '$_SESSION[s_idcatering]';"))['id'];
        while ($redak = mysqli_fetch_assoc($upit)) {
            mysqli_query($con, "INSERT INTO catering_stavka (id_catering, id_meni, kolicina) VALUES ('$idcat','$redak[id_meni]','$redak[kolicina]');");
        }
        $upit = mysqli_query($con, "SELECT * FROM tablicadjelatnika");
        while ($redak = mysqli_fetch_assoc($upit)) {
            mysqli_query($con, "INSERT INTO djelatnici_catering (id_catering, id_djelatnik) VALUES ('$idcat','$redak[id_djelatnik]');");
        }
        mysqli_query($con, "DROP TABLE trenutni_catering");
        mysqli_query($con, "DROP TABLE tablicadjelatnika");
        header("Location: poslovodja_catering.php");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
?>
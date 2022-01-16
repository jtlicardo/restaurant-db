<?php
    include_once '../poslovodja_konekcija.php';
    if (isset($_SESSION['id_poslovodja'])){
        $idcat = mysqli_real_escape_string($con,$_GET['did']);
        $status = mysqli_real_escape_string($con,$_GET['operacija']);
        if ($status=='D') {
            mysqli_query($con, "UPDATE djelatnik SET zaposlen='N' WHERE id='$idcat'");
        } else {
            mysqli_query($con, "UPDATE djelatnik SET zaposlen='D' WHERE id='$idcat'");
        }
        header("Location: poslovodja_djelatnici.php");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
?>
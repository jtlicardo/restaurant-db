<?php
    include_once '../gost_konekcija.php';
    if (isset($_SESSION['id_poslovodja'])){
        $idcat = mysqli_real_escape_string($con,$_GET['did']);
        mysqli_query($con, "UPDATE catering SET uplaceno='D' WHERE id='$idcat'");
        header("Location: poslovodja_catering.php");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
?>
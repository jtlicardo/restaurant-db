<?php
    include_once '../poslovodja_konekcija.php';
    $imestavke =mysqli_real_escape_string($con,$_POST['naziv']);
    $kolicinastavke =mysqli_real_escape_string($con,$_POST['kolicina']);
    mysqli_autocommit($con,false);
    mysqli_query($con,"CALL dodaj_stavku_za_otpis('$imestavke','$kolicinastavke');");
    mysqli_query($con,"CALL stvori_otpis();");
    mysqli_commit($con);
    mysqli_autocommit($con,true);
    header("Location: poslovodja_skladiste.php?otpis=1");
?>
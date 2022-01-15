<?php
    include_once '../gost_konekcija.php';
    if (isset($_SESSION['id_poslovodja'])) {
        $naziv = mysqli_real_escape_string($con, $_GET['dnaziv']);
        if ($_GET['operacija']==1){
            mysqli_query($con, "UPDATE meni SET aktivno='D' WHERE naziv_stavke='$naziv'");
        } else {
            mysqli_query($con, "UPDATE meni SET aktivno='N' WHERE naziv_stavke='$naziv'");
        }
    } header("Location: poslovodja_meniad.php");
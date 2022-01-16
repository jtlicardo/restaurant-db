<?php
    include_once 'gost_konekcija.php';
    if (isset($_SESSION['id'])){
    $_SESSION['s_idstol'] = mysqli_real_escape_string($con,$_POST['idstol']);
    $_SESSION['s_datum'] = mysqli_real_escape_string($con,$_POST['datum']);
    $_SESSION['s_vrijemeod'] = mysqli_real_escape_string($con,$_POST['vrijemeod']);
    $_SESSION['s_vrijemedo'] = mysqli_real_escape_string($con,$_POST['vrijemedo']);
    $_SESSION['s_brojgostiju'] = mysqli_real_escape_string($con,$_POST['brojgostiju']);
    //poziv procedure za kreiranje rezervacije
    $procedura_kr = mysqli_query($con, "CALL kreiraj_rezervaciju('".intval($_SESSION['s_idstol'])."','".intval($_SESSION['id'])."','".$_SESSION['s_datum']."','".$_SESSION['s_vrijemeod']."','".$_SESSION['s_vrijemedo']."','".intval($_SESSION['s_brojgostiju'])."', @rezervacija);");
    $statusrez = mysqli_query($con, "SELECT @rezervacija as gr_status");
    $porukarez = mysqli_fetch_assoc($statusrez);
    $_SESSION['rstol'] = $porukarez['gr_status'];
    header("Location: gost_sucelje.php");
    } else {
        echo "ispunite podatke o sebi";
    }
?>
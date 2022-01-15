<?php
    include_once '../gost_konekcija.php';
    if (isset($_SESSION['id_poslovodja']) && isset($_POST['sp_novas'])) {
        $_SESSION['s_novastavka']=mysqli_real_escape_string($con, $_POST['ime']);
        $_SESSION['s_cijena']=mysqli_real_escape_string($con, $_POST['cijena']);
    }
    header("Location: poslovodja_dodajmeni.php");
?>
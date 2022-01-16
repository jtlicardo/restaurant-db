<?php
    include_once '../poslovodja_konekcija.php';
    if (isset($_POST['sp_osoba'])) {
        $s_ime=mysqli_real_escape_string($con, $_POST['ime']);
        $s_prezime=mysqli_real_escape_string($con, $_POST['prezime']);
        $s_mob=mysqli_real_escape_string($con, $_POST['mob']);
        $s_email=mysqli_real_escape_string($con, $_POST['email']);
        $s_oib=mysqli_real_escape_string($con, $_POST['oib']);
        $s_datum=mysqli_real_escape_string($con, $_POST['datum']);
        $p_zanimanje=mysqli_real_escape_string($con, $_POST['zanimanje']);
        $s_zanimanje=mysqli_fetch_assoc(mysqli_query($con,"SELECT id FROM zanimanje WHERE naziv='$p_zanimanje';"))['id'];
        mysqli_query($con, "CALL dodaj_djelatnika ('".$s_ime."','".$s_prezime."','".$s_mob."','".$s_email."','".$s_oib."','".$s_datum."','".$s_zanimanje."', @status_transakcije);");
        $poruka = mysqli_fetch_assoc(mysqli_query($con,"SELECT @status_transakcije AS por;"));
    }
    header("Location: poslovodja_djelatnici.php?pp='".$poruka['por']."'");
?>
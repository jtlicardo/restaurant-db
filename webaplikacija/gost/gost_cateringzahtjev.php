<?php
    include_once 'gost_konekcija.php';
    if (isset($_POST['sp_cateringzahtjev']) && isset($_SESSION['idadresa']) && isset($_SESSION['id'])) {
        $s_oib=mysqli_real_escape_string($con, $_POST['oib']);
        $s_opis=mysqli_real_escape_string($con, $_POST['opis']);
        $s_zdatum=mysqli_real_escape_string($con, $_POST['zdatum']);
        $upit_provjera="SELECT id FROM catering_narucitelj WHERE oib='".intval($s_oib)."' AND id_osoba='$_SESSION[id]';";
        $rezultat = mysqli_query($con, $upit_provjera);
        if (!mysqli_num_rows($rezultat)) {
            $unesinarucitelja = "INSERT INTO catering_narucitelj (id_osoba, oib) VALUES ('".$_SESSION['id']."','$s_oib')";
            mysqli_query($con, $unesinarucitelja);
        }
		$idnarucitelja = mysqli_fetch_assoc(mysqli_query($con, $upit_provjera));
		$zahtjev_upit_provjera ="SELECT id FROM catering_zahtjev WHERE id_narucitelj='$idnarucitelja[id]' AND id_adresa='$_SESSION[idadresa]' AND zeljeni_datum ='$s_zdatum';";
        $rezultat = mysqli_query($con, $zahtjev_upit_provjera);  
		if (!mysqli_num_rows($rezultat)) {
            $unesiczahtjev = "INSERT INTO catering_zahtjev (id_narucitelj, id_adresa, opis, zeljeni_datum) VALUES ('$idnarucitelja[id]','$_SESSION[idadresa]','$s_opis','$s_zdatum')";
            mysqli_query($con, $unesiczahtjev);
        }
        header("Location: gost_sucelje.php");
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
    ?>
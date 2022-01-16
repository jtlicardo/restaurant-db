<?php
    include_once 'gost_konekcija.php';
    if (isset($_POST['sp_osoba'])) {
        $_SESSION['s_ime']=mysqli_real_escape_string($con, $_POST['ime']);
        $_SESSION['s_prezime']=mysqli_real_escape_string($con, $_POST['prezime']);
        $_SESSION['s_mob']=mysqli_real_escape_string($con, $_POST['mob']);
        $_SESSION['s_email']=mysqli_real_escape_string($con, $_POST['email']);
        //provjera je li osoba već unesena
        $upit_provjera="SELECT id FROM osoba WHERE ime='$_SESSION[s_ime]' AND prezime='$_SESSION[s_prezime]' AND broj_mob='$_SESSION[s_mob]' AND email='$_SESSION[s_email]';";
        $rezultat = mysqli_query($con, $upit_provjera);
        if (!mysqli_num_rows($rezultat)) {
            //unos osobe
            $unesiosobu = "INSERT INTO osoba (ime, prezime, broj_mob, email) VALUES ('".$_SESSION['s_ime']."','".$_SESSION['s_prezime']."','".$_SESSION['s_mob']."','".$_SESSION['s_email']."')";
            mysqli_query($con, $unesiosobu);
        }
        $rezultat = mysqli_query($con, $upit_provjera);
        //postavljanje sesijske varijable za prikaz
        $_SESSION['id']=mysqli_fetch_assoc($rezultat)['id'];
        header("Location: gost_sucelje.php");
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
    ?>
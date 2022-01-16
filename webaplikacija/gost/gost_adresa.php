<?php
    include_once 'gost_konekcija.php';
    if (isset($_POST['sp_adresa'])) {
        $_SESSION['s_drzava']=mysqli_real_escape_string($con, $_POST['drzava']);
        $_SESSION['s_grad']=mysqli_real_escape_string($con, $_POST['grad']);
        $_SESSION['s_ulica']=mysqli_real_escape_string($con, $_POST['ulica']);
        $_SESSION['s_postanski']=mysqli_real_escape_string($con, $_POST['postanski']);
        //tražimo id adrese ukoliko postoji
        $upit_provjera="SELECT id FROM adresa WHERE drzava='$_SESSION[s_drzava]' AND grad='$_SESSION[s_grad]' AND ulica='$_SESSION[s_ulica]' AND post_broj='$_SESSION[s_postanski]';";
        $rezultat = mysqli_query($con, $upit_provjera);
        //Ukoliko nema adrese, dodajemo novu adresu
        if (!mysqli_num_rows($rezultat)) {
            $unesiadresu = "INSERT INTO adresa (drzava, grad, ulica, post_broj) VALUES ('".$_SESSION['s_drzava']."','".$_SESSION['s_grad']."','".$_SESSION['s_ulica']."','".$_SESSION['s_postanski']."')";
            mysqli_query($con, $unesiadresu);
        }
        //Ponavljamo upit nakon unešene adrese
        $rezultat = mysqli_query($con, $upit_provjera);
        //Postavljamo sesijsku varijablu koju ćemo koristiti za prikaz podataka
        $_SESSION['idadresa']=mysqli_fetch_assoc($rezultat)['id'];
        header("Location: gost_sucelje.php?update=1");
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
    ?>
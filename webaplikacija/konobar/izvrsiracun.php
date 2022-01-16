<?php 
    include_once 'konobar_konekcija.php';
    if (isset($_POST['sp_racun'])) {
        $tipplacanja = mysqli_real_escape_string($con, $_POST['tip']);
        //dodaje račun
        $racundodaj ="INSERT INTO racun (sifra,id_nacin_placanja,id_stol,id_djelatnik) VALUES (kreiraj_sifru_racuna_autoincrement(),'$tipplacanja','$_SESSION[trenutnistol]','$_SESSION[idkonobar]')";
        mysqli_query($con, $racundodaj);
        //nabava id za dodavanje stavki
        $upit_provjera="SELECT * FROM racun WHERE id_djelatnik='$_SESSION[idkonobar]' AND id_stol='$_SESSION[trenutnistol]' ORDER BY vrijeme_izdavanja DESC;";
        $rezultat = mysqli_fetch_assoc(mysqli_query($con, $upit_provjera))['id'];
        //dodavanje stavki
        $dodajstavke = mysqli_query($con, "SELECT * FROM konobar_racun WHERE id_stol='$_SESSION[trenutnistol]';");
        while ($stavka = mysqli_fetch_assoc($dodajstavke)) {
            $dodajstavkuracunu = "INSERT INTO stavka_racun (id_racun,id_meni,kolicina,cijena_hrk) VALUES ('$rezultat','$stavka[id]','$stavka[kolicina]','$stavka[cijena]')";
            mysqli_query($con, $dodajstavkuracunu);
        }
        //ciscenje stola iz baze za kasu
        $brisanjestavki = "DELETE FROM konobar_racun WHERE id_stol='$_SESSION[trenutnistol]';";
        mysqli_query($con, $brisanjestavki);
        header("Location: konobar_sucelje.php?update=2");
    }
<?php 
    include_once '../gost_konekcija.php';
    if (isset($_POST['sp_nabavastavka'])) {
        $sn_naziv=mysqli_real_escape_string($con, $_POST['naziv']);
        $sn_kolicina=mysqli_real_escape_string($con, $_POST['kolicina']);
        $sn_cijena=mysqli_real_escape_string($con, $_POST['cijena']);
        $novanab="CALL dodaj_stavku_za_nabavu ('$sn_naziv','$sn_kolicina', '$sn_cijena');";
        $rezultat = mysqli_query($con, $novanab);
        header("Location: poslovodja_skladiste.php");
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
?>
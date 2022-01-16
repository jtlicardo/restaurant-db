<?php
    include_once 'poslovodja_konekcija.php';
    if (isset($_POST['sp_poslovodja'])) {
        $osobniidposlovodja=mysqli_real_escape_string($con, $_POST['idposlovodja']);
        $upit_provjera="SELECT id FROM djelatnik WHERE id='$osobniidposlovodja' AND id_zanimanje='8' AND zaposlen='D';";
        $rezultat = mysqli_query($con, $upit_provjera);
        if (!mysqli_num_rows($rezultat)>0) {
            echo "Dogodila se greška. Molimo pokušajte kasnije.";
        } else {
            $_SESSION['id_poslovodja'] = mysqli_fetch_assoc($rezultat)['id'];
        }
        header("Location: poslovodja_sucelje.php");
    }
    ?>
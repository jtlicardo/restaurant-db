<?php 
    include_once '../gost_konekcija.php';
    if (isset($_POST['sp_nabava'])) {
        $sn_id=mysqli_real_escape_string($con, $_POST['iddobavljaca']);
        $sn_opis=mysqli_real_escape_string($con, $_POST['opis']);
        $sn_datum=mysqli_real_escape_string($con, $_POST['datum']);
        $novanab="CALL stvori_nabavu ('$sn_id','$sn_opis', 'N','$sn_datum');";
        $rezultat = mysqli_query($con, $novanab);
        header("Location: poslovodja_skladiste.php");
        mysqli_commit($con);
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
    ?>
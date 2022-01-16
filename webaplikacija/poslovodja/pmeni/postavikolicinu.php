<?php
    include_once '../poslovodja_konekcija.php';
    if (isset($_POST['sp_kol'])) {
        $idnamirnice = mysqli_real_escape_string($con,$_POST['id']);
        $kolicinanamirnice = mysqli_real_escape_string($con,$_POST['kolicina']);
        mysqli_query($con, "UPDATE namirnicenoves SET kolicina=".(double)$kolicinanamirnice." WHERE id=$idnamirnice;");
    }
    header("Location: poslovodja_dodajmeni.php?update=1");
?>
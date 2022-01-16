<?php
    include_once 'konobar_konekcija.php';
    if (isset($_SESSION['idkonobar'])) {
        $stol=mysqli_real_escape_string($con,$_GET['ostol']);
        $konobarnastolu = mysqli_query($con, "SELECT id_konobar FROM konobar_racun WHERE id_stol='$stol'");
        if (!mysqli_num_rows($konobarnastolu) || mysqli_fetch_assoc($konobarnastolu)['id_konobar']==$_SESSION['idkonobar']) {
            $_SESSION['trenutnistol']= mysqli_real_escape_string($con, $_GET['ostol']);
        }
    }
            header("Location: konobar_sucelje.php?update=1");
?>
<?php
    include_once '../poslovodja_konekcija.php';
    if (isset($_POST['sp_smjena'])) {
        $sp_datumsmjena=mysqli_real_escape_string($con, $_POST['datumsmjena']);
        $_SESSION['s_datumsmjena']=$sp_datumsmjena;
        header("Location: poslovodja_smjene.php");
    }
    ?>
<?php
    include_once '../gost_konekcija.php';    
    if (isset($_SESSION['id_poslovodja'])){
        $op = mysqli_real_escape_string($con,$_GET['operacija']);
        $djelatnikid = mysqli_real_escape_string($con,$_GET['did']);
        switch ($op){
            case 1:
                    mysqli_query($con, "DELETE FROM tablicajutro WHERE id='$djelatnikid'");
                break;
            case 2:
                    mysqli_query($con, "DELETE FROM tablicavecer WHERE id='$djelatnikid'");
                break;
        }
        header("Location: poslovodja_smjene.php?update=1");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
?>
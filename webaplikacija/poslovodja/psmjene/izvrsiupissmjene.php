<?php
    include_once '../gost_konekcija.php';
    if (isset($_SESSION['id_poslovodja']) && mysqli_num_rows(mysqli_query($con,"SELECT * FROM tablicajutro"))>0 && mysqli_num_rows(mysqli_query($con,"SELECT * FROM tablicavecer"))>0) {
        $jutarci = mysqli_query($con,"SELECT * FROM tablicajutro");
        while ($radnik = mysqli_fetch_assoc($jutarci)){
            switch ($radnik['naziv']){
                case 'kuhar'||'pomoćni kuhar'||'operater na posuđu':
                    $ubaci = mysqli_query($con,"INSERT INTO djelatnik_smjena (id_djelatnik,id_smjena,datum) VALUES ('$radnik[id]','1','$_SESSION[s_datumsmjena]');");
                    break;
                case 'poslovođa':
                    $ubaci = mysqli_query($con,"INSERT INTO djelatnik_smjena (id_djelatnik,id_smjena,datum) VALUES ('$radnik[id]','4','$_SESSION[s_datumsmjena]');");
                    break;
                case 'skladištar'||'dostavljač':
                    $ubaci = mysqli_query($con,"INSERT INTO djelatnik_smjena (id_djelatnik,id_smjena,datum) VALUES ('$radnik[id]','6','$_SESSION[s_datumsmjena]');");
            }
            }
        $vecerci = mysqli_query($con,"SELECT * FROM tablicavecer");
        while ($radnik = mysqli_fetch_assoc($vecerci)){
            switch ($radnik['naziv']){
                case 'kuhar'||'pomoćni kuhar'||'operater na posuđu':
                    $ubaci = mysqli_query($con,"INSERT INTO djelatnik_smjena (id_djelatnik,id_smjena,datum) VALUES ('$radnik[id]','2','$_SESSION[s_datumsmjena]');");
                    break;
                case 'poslovođa':
                    $ubaci = mysqli_query($con,"INSERT INTO djelatnik_smjena (id_djelatnik,id_smjena,datum) VALUES ('$radnik[id]','5','$_SESSION[s_datumsmjena]');");
                    break;
                default:
                    $ubaci = mysqli_query($con,"INSERT INTO djelatnik_smjena (id_djelatnik,id_smjena,datum) VALUES ('$radnik[id]','3','$_SESSION[s_datumsmjena]');");
                    break;
            }
            }
        mysqli_query($con, "DROP TABLE tablicajutro");
        mysqli_query($con, "DROP TABLE tablicavecer");
        header("Location: poslovodja_smjene.php");
    } else {
        header("Location: ../poslovodja_sucelje.php");
    }
?>
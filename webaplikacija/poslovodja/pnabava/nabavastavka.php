<?php 
    include_once '../poslovodja_konekcija.php';
    if (isset($_POST['sp_nabavastavka'])) {
        $sn_naziv=mysqli_real_escape_string($con, $_POST['naziv']);
        $sn_kolicina=mysqli_real_escape_string($con, $_POST['kolicina']);
        $sn_cijena=mysqli_real_escape_string($con, $_POST['cijena']);
        $kreirajtemp = mysqli_query($con,"CREATE TABLE IF NOT EXISTS tmp_nabava_stavka (
            id_namirnica INTEGER NOT NULL,
            kolicina DECIMAL(10, 2),
            cijena_hrk NUMERIC(10,2)
        );");
        $novanab=mysqli_query($con,"SELECT id FROM namirnica WHERE naziv = '$sn_naziv';");
        if ((mysqli_num_rows($novanab))&& $sn_kolicina>0 && $sn_cijena>0) {
            $nnid = mysqli_fetch_assoc($novanab);
            mysqli_query($con, "INSERT INTO tmp_nabava_stavka VALUES ('$nnid[id]', '$sn_kolicina', '$sn_cijena');");
        }
        header("Location: poslovodja_skladiste.php?update=1");
    } else {
        echo "Dogodila se greška. Molimo pokušajte kasnije.";
    }
?>
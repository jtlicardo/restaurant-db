<?php 
    include_once 'konobar_konekcija.php';
    //provjera je li stol odabran
    if (isset($_GET['dnaziv']) && isset($_SESSION['trenutnistol'])) {
        $p_naziv=mysqli_real_escape_string($con,$_GET['dnaziv']);
        //provjerava ima li stavke na trenutnom računu
        $provjeritablicu="SELECT * FROM konobar_racun WHERE naziv_stavke='$p_naziv' AND id_stol='$_SESSION[trenutnistol]';";
        $rezultat=mysqli_query($con, $provjeritablicu);
        //ako nema dodaje u tablicu ukoliko je operacija za dodavanje
        if ((mysqli_num_rows($rezultat)==0) && ($_GET['operacija']==1)) {
            $nadjiid="SELECT * FROM meni WHERE naziv_stavke='$p_naziv'";
            $idmenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['id'];
            $cijenamenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['cijena_hrk'];
            $unesiutablicu="INSERT INTO konobar_racun (id, id_stol, id_konobar, naziv_stavke, kolicina, cijena) VALUES ('$idmenistavka','$_SESSION[trenutnistol]','$_SESSION[idkonobar]','$p_naziv','1','$cijenamenistavka')";
        } else {
            if ($_GET['operacija']==1) {
                //updatea količinu ukoliko postoji i operacija je zbrajanje
                $unesiutablicu="UPDATE konobar_racun SET kolicina=kolicina+1 WHERE naziv_stavke='$p_naziv' AND id_stol='$_SESSION[trenutnistol]';";
            } elseif (($_GET['operacija']==2) && (mysqli_fetch_assoc($rezultat)['kolicina']>1)) {
                //ukoliko je operacija oduzimanje i ima preko 1, oduzima normalno
                $unesiutablicu="UPDATE konobar_racun SET kolicina=kolicina-1 WHERE naziv_stavke='$p_naziv' AND id_stol='$_SESSION[trenutnistol]';";
            } else {
                //ukoliko je operacija oduzimanje i ima 1, briše ju
                $unesiutablicu="DELETE FROM konobar_racun WHERE naziv_stavke='$p_naziv' AND id_stol='$_SESSION[trenutnistol]';";
            }
        }
        mysqli_query($con,$unesiutablicu);
    }
    header("Location: konobar_sucelje.php?update=1");
?>
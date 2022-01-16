<?php
    include_once 'gost_konekcija.php';
    if (isset($_GET['dnaziv'])) {
        $p_naziv=mysqli_real_escape_string($con,$_GET['dnaziv']);
        //provjera postoji li u tablici za dostavu dotična stavka
        $provjeritablicu="SELECT * FROM gost_dostava WHERE naziv_stavke='$p_naziv';";
        $rezultat=mysqli_query($con, $provjeritablicu);
        //ako je zatražena operacija zbrajanje i nema stavke, stvara se nova stavka
        if ((mysqli_num_rows($rezultat)==0) && ($_GET['operacija']==1)) {
            $nadjiid="SELECT * FROM meni WHERE naziv_stavke='$p_naziv';";
            $idmenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['id'];
            $cijenamenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['cijena_hrk'];
            $unesiutablicu="INSERT INTO gost_dostava (id, naziv_stavke, kolicina, cijena) VALUES ('$idmenistavka','$p_naziv','1','$cijenamenistavka')";
        } else {
            if ($_GET['operacija']==1) {
                //ako je zatražena operacija zbrajanje i stavka postoji, dodaje se stavci
                $unesiutablicu="UPDATE gost_dostava SET kolicina=kolicina+1 WHERE naziv_stavke='$p_naziv';";
            } elseif (($_GET['operacija']==2) && (mysqli_fetch_assoc($rezultat)['kolicina']>1)) {
                //ako je zatražena operacija oduzimanje i kolicina je minimum 2, oduzima se
                $unesiutablicu="UPDATE gost_dostava SET kolicina=kolicina-1 WHERE naziv_stavke='$p_naziv';";
            } else {
                //ako je zatražena operacija oduzimanje i kolicina je 1, briše stavku
                $unesiutablicu="DELETE FROM gost_dostava WHERE naziv_stavke='$p_naziv';";
            }
        }
        mysqli_query($con,$unesiutablicu);
    }
    header("Location: gost_sucelje.php?update=1");
?>
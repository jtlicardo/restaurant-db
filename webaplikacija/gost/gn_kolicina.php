<?php 
    include_once 'gost_konekcija.php';
    if (isset($_GET['dnaziv'])) {
        $p_naziv=mysqli_real_escape_string($con,$_GET['dnaziv']);
        $provjeritablicu="SELECT * FROM gost_dostava WHERE naziv_stavke='$p_naziv';";
        $rezultat=mysqli_query($con, $provjeritablicu);
        if ((mysqli_num_rows($rezultat)==0) && ($_GET['operacija']==1)) {
            $nadjiid="SELECT * FROM meni WHERE naziv_stavke='$p_naziv';";
            $idmenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['id'];
            $cijenamenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['cijena_hrk'];
            $unesiutablicu="INSERT INTO gost_dostava (id, naziv_stavke, kolicina, cijena) VALUES ('$idmenistavka','$p_naziv','1','$cijenamenistavka')";
        } else {
            if ($_GET['operacija']==1) {
                $unesiutablicu="UPDATE gost_dostava SET kolicina=kolicina+1 WHERE naziv_stavke='$p_naziv';";
            } elseif (($_GET['operacija']==2) && (mysqli_fetch_assoc($rezultat)['kolicina']>1)) {
                $unesiutablicu="UPDATE gost_dostava SET kolicina=kolicina-1 WHERE naziv_stavke='$p_naziv';";
            } else {
                $unesiutablicu="DELETE FROM gost_dostava WHERE naziv_stavke='$p_naziv';";
            }
        }
        mysqli_query($con,$unesiutablicu);
    }
    header("Location: gost_sucelje.php?update=1");
?>
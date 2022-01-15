<?php 
    include_once '../gost_konekcija.php';
    if (isset($_GET['did']) && isset($_SESSION['s_idcatering'])) {
        $id=mysqli_real_escape_string($con,$_GET['did']);
        $provjeritablicu="SELECT * FROM trenutni_catering WHERE id_meni='$id';";
        $rezultat=mysqli_query($con, $provjeritablicu);
        if ((mysqli_num_rows($rezultat)==0) && ($_GET['operacija']==1)) {
            $nadjiid="SELECT * FROM meni WHERE id='$id'";
            $idmenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['id'];
            $stavkameninaziv = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['naziv_stavke'];
            $cijenamenistavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid))['cijena_hrk'];
            $unesiutablicu="INSERT INTO trenutni_catering (id_meni, naziv_stavkec, kolicina, cijena_hrk) VALUES ('$idmenistavka','$stavkameninaziv','1','$cijenamenistavka')";
        } else {
            if ($_GET['operacija']==1) {
                $unesiutablicu="UPDATE trenutni_catering SET kolicina=kolicina+1 WHERE id_meni='$id';";
            } elseif (($_GET['operacija']==2) && (mysqli_fetch_assoc($rezultat)['kolicina']>1)) {
                $unesiutablicu="UPDATE trenutni_catering SET kolicina=kolicina-1 WHERE id_meni='$id';";
            } else {
                $unesiutablicu="DELETE FROM trenutni_catering WHERE id_meni='$id';";
            }
        }
        mysqli_query($con,$unesiutablicu);
    }
    header("Location: p_zahtjevcatering.php?update=1");
?>
<?php 
    include_once '../poslovodja_konekcija.php';
    if (isset($_GET['did'])) {
        $p_id=mysqli_real_escape_string($con,$_GET['did']);
        $provjeritablicu="SELECT * FROM namirnicenoves WHERE id='$p_id';";
        $rezultat=mysqli_query($con, $provjeritablicu);
        if ((mysqli_num_rows($rezultat)==0) && ($_GET['operacija']==1)) {
            $nadjiid="SELECT * FROM namirnica WHERE id='$p_id';";
            $idnamirnicastavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid));
            $unesiutablicu="INSERT INTO namirnicenoves (id,naziv,kolicina) VALUES ('$idnamirnicastavka[id]','$idnamirnicastavka[naziv]',null)";
            mysqli_query($con,$unesiutablicu);
        } else {
            if ($_GET['operacija']==2) {
                $unesiutablicu="DELETE FROM namirnicenoves WHERE id='$p_id';";
                mysqli_query($con,$unesiutablicu);
            }
        }
    }
    header("Location: poslovodja_dodajmeni.php?update=1");
?>
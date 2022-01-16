<?php 
    include_once '../poslovodja_konekcija.php';
    if (isset($_GET['did'])) {
        $p_id=mysqli_real_escape_string($con,$_GET['did']);
        $provjeritablicu="SELECT * FROM tablicaalergeni WHERE id='$p_id';";
        $rezultat=mysqli_query($con, $provjeritablicu);
        if ((mysqli_num_rows($rezultat)==0) && ($_GET['operacija']==1)) {
            $nadjiid="SELECT * FROM alergen WHERE id='$p_id';";
            $idalergenstavka = mysqli_fetch_assoc(mysqli_query($con,$nadjiid));
            $unesiutablicu="INSERT INTO tablicaalergeni (id,naziv) VALUES ('$idalergenstavka[id]','$idalergenstavka[naziv]')";
            mysqli_query($con,$unesiutablicu);
        } else {
            if ($_GET['operacija']==2) {
                $unesiutablicu="DELETE FROM tablicaalergeni WHERE id='$p_id';";
                mysqli_query($con,$unesiutablicu);
            }
        }
    }
    header("Location: poslovodja_dodajmeni.php?update=1");
?>
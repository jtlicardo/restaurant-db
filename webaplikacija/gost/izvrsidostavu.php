<?php 
    include_once 'gost_konekcija.php';
    $dostavadodaj ="INSERT INTO dostava (id_osoba,id_adresa,datum,izvrsena) VALUES ('".intval($_SESSION['id'])."','".intval($_SESSION['idadresa'])."',curdate(),'N')";
    mysqli_query($con,$dostavadodaj);
    $upit_provjera="SELECT id FROM dostava WHERE id_osoba='$_SESSION[id]' AND id_adresa='$_SESSION[idadresa]' AND datum=curdate() AND izvrsena='N';";
    $rezultat = mysqli_fetch_assoc(mysqli_query($con, $upit_provjera))['id'];
    $dodajstavke = mysqli_query($con,"SELECT * FROM gost_dostava");
    while ($stavka = mysqli_fetch_assoc($dodajstavke)){
        $dodajstavkudostave = "INSERT INTO dostava_stavka (id_dostava,id_meni,kolicina,cijena_hrk) VALUES ('$rezultat','$stavka[id]','$stavka[kolicina]','$stavka[cijena]')";
		mysqli_query($con,$dodajstavkudostave);
    }
    mysqli_query($con, "DROP TABLE gost_dostava");
    header("Location: gost_sucelje.php?update=2");
<?php
    include_once '../poslovodja_konekcija.php';
?>
<!DOCTYPE html>
<html>

<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous">
    </script>

</head>

<body class='text-light bg-dark'>
    <section style=''>
        <a class='my-2 mx-2 btn btn-success' href='../../index.php'>&#8962;</a>
        <a class='my-2 mx-2 btn btn-info' href='../psmjene/poslovodja_smjene.php'>Smjene</a>
        <a class='my-2 mx-2 btn btn-info' href='../djelatnik/poslovodja_djelatnici.php'>Djelatnici</a>
        <a class='my-2 mx-2 btn btn-info' href='../pnabava/poslovodja_skladiste.php'>Skladište</a>
        <a class='my-2 mx-2 btn btn-info' href='poslovodja_catering.php'>Catering</a>
        <a class='my-2 mx-2 btn btn-info' href='../pmeni/poslovodja_meniad.php'>Meni</a>
        <a class='my-2 mx-2 btn btn-info' href='../panaliza/poslovodja_analiza.php'>Analiza</a>
        <h1>Catering zahtjev</h1>
    </section><?php
    include_once '../poslovodja_konekcija.php';
    if (isset($_GET['did'])) {
        $_SESSION['s_idcatering']=mysqli_real_escape_string($con, $_GET['did']);
    }
    $podacioc = mysqli_fetch_assoc(mysqli_query($con,"SELECT * FROM catering_zahtjev JOIN adresa ON catering_zahtjev.id_adresa=adresa.id WHERE catering_zahtjev.id='$_SESSION[s_idcatering]'"));
    echo "<p>
    '$podacioc[opis]'<br>
    '$podacioc[drzava]'<br>
    '$podacioc[grad]'<br>
    '$podacioc[ulica]'<br></p>";
    $tablicaracuna = "CREATE TABLE IF NOT EXISTS trenutni_catering
(
id_meni	int,
naziv_stavkec varchar(50),
kolicina int,	
cijena_hrk decimal(10,2)
);";
$tablicadjelatnika = "CREATE TABLE IF NOT EXISTS tablicadjelatnika
(
id_djelatnik int,
ime varchar(50),
prezime varchar(50),	
zanimanje varchar(50)
);";
$meni = mysqli_query($con,"SELECT * FROM aktivni_meni");
mysqli_query($con,$tablicaracuna);
mysqli_query($con,$tablicadjelatnika);
echo " <section  style='width:50%; float:left; overflow-y:scroll; overflow-x:hidden;  height:240px;'><table class='table table-dark table-striped'><thead>
<tr>
    <td>Naziv jela</td>
    <td>Cijena</td>
    <td>Alergen</td>
</tr>
</thead>
<tbody >";
    while ($redakmenija = mysqli_fetch_assoc($meni)){
    $alergen = '|';
    echo "<tr>
            <td>".$redakmenija['naziv_stavke']."</td>
            <td>".$redakmenija['cijena_hrk']." hrk</td>";
            $provjerialergen = mysqli_query($con,"SELECT alergen.naziv FROM sadrzi_alergen JOIN alergen ON sadrzi_alergen.id_alergen=alergen.id WHERE sadrzi_alergen.id_meni='$redakmenija[id]';");
            if (!mysqli_num_rows($provjerialergen)) {
                $alergen = 'nema';
            } else {
                while ($alergenid = mysqli_fetch_assoc($provjerialergen)) {
                    $alergen .= $alergenid['naziv'].'|';
                }
            }
    echo "<td>$alergen</td>
        <td><a class='my-2 btn btn-info' href='pn_kolicina.php?did=".$redakmenija['id']."&operacija=1'>+</a>
            <a class='my-2 btn btn-info' href='pn_kolicina.php?did=".$redakmenija['id']."&operacija=2'>-</a></td>
        </tr>";
    }
    echo "
    </tbody>
    </table> </section>
    <section style='display:inline-block;'>
    <table class='table table-dark table-striped'><thead>
    <tr>
        <td>Naziv stavke</td>
        <td>količina</td>
        <td>Cijena</td>
    </tr>
    </thead>
    <tbody style='overflow-y:scroll; overflow-x:hidden'>";
        if (isset($_GET['update'])) {
            $total=0;
            $podacioracunu = mysqli_query($con, "SELECT * FROM trenutni_catering");
            while ($redakracuna = mysqli_fetch_assoc($podacioracunu)) {
                $total=$redakracuna['kolicina']*$redakracuna['cijena_hrk'];
                echo "<tr>
            <td>".$redakracuna['naziv_stavkec']."</td>
            <td>".$redakracuna['kolicina']."</td>
            <td>".$redakracuna['kolicina']*$redakracuna['cijena_hrk']." hrk</td>
            </tr>";
            $total+=$redakracuna['kolicina']*$redakracuna['cijena_hrk'];
            }
            echo "<tr><td>TOTAL:</td><td></td>
            <td>".$total." hrk</td></tr>";
        }
    echo "
    </tbody>
    </table></section>";
    echo " <section  style='width:360px; display:block;'><h3 style='color:#FFF;'>Djelatnici</h3>
     <section  style='overflow-y:scroll; overflow-x:hidden;  height:160px;'>
    <table class='table table-dark table-striped'>
    <tbody>";
    $djelatnici = mysqli_query($con, "SELECT djelatnik.id,osoba.ime,osoba.prezime,zanimanje.naziv FROM djelatnik JOIN osoba ON djelatnik.id_osoba=osoba.id JOIN zanimanje ON zanimanje.id=djelatnik.id_zanimanje;");
        while ($djelatnik = mysqli_fetch_assoc($djelatnici)) {
            echo "<tr>
                <td>".$djelatnik['ime']."<br>".$djelatnik['prezime']."</td>
                <td>".$djelatnik['naziv']."</td>
                <td><a class='my-2 btn btn-info' href='p_dodajc.php?did=".$djelatnik['id']."&operacija=1'>dodaj</a>
                <br><a class='my-2 btn btn-info' href='p_dodajc.php?did=".$djelatnik['id']."&operacija=2'>makni</a></td></tr>";
        }
    echo "</tbody></table></section>
     <section  style='width:360px; display:block;'><h3 style='color:#FFF;'>Catering tim</h3>
     <section  style='overflow-y:scroll; overflow-x:hidden;  height:160px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
            if (isset($_GET['update'])) {
                $c_djelatnici = mysqli_query($con, "SELECT * FROM tablicadjelatnika");
                while ($c_djelatnik = mysqli_fetch_assoc($c_djelatnici)) {
                    echo "<tr>
                <td>".$c_djelatnik['ime']." ".$c_djelatnik['prezime']."</td>
                <td>".$c_djelatnik['zanimanje']."</td></tr>";
                }
            }
        echo "
        </tbody>
        </table></section></section>";
echo "</tbody></table></section></section><a class='my-2 btn btn-info' href='p_ispunicatering.php'>Ispuni catering</a>";
?>

</body>

</html>
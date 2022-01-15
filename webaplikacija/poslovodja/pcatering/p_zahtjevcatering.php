<?php
    include_once '../gost_konekcija.php';
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
echo "<section style='width:50%; float:left; overflow-y:scroll; height:240px;'><table style=''><thead>
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
        <td><a class='btn btn-info' href='pn_kolicina.php?did=".$redakmenija['id']."&operacija=1'>+</a>
            <a class='btn btn-info' href='pn_kolicina.php?did=".$redakmenija['id']."&operacija=2'>-</a></td>
        </tr>";
    }
    echo "
    </tbody>
    </table> </section>
    <table style='height:240px;'><thead>
    <tr>
        <td>Naziv stavke</td>
        <td>količina</td>
        <td>Cijena</td>
    </tr>
    </thead>
    <tbody>";
        if (isset($_GET['update'])) {
            $total=0;
            $podacioracunu = mysqli_query($con, "SELECT * FROM trenutni_catering");
            while ($redakracuna = mysqli_fetch_assoc($podacioracunu)) {
                $total=$redakracuna['kolicina']*$redakracuna['cijena_hrk'];
                echo "<tr>
            <td>".$redakracuna['naziv_stavkec']."</td>
            <td>".$redakracuna['kolicina']."</td>
            <td>".$total."</td>
            </tr>";
            }
        }
    echo "
    </tbody>
    </table>
    <a class='btn btn-info' href='p_ispunicatering.php'> </a>";
    echo "<section style='width:360px; float:left;'><h3 style='color:#FFF;'>Djelatnici</h3>
    <section style='overflow-y:scroll; height:160px;'>
    <table class='table table-dark table-striped'>
    <tbody>";
    $djelatnici = mysqli_query($con, "SELECT djelatnik.id,osoba.ime,osoba.prezime,zanimanje.naziv FROM djelatnik JOIN osoba ON djelatnik.id_osoba=osoba.id JOIN zanimanje ON zanimanje.id=djelatnik.id_zanimanje;");
        while ($djelatnik = mysqli_fetch_assoc($djelatnici)) {
            echo "<tr>
                <td>".$djelatnik['ime']."<br>".$djelatnik['prezime']."</td>
                <td>".$djelatnik['naziv']."</td>
                <td><a class='btn btn-info' href='p_dodajc.php?did=".$djelatnik['id']."&operacija=1'>dodaj</a>
                <br><a class='btn btn-info' href='p_dodajc.php?did=".$djelatnik['id']."&operacija=1'>makni</a></td></tr>";
        }
    echo "</tbody></table></section>
    <section style='width:360px; float:left;'><h3 style='color:#FFF;'>Catering tim</h3>
    <section style='overflow-y:scroll; height:160px;'>
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
    echo "</tbody></table></section></section>
        <a class='btn btn-info' href='p_ispunicatering.php'>Ispuni catering</a>";
?>
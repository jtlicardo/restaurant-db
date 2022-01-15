<?php
    include_once 'gost_konekcija.php';
?>
<!DOCTYPE html>
<html>

<body>
    <form action="gost_info.php" method="POST">
        <input type="text" name="ime" placeholder="ime">
        <input type="text" name="prezime" placeholder="prezime">
        <input type="text" name="mob" placeholder="mobitel">
        <input type="text" name="email" placeholder="email">
        <button type="submit" name="sp_osoba">Pošalji zahtjev</button>
    </form>
    <p>
        <?php
        if (!isset($_SESSION['id'])) {
            echo "<p>Podaci nisu unešeni.</p>";
            } else {
            echo "Ime: ".$_SESSION['s_ime'].
            "<br>Prezime: ".$_SESSION['s_prezime'].
            "<br>Broj mobitela: ".$_SESSION['s_mob'].
            "<br>E-mail: ".$_SESSION['s_email'];
        }
        ?>
    </p>
    <form action="gost_rezervacijastola.php" method="POST">
        <input type="number" name="idstol" placeholder="broj stola">
        <input type="date" name="datum" placeholder="datum">
        <input type="time" name="vrijemeod" placeholder="vrijeme od">
        <input type="time" name="vrijemedo" placeholder="vrijeme od">
        <input type="number" name="brojgostiju" placeholder="broj ljudi">
        <button type="submit" name="sp_stol">Rezerviraj stol</button>
    </form>
    <p>
        <?php
        if (isset($_SESSION['rstol'])) {
            if ($_SESSION['rstol']=="Rezervacija kreirana!") {
                echo "Stol: ".$_SESSION['s_idstol'].
                "<br>Datum:".$_SESSION['s_datum'].
                "<br>Od: ".$_SESSION['s_vrijemeod'].
                "<br>Do: ".$_SESSION['s_vrijemedo']. 
                "<br>Broj ljudi: ".$_SESSION['s_brojgostiju']."<br>";
            }
            echo $_SESSION['rstol'];
        }
        ?>
    </p>
    <?php
        $meni = mysqli_query($con,"SELECT * FROM aktivni_meni");
        $tablicadostave = "CREATE TABLE IF NOT EXISTS gost_dostava
        (
    id integer not null,
    naziv_stavke varchar(70) not null,
    kolicina integer not null,
    cijena decimal(10,2) not null
);";
mysqli_query($con,$tablicadostave);
        echo "<section style='width:50%; float:left; overflow-y:scroll; height:240px;'><table><thead>
        <tr>
            <td>Naziv jela</td>
            <td>Cijena</td>
            <td>Alergen</td>
        </tr>
        </thead>
        <tbody style=''>";
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
                <td><a href='gn_kolicina.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=1'>+</a>
                    <a href='gn_kolicina.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=2'>-</a></td>
                </tr>";
            }
            echo "
            </tbody>
            </table> </section>
            <section style='width:50%; float:left;'>
            <h3>Vaša dostava</h3><table><thead>
            <tr>
                <td>Naziv jela</td>
                <td>količina</td>
            </tr>
            </thead>
            <tbody>";
            if (isset($_GET['update'])) {
                $podaciodostavi = mysqli_query($con, "SELECT * FROM gost_dostava");
                while ($redakdostave = mysqli_fetch_assoc($podaciodostavi)) {
                    echo "
                <tr>
                    <td>".$redakdostave['naziv_stavke']."</td>
                    <td>".$redakdostave['kolicina']."</td>
                    </tr>";
                }
                
            }
            echo "
            </tbody>
            </table>";
        ?>
    <form action="gost_adresa.php" method="POST">
        <input type="text" name="drzava" placeholder="drzava">
        <input type="text" name="grad" placeholder="grad">
        <input type="text" name="ulica" placeholder="ulica">
        <input type="text" name="postanski" placeholder="poštanski broj">
        <button type="submit" name="sp_adresa">Pošalji zahtjev</button>
    </form>
    <p>
        <?php
        if (!isset($_SESSION['idadresa'])) {
            echo "<p>Podaci nisu unešeni.</p>";
            } else {
            echo "<p>drzava: ".$_SESSION['s_drzava'].
            "<br>Grad: ".$_SESSION['s_grad'].
            "<br>Ulica: ".$_SESSION['s_ulica'].
            "<br>Postanski: ".$_SESSION['s_postanski']."</p>
            <br><a href='izvrsidostavu.php'>
            Naruči dostavu</a></section>";
        }
		
        ?>
    <form action="gost_cateringzahtjev.php" method="POST">
        <input type="text" name="oib" placeholder="oib">
        <textarea name="opis" rows="10" cols="50"></textarea>
        <input type="date" name="zdatum" placeholder="zdatum">
        <button type="submit" name="sp_cateringzahtjev">Pošalji zahtjev</button>
    </form>
</body>

</html>
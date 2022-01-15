<?php
    include_once 'gost_konekcija.php';
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
    <form action="konobar_info.php" method="POST">
        <input type="text" name="idkonobar" placeholder="šifra konobara">
        <button class='btn btn-success'type="submit" name="sp_konobar">Odaberi šifru</button>
    </form>
    <p>
        <?php
        if (!isset($_SESSION['idkonobar'])) {
            echo "<p>Molimo unesite svoju šifru.</p>";
            } else {
				echo "Ćao mali".$_SESSION['idkonobar'];
			}
            ?>
    </p>
    <?php
    echo "<h3 style='color:#FFF;'>Stol</h3>";
    $tablicaracuna = "CREATE TABLE IF NOT EXISTS konobar_racun
(
id integer not null,
id_stol integer not null,
id_konobar integer not null,
naziv_stavke varchar(70) not null,
kolicina integer not null,
cijena decimal(10,2) not null
);";
    if (isset($_SESSION['idkonobar'])){
        $stolovi = mysqli_query($con, "SELECT id FROM stol");
        while ($stol = mysqli_fetch_assoc($stolovi)){
            $konobarnastolu = mysqli_query($con, "SELECT id_konobar FROM konobar_racun WHERE id_stol='$stol[id]'");
            if (!mysqli_num_rows($konobarnastolu) || mysqli_fetch_assoc($konobarnastolu)['id_konobar']==$_SESSION['idkonobar']) {
                echo "<a class='btn btn-info' href='konobar_odaberistol.php?ostol=".$stol['id']."'>'$stol[id]'</a>";
            }
        }
    }
    if (isset($_SESSION['trenutnistol'])){
        echo "Vaš stol je".$_SESSION['trenutnistol'];
    }
?>
    <?php
$meni = mysqli_query($con,"SELECT * FROM aktivni_meni");
mysqli_query($con,$tablicaracuna);
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
        <td><a class='btn btn-info' href='kn_kolicina.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=1'>+</a>
            <a class='btn btn-info' href='kn_kolicina.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=2'>-</a></td>
        </tr>";
    }
    echo "
    </tbody>
    </table> </section>
    <section style='width:50%; float:left;'>
    <h3 style='color:#FFF;'>Račun</h3>";
    if (!isset($_SESSION['trenutnistol'])) {
        echo "odaberi stol";
    } else {
        echo "<table class='table table-dark table-striped'><thead>
    <tr>
        <td>Naziv jela</td>
        <td>količina</td>
    </tr>
    </thead>
    <tbody>";
        if (isset($_GET['update'])) {
            $podacioracunu = mysqli_query($con, "SELECT * FROM konobar_racun WHERE id_konobar='$_SESSION[idkonobar]' AND id_stol='$_SESSION[trenutnistol]'");
            while ($redakracuna = mysqli_fetch_assoc($podacioracunu)) {
                echo "
        <tr>
            <td>".$redakracuna['naziv_stavke']."</td>
            <td>".$redakracuna['kolicina']."</td>
            </tr>";
            }
        }
    }
    echo "
    </tbody>
    </table>
    <form action='izvrsiracun.php' method='POST'>
    <select name='tip'>
        <option value='1' selected>Gotovina</option>
        <option value='2'>Kartica</option>
        <option value='3'>Kripto</option>
    </select>
    <button class='btn btn-success'type='submit' name='sp_racun'>Unesi račun</button>
    </form>";
?>
</body>

</html>
<?php
    include_once '../gost_konekcija.php';
?>
<!DOCTYPE html>
<html>

<body>
    <?php
        $meni = mysqli_query($con,"SELECT * FROM meni");
        echo "<section style='width:50%; float:left; overflow-y:scroll; height:240px;'>
        <h3>Podesite koja jela imate u ponudi</h3>
        <table><thead>
        <tr>
            <td>Naziv jela</td>
            <td>Cijena</td>
            <td>Alergen</td>
            <td>Aktivno</td>
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
            <td>".$redakmenija['aktivno']."</td>
                <td><a href='poslovodja_stavkameni.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=1'>aktiviraj</a>
                    <a href='poslovodja_stavkameni.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=2'>deaktiviraj</a></td>
                </tr>";
            }
            echo "
            </tbody>
            </table> </section><a href='poslovodja_dodajmeni.php'>Dodaj</a>";?>

</body>

</html>
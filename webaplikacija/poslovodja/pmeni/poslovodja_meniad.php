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
    <?php
        $meni = mysqli_query($con,"SELECT * FROM meni");
        echo " <section  style='width:50%; float:left; overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <h3 style='color:#FFF;'>Podesite koja jela imate u ponudi</h3>
        <table class='table table-dark table-striped'><thead>
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
                <td><a class='my-2 btn btn-info' href='poslovodja_stavkameni.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=1'>aktiviraj</a>
                    <a class='my-2 btn btn-info' href='poslovodja_stavkameni.php?dnaziv=".$redakmenija['naziv_stavke']."&operacija=2'>deaktiviraj</a></td>
                </tr>";
            }
            echo "
            </tbody>
            </table> </section><a class='my-2 btn btn-info' href='poslovodja_dodajmeni.php'>Dodaj</a>";?>

</body>

</html>
<?php
    include_once '../gost_konekcija.php';
?>
<!DOCTYPE html>
<html><head><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script></head>

<body class='text-light bg-dark'>
    <?php 
    if (isset($_SESSION['id_poslovodja'])) {
        $tablicanamirnice = "CREATE TABLE IF NOT EXISTS namirnicenoves
        (
    id integer not null,
    naziv varchar(50),
    kolicina decimal(10,2) NULL
);";
$tablicalergeni = "CREATE TABLE IF NOT EXISTS tablicaalergeni
(
id integer not null,
naziv varchar(50)
);";
mysqli_query($con,$tablicanamirnice);
mysqli_query($con,$tablicalergeni);
        echo "
        <h3 style='color:#FFF;'>Unesi naziv i cijenu za novi proizvod</h3>
        <form action='poslovodja_dodajmeni2.php' method='POST'>
            <input type='text' name='ime' placeholder='naziv'>
            <input type='number' name='cijena' placeholder='cijena(2 decimale)'>
            <button class='btn btn-success'type='submit' name='sp_novas''>Spremi jelo</button>
        </form>";
        if (!isset($_SESSION['s_novastavka'])) {
            echo "<p>Podaci nisu unešeni.</p>" ;
        } else {
            echo "<p>Naziv: '$_SESSION[s_novastavka]'<br>Cijena: '
            $_SESSION[s_cijena]'hrk</p>";
        }
        echo "
        <section style='width:320px;float:left;'>
        <h3 style='color:#FFF;'>Odaberi namirnice</h3>
        <section style='overflow-y:scroll; height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $namirnice = mysqli_query($con,"SELECT * FROM namirnica;");
            while ($rednamirnice = mysqli_fetch_assoc($namirnice)) {
                echo "<tr>
                    <td>".$rednamirnice['naziv']."</td>
                    <td><a class='btn btn-info' href='dodajnamirnicu.php?did=".$rednamirnice['id']."&operacija=1'>Dodaj</a></td>
                    <td><a class='btn btn-info' href='dodajnamirnicu.php?did=".$rednamirnice['id']."&operacija=2'>Makni</a></td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section>"; 
            echo "
        <h3 style='color:#FFF;'>Odaberi alergene</h3>
        <section style='overflow-y:scroll; height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $alergeni = mysqli_query($con,"SELECT * FROM alergen;");
            while ($jedanalergen = mysqli_fetch_assoc($alergeni)) {
                echo "<tr>
                    <td>".$jedanalergen['naziv']."</td>
                    <td><a class='btn btn-info' href='dodajalergen.php?did=".$jedanalergen['id']."&operacija=1'>Dodaj</a></td>
                    <td><a class='btn btn-info' href='dodajalergen.php?did=".$jedanalergen['id']."&operacija=2'>Makni</a></td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section>"; 
            
            echo "</section>
            <section style='width:320px; float:left;'>
            <h3 style='color:#FFF;'>Namirnice</h3>
            <table class='table table-dark table-striped'>
            <tbody>";
            if (isset($_GET['update'])) {
                $podacionamirnicama = mysqli_query($con, "SELECT * FROM namirnicenoves");
                while ($redaknamirnica = mysqli_fetch_assoc($podacionamirnicama)) {
                    echo "
                <tr>
                    <td>".$redaknamirnica['naziv']."</td>
                    <td>".$redaknamirnica['kolicina']."</td>"; 
                    if ($redaknamirnica['kolicina']==NULL){
                    echo "<td><form action='postavikolicinu.php' method='POST'><input style='display:none;' type='text' name='id' value='$redaknamirnica[id]' readonly><input type='text' name='kolicina' placeholder='Unesi kolicinu'><button class='btn btn-success'type='submit' name='sp_kol'>&#10003;</button></form></td>
                    </tr>";
                }
                }
                
            }
            echo "
            </tbody>
            </table>
            <h3 style='color:#FFF;'>Prisutni alergeni</h3>
            <table class='table table-dark table-striped'>
            <tbody>";
            if (isset($_GET['update'])) {
                $podacioalergenima = mysqli_query($con, "SELECT * FROM tablicaalergeni");
                while ($redakalergen = mysqli_fetch_assoc($podacioalergenima)) {
                    echo "
                <tr>
                    <td>".$redakalergen['naziv']."</td> 
                </tr>";
                }
                }
            echo "
            </tbody>
            </table>
            <a class='btn btn-info' href='izvrsiunosmeni.php'>Završi unos menija</a>
            </section>";
    } else {
            header("Location: ../poslovodja_sucelje.php");
        }
?>
</body>

</html>
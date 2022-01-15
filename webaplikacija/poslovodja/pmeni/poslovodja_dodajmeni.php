<?php
    include_once '../gost_konekcija.php';
?>
<!DOCTYPE html>
<html>

<body>
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
        <h3>Unesi naziv i cijenu za novi proizvod</h3>
        <form action='poslovodja_dodajmeni2.php' method='POST'>
            <input type='text' name='ime' placeholder='naziv'>
            <input type='number' name='cijena' placeholder='cijena(2 decimale)'>
            <button type='submit' name='sp_novas''>Spremi jelo</button>
        </form>";
        if (!isset($_SESSION['s_novastavka'])) {
            echo "<p>Podaci nisu unešeni.</p>" ;
        } else {
            echo "<p>Naziv: '$_SESSION[s_novastavka]'<br>Cijena: '
            $_SESSION[s_cijena]'hrk</p>";
        }
        echo "
        <section style='width:320px;float:left;'>
        <h3>Odaberi namirnice</h3>
        <section style='overflow-y:scroll; height:240px;'>
        <table>
        <tbody>";
        $namirnice = mysqli_query($con,"SELECT * FROM namirnica;");
            while ($rednamirnice = mysqli_fetch_assoc($namirnice)) {
                echo "<tr>
                    <td>".$rednamirnice['naziv']."</td>
                    <td><a href='dodajnamirnicu.php?did=".$rednamirnice['id']."&operacija=1'>Dodaj</a></td>
                    <td><a href='dodajnamirnicu.php?did=".$rednamirnice['id']."&operacija=2'>Makni</a></td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section>"; 
            echo "
        <h3>Odaberi alergene</h3>
        <section style='overflow-y:scroll; height:240px;'>
        <table>
        <tbody>";
        $alergeni = mysqli_query($con,"SELECT * FROM alergen;");
            while ($jedanalergen = mysqli_fetch_assoc($alergeni)) {
                echo "<tr>
                    <td>".$jedanalergen['naziv']."</td>
                    <td><a href='dodajalergen.php?did=".$jedanalergen['id']."&operacija=1'>Dodaj</a></td>
                    <td><a href='dodajalergen.php?did=".$jedanalergen['id']."&operacija=2'>Makni</a></td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section>"; 
            
            echo "</section>
            <section style='width:320px; float:left;'>
            <h3>Namirnice</h3>
            <table>
            <tbody>";
            if (isset($_GET['update'])) {
                $podacionamirnicama = mysqli_query($con, "SELECT * FROM namirnicenoves");
                while ($redaknamirnica = mysqli_fetch_assoc($podacionamirnicama)) {
                    echo "
                <tr>
                    <td>".$redaknamirnica['naziv']."</td>
                    <td>".$redaknamirnica['kolicina']."</td>"; 
                    if ($redaknamirnica['kolicina']==NULL){
                    echo "<td><form action='postavikolicinu.php' method='POST'><input style='display:none;' type='text' name='id' value='$redaknamirnica[id]' readonly><input type='text' name='kolicina' placeholder='Unesi kolicinu'><button type='submit' name='sp_kol'>&#10003;</button></form></td>
                    </tr>";
                }
                }
                
            }
            echo "
            </tbody>
            </table>
            <h3>Prisutni alergeni</h3>
            <table>
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
            <a href='izvrsiunosmeni.php'>Završi unos menija</a>
            </section>";
    } else {
            header("Location: ../poslovodja_sucelje.php");
        }
?>
</body>

</html>
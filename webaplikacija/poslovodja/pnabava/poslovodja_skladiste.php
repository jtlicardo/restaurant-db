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
        <a class='my-2 mx-2 btn btn-info disabled' href='poslovodja_skladiste.php'>Skladište</a>
        <a class='my-2 mx-2 btn btn-info' href='../pcatering/poslovodja_catering.php'>Catering</a>
        <a class='my-2 mx-2 btn btn-info' href='../pmeni/poslovodja_meniad.php'>Meni</a>
        <a class='my-2 mx-2 btn btn-info' href='../panaliza/poslovodja_analiza.php'>Analiza</a>
        <h1>Skladište</h1>
    </section>
    <?php
//realno stanje namirnica
    include 'stanje_namirnica.php';
//namirnice koje bi mogli nabaviti
    include 'namirnicenabava.php';
//izvrsavanje otpisa stavke
    echo "<h3 style='color:#FFF;'>Izvrši otpis nad stavkom</h3>
        <form action='dodajnaotpis.php' method='POST'>
            <input type='text' name='naziv' placeholder='naziv'>
            <input type='number' name='kolicina' placeholder='količina'>
            <button class='my-2 btn btn-success' type='submit' name='sp_otpis'>Izvrši otpis</button>
        </form>";
        if (isset($_GET['otpis'])){
            if ($_GET['otpis']==1) {
                echo "Uspješno ste otpisali stavku!";
            }
        }
//nabava
    include 'nabavastavkaform.php';
    include 'nabavaform.php';
    echo "
         <section  style='width:320px;float:left;'>
        <h3 style='color:#FFF;'>Unos nabave</h3>
        <p>naziv |kolicina |cijena</p>
         <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
    if (isset($_GET['update'])) {
            $upit = mysqli_query($con, "SELECT * FROM tmp_nabava_stavka;");
            while ($red = mysqli_fetch_assoc($upit)) {
                $mark = mysqli_fetch_assoc(mysqli_query($con, "SELECT naziv FROM namirnica WHERE namirnica.id='$red[id_namirnica]'"));
                echo "<tr>
                    <td>".$mark['naziv']."</td>
                    <td>".$red['kolicina']."</td>
                    <td>".$red['cijena_hrk']."</td>
                    </tr>";
            }
        }
        echo "
        </tbody>
        </table>
        </section></section>";
    ?>
</body>

</html>
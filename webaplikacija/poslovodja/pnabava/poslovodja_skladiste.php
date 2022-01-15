<?php
  include_once '../gost_konekcija.php';
  mysqli_autocommit($con, false);
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
    include 'stanje_namirnica.php';
    include 'namirnicenabava.php';
    echo "<h3 style='color:#FFF;'>Izvrši otpis nad stavkom</h3>
        <form action='dodajnaotpis.php' method='POST'>
            <input type='text' name='naziv' placeholder='naziv'>
            <input type='number' name='kolicina' placeholder='količina'>
            <button class='btn btn-success' type='submit' name='sp_otpis'>Izvrši otpis</button>
        </form>";
    include 'nabavastavkaform.php';
    include 'nabavaform.php';
    $val= mysqli_num_rows(mysqli_query($con,"SHOW TABLES LIKE 'tmp_nabava_stavka';"));
    if ($val > 0){
      echo "
        <section style='width:320px;float:left;'>
        <h3 style='color:#FFF;'>Namirnice za nabavu</h3>
        <p>naziv |kolicina |promet prošle godine |omjer</p>
        <section style='overflow-y:scroll; height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT * FROM tmp_nabava_stavka;");
            while ($red = mysqli_fetch_assoc($upit)) {
                $mark = mysqli_fetch_assoc(mysqli_query($con, "SELECT naziv FROM namirnica WHERE namirnica.id='$red[id_namirnica]'"));
                echo "<tr>
                    <td>".$mark['naziv']."</td>
                    <td>".$red['kolicina']."</td>
                    <td>".$red['cijena_hrk']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
    }
    ?>
</body>

</html>
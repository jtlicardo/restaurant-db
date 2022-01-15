<?php
    include_once 'gost_konekcija.php';
?>
<!DOCTYPE html>
<html><head><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script></head>

<body class='text-light bg-dark'>
    <section>
        <form action="poslovodja_info.php" method="POST">
            <input type="text" name="idposlovodja" placeholder="šifra ovlaštene osobe">
            <button class='btn btn-success'type="submit" name="sp_poslovodja">Odaberi šifru</button>
        </form>
        <p>
            <?php 
        if (!isset($_SESSION['id_poslovodja'])){
            echo "Unesite svoju šifru";
        } else {
            echo $_SESSION['id_poslovodja'];
        }
        ?></p>
    </section>
    <section>
        <a class='btn btn-info' href="psmjene/poslovodja_smjene.php">Smjene</a>
        <a class='btn btn-info' href="pnabava/poslovodja_skladiste.php">Skladište</a>
        <a class='btn btn-info' href="pcatering/poslovodja_catering.php">Catering</a>
        <a class='btn btn-info' href="pmeni/poslovodja_meniad.php">Meni</a>
        <a class='btn btn-info' href="panaliza/poslovodja_analiza.php">Analiza</a>
    </section>
</body>

</html>
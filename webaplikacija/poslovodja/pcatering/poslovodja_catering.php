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
        <a class='my-2 mx-2 btn btn-info' href='../pnabava/poslovodja_skladiste.php'>Skladište</a>
        <a class='my-2 mx-2 btn btn-info disabled' href='pcatering/poslovodja_catering.php'>Catering</a>
        <a class='my-2 mx-2 btn btn-info' href='../pmeni/poslovodja_meniad.php'>Meni</a>
        <a class='my-2 mx-2 btn btn-info' href='../panaliza/poslovodja_analiza.php'>Analiza</a>
        <h1>Catering</h1>
    </section>
    <?php
    echo"<h3 style='color:#FFF;'>Neodgovoreni zahtjevi za catering</h3>";
//caterinzi koje su gosti stavili zahtjeve
    include 'neispunjenicaterinzi.php';
//evidentiranjeuplatenacatering
    include 'p_cateringad.php';
    ?>
</body>

</html>
<?php 
   include_once '../poslovodja_konekcija.php';
?>
<!DOCTYPE html>
<html>

<head>
    </style>
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
        <a class='my-2 mx-2 btn btn-info' href='../pcatering/poslovodja_catering.php'>Catering</a>
        <a class='my-2 mx-2 btn btn-info' href='../pmeni/poslovodja_meniad.php'>Meni</a>
        <a class='my-2 mx-2 btn btn-info disabled' href='poslovodja_analiza.php'>Analiza</a>
        <h1>Analiza</h1>
    </section>
    <?php
    echo "<div class='my-5 container-fluid'>";
    include 'p_prometmjeseci.php';
    include 'p_rashodmjeseci.php';
    include 'p_racunprosjek.php';
    echo "</div><div class='my-5 container-fluid'>";
    include 'p_radnici.php';
    echo "</div><div class='my-5 container-fluid'>";
    include 'p_rezervacije.php';
    include 'p_najcescedostave.php';
    echo "</div>";
?>
</body>

</html>
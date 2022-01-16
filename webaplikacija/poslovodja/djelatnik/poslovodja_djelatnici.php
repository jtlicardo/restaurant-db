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
        include 'p_djelatnikad.php';
    ?>
    <h3>Dodaj djelatnika</h3>
    <form action="p_novidjelatnik.php" method="POST">
        <input type="text" name="ime" placeholder="ime"><br>
        <input type="text" name="prezime" placeholder="prezime"><br>
        <input type="text" name="mob" placeholder="mobitel"><br>
        <input type="text" name="email" placeholder="email"><br>
        <input type="text" name="oib" placeholder="oib"><br>
        <input type="date" name="datum" placeholder="datum rođenja"><br>
        <input type="text" name="zanimanje" placeholder="zanimanje"><br>
        <button class='my-2 btn btn-success' type="submit" name="sp_osoba">Predaj podatke</button>
    </form>
    <?php
    if (isset($_GET['pp'])) {
        echo "<p>".$_GET['pp']."</p>";
    }
    ?>
</body>


</html>
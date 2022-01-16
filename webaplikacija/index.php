<?php
//uspostavlja se nova sesija ukoliko prošla još traje
 session_start();
 session_destroy();
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

<body class='p-5 text-light bg-dark'>
    <h1>Restoran</h1>
    <p>...uđi kao...</p>
    <a class='my-2 btn btn-info' href="gost/gost_sucelje.php">gost</a>
    <a class='my-2 btn btn-info' href="konobar/konobar_sucelje.php">konobar</a>
    <a class='my-2 btn btn-info' href="poslovodja/poslovodja_sucelje.php">poslovođa</a>
</body>

</html>
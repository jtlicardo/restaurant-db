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
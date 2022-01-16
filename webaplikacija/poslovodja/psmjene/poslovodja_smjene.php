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
        echo "<h3 style='color:#FFF;'>Odaberite datum za postavljanje smjena</h3>
        <form action='p_dodajdatum.php' method='POST'>
            <input type='date' name='datumsmjena' placeholder='datum smjena'>
            <button class='my-2 btn btn-success'type='submit' name='sp_smjena''>Odaberi datum</button>
        </form>";
        if (!isset($_SESSION['s_datumsmjena'])) {
            echo "<p>Podaci nisu unešeni.</p>" ;
        } else {
//prikazuje datum za uređivanje, te loopa dolje prethodnih pet dana s prikazom smjena
            echo "<p>Datum za uređivanje: '$_SESSION[s_datumsmjena]'</p><div class='my-5' style='width:100%'></p>";
            include 'odabirsmjene.php';
            echo "<a class='my-2 btn btn-info' style='text-align: right;' href='izvrsiupissmjene.php'>Izvrsi upis smjene</a></div>";
            $dan = 5;
            while ($dan>=1) {
                include 'danotprije.php';
                $dan -=1;
            }
            echo "</section>";
        }?>
</body>

</html>
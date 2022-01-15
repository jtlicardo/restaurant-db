<?php 
    include_once '../gost_konekcija.php';
?>
<!DOCTYPE html>
<html>

<body>
    <?php 
        echo "<h3>Odaberite datum za postavljanje smjena</h3>
        <form action='p_dodajdatum.php' method='POST'>
            <input type='date' name='datumsmjena' placeholder='datum smjena'>
            <button type='submit' name='sp_smjena''>Odaberi datum</button>
        </form>";
        if (!isset($_SESSION['s_datumsmjena'])) {
            echo "<p>Podaci nisu unešeni.</p>" ;
        } else {
            echo "<p>Datum za uređivanje: '$_SESSION[s_datumsmjena]'</p><div style='display:block text-align:right;'>
            <br><a style='text-align: right;' href='izvrsiupissmjene.php'>Izvrsi upis smjene</a></div>;";
            include 'odabirsmjene.php';
            $dan = 5;
            while ($dan>=1) {
                include 'danotprije.php';
                $dan -=1;
            }
            echo "</section>";
        }?>
</body>

</html>
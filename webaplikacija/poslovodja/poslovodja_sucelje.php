<?php
    include_once 'gost_konekcija.php';
?>
<!DOCTYPE html>
<html>

<body>
    <section>
        <form action="poslovodja_info.php" method="POST">
            <input type="text" name="idposlovodja" placeholder="šifra ovlaštene osobe">
            <button type="submit" name="sp_poslovodja">Odaberi šifru</button>
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
        <a href="psmjene/poslovodja_smjene.php">Smjene</a>
        <a href="pnabava/poslovodja_skladiste.php">Skladište</a>
        <a href="pcatering/poslovodja_catering.php">Catering</a>
        <a href="pmeni/poslovodja_meniad.php">Meni</a>
        <a href="panaliza/poslovodja_analiza.php">Analiza</a>
    </section>
</body>

</html>
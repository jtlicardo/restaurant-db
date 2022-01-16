<?php
    echo " <section  style='width:360px; float:left;'><h3 style='color:#FFF;'>Djelatnici</h3>
     <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
    <table class='table table-dark table-striped'>
    <tbody>";
        $tablicajutro = "CREATE TABLE IF NOT EXISTS tablicajutro
        (
    id integer not null,
    ime varchar(50),
    prezime varchar(50),
    naziv varchar(50)
    );";
        $tablicavecer = "CREATE TABLE IF NOT EXISTS tablicavecer
    (
    id integer not null,
    ime varchar(50),
    prezime varchar(50),
    naziv varchar(50)
    );";
        mysqli_query($con, $tablicajutro);
        mysqli_query($con, $tablicavecer);
//prikazuje nam dostupne djelatnike
        $djelatnici = mysqli_query($con, "SELECT djelatnik.id,osoba.ime,osoba.prezime,zanimanje.naziv FROM djelatnik JOIN osoba ON djelatnik.id_osoba=osoba.id JOIN zanimanje ON zanimanje.id=djelatnik.id_zanimanje WHERE djelatnik.zaposlen='D';");
        while ($djelatnik = mysqli_fetch_assoc($djelatnici)) {
            echo "<tr>
                <td>".$djelatnik['ime']."<br>".$djelatnik['prezime']."</td>
                <td>".$djelatnik['naziv']."</td>";
//kuhinja poslovodja dvije smjene, ostali jednu - dvokratna u sali se stavlja pod vecer, dok se jutarnja od skladistara stavlja ujutro
            if ($djelatnik['naziv']=='poslovodja' || $djelatnik['naziv']=='kuhar' || $djelatnik['naziv']=='pomoćni kuhar' || $djelatnik['naziv']=='operater na suđu') {
                echo "<td><a class='my-2 btn btn-info' href='p_smjenadodaj.php?did=".$djelatnik['id']."&operacija=1'>dodaj ujutro</a><br>
                    <a class='my-2 btn btn-info' href='p_smjenadodaj.php?did=".$djelatnik['id']."&operacija=2'>dodaj večernjoj</a></td></tr>";
            } else {
                echo "<td><a class='my-2 btn btn-info' href='p_smjenadodaj.php?did=".$djelatnik['id']."&operacija=3'>dodaj u smjenu</a></td></tr>";
            }
        }
        echo "
        </tbody>
        </table>
        </section>
</section>";
        echo " <section  style='width:300px; display:inline-block;'>
            <h3 style='color:#FFF;'>Jutarnja smjena</h3>
             <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
            <table class='table table-dark table-striped'>
            <tbody>";
//prikazuje jutarnju smjenu koju odabiremo
        if (isset($_GET['update'])) {
            $smjutro = mysqli_query($con, "SELECT * FROM tablicajutro");
            while ($jutarnjiradnik = mysqli_fetch_assoc($smjutro)) {
                echo "<tr>
                    <td>".$jutarnjiradnik['ime']."</td>
                    <td>".$jutarnjiradnik['prezime']."</td>
                    <td>".$jutarnjiradnik['naziv']."</td>";
                    echo "<td><a class='my-2 btn btn-info' href='p_smjenaoduzmi.php?did=".$jutarnjiradnik['id']."&operacija=1'>makni</a></td></tr>";
            }
        }
        echo "
            </tbody>
            </table>
            </section>
            </section>
             <section  style='width:300px; display:inline-block;'>
            <h3 style='color:#FFF;'>Večernja smjena</h3>
             <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
            <table class='table table-dark table-striped'>
            <tbody>";
//prikazuje vecernju smjenu koju odabiremo
        if (isset($_GET['update'])) {
            $smvecer = mysqli_query($con, "SELECT * FROM tablicavecer");
            while ($vecernjiradnik = mysqli_fetch_assoc($smvecer)) {
                echo "<tr>
                        <td>".$vecernjiradnik['ime']."</td>
                        <td>".$vecernjiradnik['prezime']."</td>
                        <td>".$vecernjiradnik['naziv']."</td>";
                echo "<td><a class='my-2 btn btn-info' href='p_smjenaoduzmi.php?did=".$vecernjiradnik['id']."&operacija=2'>makni</a></td></tr>";
            }
        }
            echo "
            </tbody>
            </table>
            </section>
            </section>";
        
?>
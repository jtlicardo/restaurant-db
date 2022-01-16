<?php
        $cat = mysqli_query($con,"SELECT * FROM catering WHERE uplaceno='N';");
        echo " <section  style='width:50%; float:left;'>
        <h3 style='color:#FFF;'>Izmjena statusa zaposlenja djelatnika</h3>
         <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'><thead>
        <tr>
            <td>Osobni podaci</td>
            <td>Zanimanje</td>
            <td>Status</td>
        </tr>
        </thead>
        <tbody style=''>";
        $djelatnici = mysqli_query($con, "SELECT djelatnik.id,osoba.ime,osoba.prezime,zanimanje.naziv,djelatnik.zaposlen FROM djelatnik JOIN osoba ON djelatnik.id_osoba=osoba.id JOIN zanimanje ON zanimanje.id=djelatnik.id_zanimanje;");
        while ($djelatnik = mysqli_fetch_assoc($djelatnici)) {
            echo "<tr>
                <td>".$djelatnik['ime']."<br>".$djelatnik['prezime']."</td>
                <td>".$djelatnik['naziv']."</td>
                <td>".$djelatnik['zaposlen']."</td>
                <td><a class='my-2 btn btn-info' href='p_izmjenadjel.php?did=".$djelatnik['id']."&operacija=".$djelatnik['zaposlen']."'>Izmijeni status</a></td>
                </tr>";
            }
            echo "
            </tbody>
            </table></section></section>";?>
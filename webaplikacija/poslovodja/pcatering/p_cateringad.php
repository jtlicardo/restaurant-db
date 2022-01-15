<?php
        $cat = mysqli_query($con,"SELECT * FROM catering WHERE uplaceno='N';");
        echo "<section style='width:50%; float:left;'>
        <h3 style='color:#FFF;'>Neisplaćeni caterinzi</h3>
        <section style='overflow-y:scroll; height:240px;'>
        <table class='table table-dark table-striped'><thead>
        <tr>
            <td>Naručitelj</td>
            <td>Kontakt</td>
            <td>Opis</td>
            <td>Uplaćeno</td>
        </tr>
        </thead>
        <tbody style=''>";
            while ($redakcat = mysqli_fetch_assoc($cat)){
            $osoba = mysqli_fetch_assoc(mysqli_query($con,"SELECT * FROM osoba WHERE id IN (SELECT id_osoba FROM catering_zahtjev JOIN catering_narucitelj ON catering_zahtjev.id_narucitelj=catering_narucitelj.id WHERE catering_zahtjev.id='$redakcat[id_zahtjev]');"));
            $catz = mysqli_fetch_assoc(mysqli_query($con,"SELECT opis FROM catering_zahtjev WHERE catering_zahtjev.id='$redakcat[id_zahtjev]'"));
            echo "<tr>
                    <td>".$osoba['ime']."<br>".$osoba['prezime']."</td>
                    <td>".$osoba['broj_mob']."<br>".$osoba['email']."</td>
                    <td>".$catz['opis']."</td>
                    <td>".$redakcat['uplaceno']."</td>
                <td><a class='btn btn-info' href='p_uplacencat.php?did=".$redakcat['id']."'>potvrdi uplatu</a></td>
                </tr>";
            }
            echo "
            </tbody>
            </table></section></section>";?>
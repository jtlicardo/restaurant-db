<?php
    echo "<section style='overflow-y:scroll; height:160px;'>
    <table>
    <tbody>";
    $upit = mysqli_query($con,"SELECT catering_zahtjev.id,catering_zahtjev.id_narucitelj,adresa.drzava,adresa.grad,adresa.ulica,catering_zahtjev.opis FROM catering_zahtjev JOIN adresa ON adresa.id=catering_zahtjev.id_adresa WHERE catering_zahtjev.id not in (SELECT id_zahtjev FROM catering)");
    while ($catering = mysqli_fetch_assoc($upit)){
    $nadjipodatke=mysqli_fetch_assoc(mysqli_query($con,"SELECT osoba.ime, osoba.prezime,catering_narucitelj.oib FROM osoba JOIN catering_narucitelj ON catering_narucitelj.id_osoba=osoba.id WHERE catering_narucitelj.id='$catering[id_narucitelj]'"));
    echo "<tr>
            <td>".$nadjipodatke['ime']."</td>
            <td>".$nadjipodatke['prezime']."</td>
            <td>".$nadjipodatke['oib']."</td>
            <td>".$catering['drzava']."<br>".$catering['grad']."<br>".$catering['ulica']."</td>
            <td>".$catering['opis']."</td>
            <td><a href='p_zahtjevcatering.php?did=".$catering['id']."'>+</a></td></tr>";
    }
    echo "
    </tbody>
    </table>
    </section>"
?>
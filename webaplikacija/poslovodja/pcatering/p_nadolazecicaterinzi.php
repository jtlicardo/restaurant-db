<?php 
echo " <section  style='overflow-y:scroll; overflow-x:hidden;  height:160px;'>
<table class='table table-dark table-striped'>
<tbody>";
$upit = mysqli_query($con,"SELECT * FROM nadolazeci_caterinzi");
while ($catering = mysqli_fetch_assoc($upit)){
$nadjipodatke=mysqli_fetch_assoc(mysqli_query($con,"SELECT osoba.ime, osoba.prezime,catering_narucitelj.oib FROM osoba JOIN catering_narucitelj ON catering_narucitelj.id_osoba=osoba.id JOIN catering_zahtjev ON catering_zahtjev.id_narucitelj=catering_narucitelj.id WHERE catering_zahtjev.id='$catering[id_narucitelj]'"));
echo "<tr>
        <td>".$nadjipodatke['ime']."</td>
        <td>".$nadjipodatke['prezime']."</td>
        <td>".$nadjipodatke['oib']."</td>
        <td>".$catering['zeljeni_datum']."</td>
        <td>".$catering['broj_zaposlenika']."</td>
        <td>".$catering['uplaceno']."</td>
        <td><a class='my-2 btn btn-info' href='p_zahtjevcatering.php?did=".$catering['id']."'>+</a></td></tr>";
}
echo "
</tbody>
</table>
</section>"
?>
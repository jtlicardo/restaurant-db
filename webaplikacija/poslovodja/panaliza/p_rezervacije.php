<?php 
echo "
         <section  style='width:420px;display:inline-block;'>
        <h3 style='color:#FFF;'>Broj rezervacija po osobi</h3>
        <p>osobni podaci |kontakt info |djelatnik? |broj rezervacija</p>
         <section style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT * FROM najveci_br_rezervacija;");
            while ($red = mysqli_fetch_assoc($upit)) {
                echo "<tr>
                    <td>".$red['ime']."<br>".$red['prezime']."</td>
                    <td>".$red['broj_mob']."<br>".$red['email']."</td>
                    <td>".$red['osoba_je_djelatnik']."</td>
                    <td>".$red['broj_rezervacija']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
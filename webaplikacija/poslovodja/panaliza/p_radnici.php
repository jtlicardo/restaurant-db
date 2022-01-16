<?php 
echo "
         <section  style='width:500px;display:inline-block;'>
        <h3 style='color:#FFF;'>Sati radnika za prošli mjesec</h3>
        <p>osobni podaci |kontakt info|zanimanje |sati</p>
         <section style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT d.id, ime, prezime, email, z.naziv, COALESCE(SUM(HOUR(SUBTIME(kraj_radnog_vremena, pocetak_radnog_vremena))),
        0) AS broj_odradenih_sati
        FROM djelatnik d
        LEFT JOIN osoba o
        ON d.id_osoba = o.id
        LEFT JOIN zanimanje z
        ON d.id_zanimanje = z.id
        LEFT JOIN djelatnik_smjena ds
        ON ds.id_djelatnik = d.id
        LEFT JOIN smjena s
        ON ds.id_smjena = s.id
        WHERE (YEAR(ds.datum) = 2021 AND MONTH(ds.datum) = 12) OR (ds.datum) IS NULL
        GROUP BY (d.id);");
            while ($red = mysqli_fetch_assoc($upit)) {
                echo "<tr>
                    <td>".$red['ime']."<br>".$red['prezime']."</td>
                    <td>".$red['email']."</td>
                    <td>".$red['naziv']."</td>
                    <td>".$red['broj_odradenih_sati']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
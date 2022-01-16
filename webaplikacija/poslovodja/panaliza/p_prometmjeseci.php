<?php 
echo "
         <section  style='width:200px;display:inline-block;'>
        <h3 style='color:#FFF;'>Promet po mjesecu</h3>
        <p>mjesec |promet</p>
         <section style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT mjesec, SUM(ukupno) AS ukupna_zarada
        FROM (
            (SELECT CONCAT(MONTH(vrijeme_izdavanja), '/', YEAR(vrijeme_izdavanja)) AS mjesec, SUM(iznos_hrk) AS ukupno
                FROM racun
                GROUP BY mjesec)
            UNION ALL    
            (SELECT CONCAT(MONTH(datum), '/', YEAR(datum)) AS mjesec, SUM(cijena_hrk) AS ukupno
                FROM dostava
                GROUP BY mjesec)
            UNION ALL
            (SELECT CONCAT(MONTH(datum_izvrsenja), '/', YEAR(datum_izvrsenja)) AS mjesec, SUM(cijena_hrk) AS ukupno
                FROM catering
                GROUP BY mjesec)
        ) AS zarade
        GROUP BY mjesec
        ORDER BY STR_TO_DATE((CONCAT('01/', mjesec)),'%d/%m/%Y') DESC;");
            while ($red = mysqli_fetch_assoc($upit)) {
                echo "<tr>
                <td>".$red['mjesec']."</td>
                <td>".$red['ukupna_zarada']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
<?php 
echo "
         <section  style='width:200px;display:inline-block;'>
        <h3 style='color:#FFF;'>Rashod po mjesecu</h3>
        <p>|mjesec |rashod</p>
         <section style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT mjesec, ukup+SUM(placa_hrk) as Ukupni_rashodi
        FROM
        (SELECT mjesec, SUM(ukupno) as ukup
            FROM (
                (SELECT CONCAT(MONTH(datum), '/', YEAR(datum)) AS mjesec, SUM(iznos_hrk) AS ukupno
                    FROM rezije 
                    GROUP BY mjesec)
                UNION ALL    
                (SELECT CONCAT(MONTH(datum), '/', YEAR(datum)) AS mjesec, SUM(iznos_hrk) AS ukupno
                    FROM nabava
                    GROUP BY mjesec)
            ) AS zarade
            GROUP BY mjesec
            ORDER BY STR_TO_DATE((CONCAT('01/', mjesec)),'%d/%m/%Y') DESC) as temp
            JOIN djelatnik
            JOIN zanimanje
            ON zanimanje.id=djelatnik.id_zanimanje
            WHERE zaposlen='D'
            GROUP BY mjesec;
            ;");
            while ($red = mysqli_fetch_assoc($upit)) {
                echo "<tr>
                <td>".$red['mjesec']."</td>
                <td>".$red['Ukupni_rashodi']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
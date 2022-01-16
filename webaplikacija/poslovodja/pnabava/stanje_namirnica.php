<?php 
echo "
         <section  style='width:320px;float:left;'>
        <h3 style='color:#FFF;'>Stanje namirnica</h3>
        <p>naziv |kolicina |mjerna jedinica</p>
         <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $namirnice = mysqli_query($con,"SELECT * FROM namirnica;");
            while ($rednamirnice = mysqli_fetch_assoc($namirnice)) {
                echo "<tr>
                    <td>".$rednamirnice['naziv']."</td>
                    <td>".$rednamirnice['kolicina_na_zalihi']."</td>
                    <td>".$rednamirnice['mjerna_jedinica']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
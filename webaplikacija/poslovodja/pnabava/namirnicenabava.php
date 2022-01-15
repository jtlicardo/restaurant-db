<?php 
echo "
        <section style='width:320px;float:left;'>
        <h3 style='color:#FFF;'>Namirnice za nabavu</h3>
        <p>naziv |kolicina |promet prošle godine |omjer</p>
        <section style='overflow-y:scroll; height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $namirnice = mysqli_query($con,"SELECT * FROM namirnice_za_nabavu;");
            while ($rednamirnice = mysqli_fetch_assoc($namirnice)) {
                echo "<tr>
                    <td>".$rednamirnice['naziv']."</td>
                    <td>".$rednamirnice['kolicina_na_zalihi']."</td>
                    <td>".$rednamirnice['utroseno_zadnjih_god_dana']."</td>
                    <td>".$rednamirnice['omjer']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
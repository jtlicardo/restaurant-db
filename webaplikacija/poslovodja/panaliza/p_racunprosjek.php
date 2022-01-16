<?php 
echo "
         <section  style='width:200px;display:inline-block;'>
        <h3 style='color:#FFF;'>Prosječan iznos računa po mjesecu</h3>
        <p>mjesec |prosjecan iznos</p>
         <section  style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT * FROM prosjecan_iznos_racuna;");
            while ($red = mysqli_fetch_assoc($upit)) {
                echo "<tr>
                    <td>".$red['mjesec']."</td>
                    <td>".$red['prosjecan_iznos']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
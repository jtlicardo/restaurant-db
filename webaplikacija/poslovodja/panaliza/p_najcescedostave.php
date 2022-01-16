<?php 
echo "
         <section  style='width:420px;display:inline-block;'>
        <h3 style='color:#FFF;'>Najčešće adrese dostave</h3>
        <p>drzava |grad |ulica dostave | post_broj</p>
         <section style='overflow-y:scroll; overflow-x:hidden;  height:240px;'>
        <table class='table table-dark table-striped'>
        <tbody>";
        $upit = mysqli_query($con,"SELECT * FROM najcesce_adrese_dostave;");
            while ($red = mysqli_fetch_assoc($upit)) {
                echo "<tr>
                    <td>".$red['drzava']."</td>
                    <td>".$red['grad']."</td>
                    <td>".$red['ulica']."</td>
                    <td>".$red['post_broj']."</td>
                    </tr>";
            }
            echo "
            </tbody>
            </table>
            </section></section>";
?>
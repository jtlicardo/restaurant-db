 <section class='m-1' style='width:200px; display:inline-block;'>
     <?php
        //prikazuje datum ispod kojeg se povlače smjene koje su bile
        $razlika = mysqli_query($con,"SELECT subdate('$_SESSION[s_datumsmjena]', $dan) AS pdan;");
        $odan=mysqli_fetch_assoc($razlika);
        echo "<h2>Dan: '$odan[pdan]'</h2>";
        $vrijeme="09:30";
        echo "<h3 style='color:#FFF;'>Jutarnja smjena</h3>";
        include 'smjenaotprije.php';
        $vrijeme="18:00";
        echo "<h3 style='color:#FFF;'>Večernja smjena</h3>";
        include 'smjenaotprije.php'; 
    ?>
 </section>
<section style='width:200px; display:inline-block;'>
    <?php
        $razlika = mysqli_query($con,"SELECT subdate('$_SESSION[s_datumsmjena]', $dan) AS pdan;");
        $odan=mysqli_fetch_assoc($razlika);
        echo "<h2>Dan: '$odan[pdan]'</h2>";
        $vrijeme="09:30";
        echo "<h3>Jutarnja smjena</h3>";
        include 'smjenaotprije.php';
        $vrijeme="18:00";
        echo "<h3>Večernja smjena</h3>";
        include 'smjenaotprije.php'; 
    ?>
</section>
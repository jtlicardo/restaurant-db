<?php
session_start();
$server="127.0.0.1";
$korisnik="gost";
$password="password";
$baza="restoran";

$con = mysqli_connect($server,$korisnik,$password,$baza);
if (mysqli_connect_errno())
{
	echo "Neuspješno spajanje na bazu podataka:" . mysqli_connect_error();
}
?>
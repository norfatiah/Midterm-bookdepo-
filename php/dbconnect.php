<?php
$servername = "localhost";
$username = "seriousl_adminbettafish";
$password = "gkvs3vnc4072";
$dbname = "seriousl_bettafish";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
 die("Connection failed: " . $conn->connect_error);
}
?>
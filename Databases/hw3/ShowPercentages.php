

 
 
 <?php
// PHP code just started

ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$mysqli = new mysqli("dbase.cs.jhu.edu","20fa_rzhang58","n5WZHHkof5","20fa_rzhang58_db");
/* check connection */
if (mysqli_connect_errno()) {
printf("Connect failed: %s<br>", mysqli_connect_error());
exit();
}

$ssn = $_POST['SSN']; // You can set this with the one passed from web-interface
if ($mysqli->multi_query("CALL ShowPercentages('".$ssn."');")) {
if ($result = $mysqli->store_result()) {
	echo "<table border=1>\n";
	echo "<tr><th>ssn</th><th>LName</th><th>FName</th><th>Section</th><th>HW1</th><th>HW2a</th><th>HW2b</th><th>Midterm</th><th>HW3</th><th>FinalExam</th></tr>\n";

while ($row = $result->fetch_row()) {

printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", 
	$row[0],$row[1], $row[2], $row[3],$row[4],$row[5],$row[6],$row[7],$row[8],$row[9]);
}
$result->close();
}
if ($mysqli->next_result()){
	if ($result = $mysqli->store_result()) {
while ($row = $result->fetch_row()) {

printf($row[0]);
}
$result->close();
}
}
}
else {
printf("<br>Error: %s\n", $mysqli->error);
}

// PHP code about to end

?>
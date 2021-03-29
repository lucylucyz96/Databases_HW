

 
 
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

$pwd = $_POST['Password']; // You can set this with the one passed from web-interface
if ($mysqli->multi_query("CALL Stats('".$pwd."');")) {
do {
if ($result = $mysqli->store_result()) {
	$num_rows = mysqli_num_rows($result);
	if($num_rows >1){

	
	echo "<table border=1>\n";
	echo "<tr><th>SSN</th><th>LName</th><th>FName</th><th>Section</th><th>HW1</th><th>HW2a</th><th>HW2b</th><th>Midterm</th><th>HW3</th><th>FinalExam</th><th>CumAvg</th></tr>\n";

while ($row = $result->fetch_row()) {

printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", 
	$row[0],$row[1], $row[2], $row[3],$row[4],$row[5],$row[6],$row[7],$row[8],$row[9],$row[10]);
}
}

else{
	$nums_cols = mysqli_num_fields($result);
	if($nums_cols==1){
		$row = $result->fetch_row();
		printf($row[0]);
	}
	else{
		echo "<table border=1>\n";
		echo "<tr><th>Statistic</th><th>HW1</th><th>HW2a</th><th>HW2b</th><th>Midterm</th><th>HW3</th><th>FExam</th><th>CumAvg</th></tr>\n";

		while ($row = $result->fetch_row()) {

			printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", 
			$row[0],$row[1], $row[2], $row[3],$row[4],$row[5],$row[6],$row[7]);
		}
	}

}
$result->close();
}
if ($mysqli->more_results()) {
printf("\n");
}
else{
	
	break;
}
} while ($mysqli->next_result());

}
else {
printf("<br>Error: %s\n", $mysqli->error);
}

// PHP code about to end

?>

<head>
  <title>List One Student</title>
 </head>
 <body>

 
 
 <?php
// PHP code just started

ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$db = mysqli_connect("dbase.cs.jhu.edu", "20fa_rzhang58", "n5WZHHkof5");
// ********* Remember to use your MySQL username and password here ********* //

if (!$db) {

  echo "Connection failed!";

} else {

  $ID = $_POST['ID'];
  // This says that the $ID variable should be assigned a value obtained as an
  // input to the PHP code. In this case, the input is called 'ID'.

  mysqli_select_db("20fa_rzhang58_db",$db);
  // ********* Remember to use the name of your database here ********* //

  $result = mysqli_query("SELECT * FROM Student WHERE StuID = $ID",$db);
  // a simple query on the Student table

  if (!$result) {

    echo "Query failed!\n";
    print mysqli_error();

  } else {

    echo "<table border=1>\n";
    echo "<tr><td>StuID</td><td>LName</td><td>FName</td></tr>\n";

    while ($myrow = mysqli_fetch_array($result)) {
      printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["StuID"], $myrow["LName"], $myrow["Fname"]);
    }

    echo "</table>\n";

  }

}

// PHP code about to end

 ?>

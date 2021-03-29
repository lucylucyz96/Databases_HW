<head>
  <title>List All Students</title>
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

  mysql_select_db($db，"20fa_rzhang58_db");
  // ********* Remember to use the name of your database here ********* //

  $result = mysql_query($db，"SELECT * FROM Student");
  // a simple query on the Student table

  if (!$result) {

    echo "Query failed!\n";
    print mysql_error($db);

  } else {

    echo "<table border=1>\n";
    echo "<tr><td>StuID</td><td>LName</td><td>FName</td></tr>\n";

    while ($myrow = mysql_fetch_array($result)) {
      printf("<tr><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["StuID"], $myrow["LName"], $myrow["Fname"]);
    }

    echo "</table>\n";

  }

}

// PHP code about to end

 ?>



 </body>
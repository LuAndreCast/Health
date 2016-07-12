<html>
	<head></head>
	<body>
		<form action="sendAccess.php" method="GET">
		  Client ID:<br>
		  <input type="text" name="clientID"><br>
		  Fitbit:<br>
		  <input type="radio" name="choice" value="fitbit"><br>
		  jawbone:<br>
		  <input type="radio" name="choice" value="jawbone"><br>

		  <input type="submit" value="submit">
		</form>
	</body>
</html>

<?php

// function saveToFile($url, $filename)
// {
// 	if (  strlen($filename) == 0)
// 	{
// 		$filename = "fileOutput.txt";
// 	}
// 	$fp = fopen($filename, "w"); 	//open file

// 	$ch = curl_init($url);
// 	curl_setopt($ch, CURLOPT_FILE, $fp);
// 	curl_setopt($ch, CURLOPT_HEADER, 0);
// 	$output = curl_exec($ch);
// 	curl_close($ch);

// 	fclose($fp); 					//close file
// }//eom


// function displayToScreen($url)
// {
// 	echo "\n".$url."\n";

// 	$ch = curl_init();
// 	curl_setopt($ch, CURLOPT_URL, $url);
// 	curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

// 	$output = curl_exec($ch);
// 	echo $output;

// 	curl_close($ch);
// }//eom


?>
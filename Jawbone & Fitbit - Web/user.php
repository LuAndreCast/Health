<?php
	session_start();

	function sendBackToHome($errorMessage)
	{
		$_SESSION['error'] = $errorMessage;
		header( "Location: http://localhost:8888/fitbitjawbone" );
	}//eom

	function getStepData($authorization, $url)
	{
		$curl = curl_init();

		curl_setopt_array($curl, array(
		  CURLOPT_URL => $url,
		  CURLOPT_RETURNTRANSFER => true,
		  CURLOPT_ENCODING => "",
		  CURLOPT_MAXREDIRS => 10,
		  CURLOPT_TIMEOUT => 30,
		  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
		  CURLOPT_CUSTOMREQUEST => "GET",
		  CURLOPT_HTTPHEADER => array(
		    "authorization: Bearer ".$authorization,
		    "cache-control: no-cache"
		  ),
		));

		$response = curl_exec($curl);
		$err = curl_error($curl);

		curl_close($curl);

		if ($err) 
		{
		  return "cURL Error #:" . $err;
		} 
		else 
		{
			$json = json_decode($response, true);
			return $json;
		}

	}//eom


	/* getting access tokens */
	$api		 	= "";
	$accessToken 	= "";
	$refreshToken 	= "";
	$tokenExpires 	= "";
	$tempFile = fopen("database.txt", "r");
	if ( isset($tempFile) ) 
	{
		$api = fgets($tempFile);
		$api = str_replace("\n", "", $api);

		$accessToken = fgets($tempFile);
		$accessToken = str_replace("\n", "", $accessToken);

		$refreshToken = fgets($tempFile);
		$refreshToken = str_replace("\n", "", $refreshToken);

		$tokenExpires = fgets($tempFile);
		$tokenExpires = str_replace("\n", "", $tokenExpires);

		fclose($myfile);
	} 
	else 
	{
		sendBackToHome("missing data");
	}


	/* getting user data */
	$url_step = "";
	$authorization = "";
	$dataFound = true;

	include 'credentials.php';
	switch ($api) 
	{
		case "fitbit":
			$url_step = $fitbit_url_steps;
			$authorization = $accessToken;
			break;
		case "jawbone":
			$url_step = $jawbone_url_steps;
			$authorization = $accessToken;
			break;
		default:
			$dataFound = false;
			break;
	}



	//steps
	$steps = getStepData($authorization, $url_step);
	switch ($api) 
	{
		case "fitbit":
			$steps = $steps['activities-steps'];
			break;
		case "jawbone":
			break;
		default:
			break;
	}

	$hasSteps = false;
	if (count($steps) > 0 ) 
	{
		$hasSteps = true;
	}


?>

<html>
	<head>
		<title>Health App</title>

		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">

		<!-- jQuery library -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>

		<!-- Latest compiled JavaScript -->
		<script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
	</head>
	<body>
	
		<?php
			include 'header.php';
		?>


		<!-- steps -->
<?php
	if ( $hasSteps ) 
	{
	
?>
	<div class="container">
		<h2>Step Data</h2>
		<table class="table table-hover">
		<thead>
		<tr>
			<th>Date</th>
			<th>Steps</th>
		</tr>
		</thead>
		<tbody>	
<?php
	for ($i=0; $i < count($steps) ; $i++) 
	{ 
		$date = "";
		$value = "";
		$currStep = $steps[$i];
		

		switch ($api) {
			case "fitbit":
				$date = $currStep["dateTime"];
				$value = $currStep["value"];
				break;
			case "jawbone":
				$date = $currStep["dateTime"];
				$value = $currStep["value"];
				break;
			default:
				$date = $currStep["dateTime"];
				$value = $currStep["value"];
				break;
		}
		print "<tr>";
			print "<td>";
			print $date;
			print "</td>";
			print "<td>";
			print $value;
			print "</td>";
		print "</tr>";
	}//eofl
?>
		</tbody>
		</table>
	</div>
<?php
	}
	else
	{
		print "No Step Data";
	}
	




?>
	</body>
</html>



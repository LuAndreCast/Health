<?php

session_start();
include 'credentials.php';


if( isset($_GET['code']) && isset($_SESSION['api']) )
{
	$code = $_GET['code'];
	$apiSelection = $_SESSION['api'];

	//getting access & refresh token
	switch ($apiSelection) {
		case "fitbit":
			$url = $fitbit_url_token;

			$credentials = $fitbit_clientID.":".$fitbit_secret;

			$postFields = "grant_type=".$fitbit_grantType_accessToken;
			$postFields = $postFields."&redirect_uri=".$fitbit_redirect_uri; 
			$postFields = $postFields."&code=".$code;
			$postFields = $postFields."&client_id=".$fitbit_clientID;

			getAccessToken($apiSelection, $url, $credentials, $postFields);
		break;
		case "jawbone":
			$url = $jawbone_url_token;

			$credentials = $jawbone_clientID.":".$jawbone_secret;

			$postFields = "grant_type=".$jawbone_grantType_accessToken;
			$postFields = $postFields."&code=".$code;
			$postFields = $postFields."&client_id=".$jawbone_clientID;
			$postFields = $postFields."&client_secret=".$jawbone_secret; 

			getAccessToken($apiSelection, $url, $credentials, $postFields);
		break;
		default:
		echo "empty!!!";
		break;
	}
}
else
{
	//redirect to home page and show error
	$_SESSION['error'] = "Error authenticating account";
	header( "Location: http://localhost:8888/fitbitjawbone" );
}



function getAccessToken($apiSelection, $url, $credentials, $postFields)
{
	//clearing params
	unset($_GET);
	unset($_POST);

	$curl = curl_init();

	curl_setopt_array($curl, array(
	  CURLOPT_URL => $url,
	  CURLOPT_RETURNTRANSFER => true,
	  CURLOPT_ENCODING => "",
	  CURLOPT_MAXREDIRS => 10,
	  CURLOPT_TIMEOUT => 30,
	  CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
	  CURLOPT_CUSTOMREQUEST => "POST",
	  CURLOPT_POSTFIELDS => $postFields,
	  CURLOPT_HTTPHEADER => array(
	    "authorization: Basic ".base64_encode($credentials),
	    "cache-control: no-cache",
	    "content-type: application/x-www-form-urlencoded"
	  ),
	));

	$response = curl_exec($curl);
	$err = curl_error($curl);

	curl_close($curl);



	if ($err) 
	{
	 	echo "cURL Error #:" . $err;
	} 
	else 
	{

		  $json = json_decode( $response, true);

	  switch ($apiSelection) 
	  {
	  	case "fitbit":
		  $accessToken 	= $json["access_token"];
		  $refreshToken = $json["refresh_token"];
		  $tokenExpires = $json["expires_in"];
		  $api = "fitbit";

		  /* saving data in sessions */
		  	//writing to file - TEMP solution, this should be read from a DB! 
			$tempFile = fopen("database.txt", "w");
			fwrite($tempFile,$api."\n");
			fwrite($tempFile,$accessToken."\n");
			fwrite($tempFile,$refreshToken."\n");
			fwrite($tempFile,$tokenExpires."\n");
			fclose($tempFile);

			//redirecting to users page
			// echo '<script type="text/javascript"> 
			// 	window.location = "http://localhost:8888/fitbitjawbone/user.php/"  
			// 	</script>';

			header( "Location: http://localhost:8888/fitbitjawbone/user.php/" );
	  		break;

	  	case "jawbone":
		  $accessToken 	= $json["access_token"];
		  $refreshToken = $json["refresh_token"];
		  $tokenExpires = $json["expires_in"];
		  $api = "jawbone";

		  /* saving data in sessions */
		  	//writing to file - TEMP solution, this should be read from a DB! 
			$tempFile = fopen("database.txt", "w");
			fwrite($tempFile,$api."\n");
			fwrite($tempFile,$accessToken."\n");
			fwrite($tempFile,$refreshToken."\n");
			fwrite($tempFile,$tokenExpires."\n");
			fclose($tempFile);

			//redirecting to users page
			//echo '<script type="text/javascript"> window.location = "http://localhost:8888/fitbitjawbone/user.php/"  </script>';
			header( "Location: http://localhost:8888/fitbitjawbone/user.php/" );

	  		break;
	  	default:
	  		break;
	  }

	}

}//eom


?>
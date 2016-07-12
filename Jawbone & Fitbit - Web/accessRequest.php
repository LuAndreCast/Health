<?php 
	session_start();

	$selectOption = $_GET['choice'];
	if( strcmp($selectOption, "fitbit")  == 0)
	{
		sendAccessTokenRequest(0);
		$_SESSION['api'] = "fitbit";
	}
	else if ( strcmp($selectOption, "jawbone") == 0 )
	{
		sendAccessTokenRequest(1);
		$_SESSION['api'] = "jawbone";
	}
	else
	{
		header( "Location: http://localhost:8888/fitbitjawbone" );
	}




/*
	0 - fitbit
	1 - jawbone
*/
function sendAccessTokenRequest($option)
{

	include 'credentials.php';

	//updating params based on selection
	$url 			= "";
	$scope 			= "";
	$clientID		= "";
	$redirect_uri 	= "";
	
	if ($option == 0)
	{
		$clientID 		= $fitbit_clientID;
		$url 			= $fitbit_url_code;
		$scope 			= $fitbit_scope;
		$redirect_uri 	= $fitbit_redirect_uri;
	}
	else if ($option == 1)
	{
		$clientID 		= $jawbone_clientID;
		$url 			= $jawbone_url_code;
		$scope 			= $jawbone_scope;
		$redirect_uri	= $jawbone_redirect_uri;
	}

	//sending request
	$params = array(
					'response_type' => "code",
					'client_id' => $clientID,
					'redirect_uri' => $redirect_uri,
					'scope' => $scope );

	$request_to = $url."?".http_build_query($params);

	header("Location: ".$request_to);
}//eom



?>
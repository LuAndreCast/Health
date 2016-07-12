<?php

$selectOption = $_GET['choice'];
if( strcmp($selectOption, "fitbit")  == 0)
{
	$clientIDProvided = $_GET['clientID'];
	sendAccessTokenRequest($clientIDProvided, 0);
}
else if ( strcmp($selectOption, "jawbone") == 0 )
{
	$clientIDProvided = $_GET['clientID'];
	sendAccessTokenRequest($clientIDProvided, 1);
}
else
{
	header( "Location: http://localhost:8888/WebDevel/" );
}


/*
	0 - fitbit
	1 - jawbone
*/
function sendAccessTokenRequest($clientID, $option)
{
	$fitbitUrl = "https://www.fitbit.com/oauth2/authorize";
	$fitbitScope = "activity heartrate location nutrition profile settings sleep social weight";

	//
	$jawboneUrl = "https://jawbone.com/auth/oauth2/auth";
	$jawboneScope = "extended_read";


	$url = "";
	$scope = "";
	if ($option == 0)
	{
		$url = $fitbitUrl;
		$scope = $fitbitScope;
	}
	else if ($option == 1)
	{
		$url = $jawboneUrl;
		$scope = $jawboneScope;
	}

	$params = array(
					'response_type' => "code",
					'client_id' => $clientID,
					'redirect_uri' => "http://localhost:8888/receiveToken.php",
					'scope' => $scope );

	$request_to = $url."?".http_build_query($params);

	header("Location: ".$request_to);
}//eom


?>
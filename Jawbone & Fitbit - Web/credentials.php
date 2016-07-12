<?php
	
	/* fitbit */
	$fitbit_clientID 		= "227GVB";
	$fitbit_url_code 		= "https://www.fitbit.com/oauth2/authorize";
	$fitbit_scope 			= "activity heartrate location nutrition profile settings sleep social weight";
	$fitbit_secret			= "b78d35114cbc16c1e460e554459adb59";
	$fitbit_redirect_uri	= "http://localhost:8888/fitbitjawbone/accessResponse.php";
	$fitbit_grantType_accessToken = "authorization_code";
	$fitbit_grantType_refreshToken = "refresh_token";

	$fitbit_url_token = "https://api.fitbit.com/oauth2/token";
	$fitbit_url_steps = "https://api.fitbit.com/1/user/-/activities/steps/date/today/1y.json";



	/* jawbone */
	$jawbone_clientID 		= "wag3oFwerL0";
	$jawbone_url_code		= "https://jawbone.com/auth/oauth2/auth";
	$jawbone_scope 			= "extended_read";
	$jawbone_secret 		= "260f5a2851c255a93ce33391495f580e089bfbac";
	$jawbone_redirect_uri	= "http://localhost:8888/fitbitjawbone/accessResponse.php";
	$jawbone_grantType_accessToken = "authorization_code";
	$jawbone_grantType_refreshToken = "refresh_token";

	$jawbone_url_token = "https://jawbone.com/auth/oauth2/token";
	$jawbone_url_steps = "https://jawbone.com/nudge/api/v.1.1/users/@me/moves";
	
?>
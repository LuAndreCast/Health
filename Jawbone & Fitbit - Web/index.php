<?php
	session_start();
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

		<form class="form-horizontal" role="form" action="accessRequest.php" method="GET">
		    <div class="form-group">
		      <div class="col-sm-offset-2 col-sm-10">
		        <div class="radio">
		          <label><input type="radio" name="choice" value="fitbit"> Fitbit</label>
		        </div>
		      </div>
		      <div class="col-sm-offset-2 col-sm-10">
		        <div class="radio">
		          <label><input type="radio" name="choice" value="jawbone"> Jawbone</label>
		        </div>
		      </div>
		    </div>
		    <div class="form-group">
		      <div class="col-sm-offset-2 col-sm-10">
		        <button type="submit" class="btn btn-default">Activate</button>
		      </div>
		    </div>
		  </form>
	</body>

</html>

<?php
		//showing errors - if any
		$errors = $_SESSION['error'];
		echo "<p>$errors</p>";

		//clearing previous selection
		session_destroy();
?>

<nav class="navbar navbar-inverse navbar-fixed-top">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" href="#">Health</a>
    </div>
    <ul class="nav navbar-nav">
      <?php

        $pageName = $_SERVER['PHP_SELF'];

        if ($pageName === "/fitbitjawbone/index.php") 
        {
          ?>
            <li class="active">
              <a href="http://localhost:8888/fitbitjawbone/">Home</a>
            </li>
            <li>
              <a href="http://localhost:8888/fitbitjawbone/user.php">User</a>
            </li>
          <?php
        } 
        else 
        {
         ?>
            <li>
              <a href="http://localhost:8888/fitbitjawbone/">Home</a>
            </li>
            <li class="active">
              <a href="http://localhost:8888/fitbitjawbone/user.php">User</a>
            </li>
          <?php
        }
      ?>

    </ul>
  </div>
</nav>

<br>
<br>
<br>



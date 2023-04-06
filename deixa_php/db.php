<?php
include "config.php";

function checkAccess($a_user, $a_pass)
{
  $result = (isset($_SERVER['PHP_AUTH_USER']) &&
            $_SERVER['PHP_AUTH_USER'] == $a_user &&
            $_SERVER['PHP_AUTH_PW'] == $a_pass);

  if (!$result)
  {
    header('WWW-Authenticate: Basic realm="Restricted area"');
    header('HTTP/1.0 401 Unauthorized');

    return false;
  }
  else
    return true;
}


if(checkAccess($auth_user, $auth_pass)){

    $db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);
    $db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} 
else {
    header("HTTP/1.0 404 Not Found");
}

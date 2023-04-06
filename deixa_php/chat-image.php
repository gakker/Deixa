<?php
header('Content-Type: application/json');
include "db.php";
include "config.php";

$doc = $_FILES['image']['name'];

$path = "chats/";
$output_file_path = $path . $doc;
$tmp_name = $_FILES['image']['tmp_name'];


if(!file_exists($path)){
    mkdir($path);
}

move_uploaded_file($tmp_name, $output_file_path);
    
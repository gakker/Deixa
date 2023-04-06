<?php
header('Content-Type: application/json');
include "db.php";

$email = $_POST['email'];

$stmt = $db->prepare("SELECT typeOfLogin FROM users WHERE email = ?");
$stmt->execute([$email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if ($user>0) {


    echo json_encode(
        [
        'status' =>'success',
        'message'=> $user['typeOfLogin']
    ]);

} else {

    echo json_encode(
        [
        'status' =>'failed',
        'message'=>'new account'
    ]);
}







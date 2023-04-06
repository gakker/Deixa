<?php
header('Content-Type: application/json');

include "config.php";
include "db.php";

$email = $_POST['email'];


$stmt = $db->prepare("SELECT verified , blocked FROM users WHERE email = ? ");
$stmt->execute([$email]);
$res = $stmt->fetch(PDO::FETCH_ASSOC);


if($res > 0){


    if($res['verified'] > 0) {

        if($res['blocked'] == 0) {
            $session_end =strtotime("+$session_end days");
    
            $stmt3= $db->prepare("UPDATE `users` SET `session_end` = ? WHERE `email` = ?");
            $stmt3->execute([$session_end, $email]);

            echo json_encode([
                'status' => "success",
                'message' => "Password correct"
            ]); 
        
    }  else {

        echo json_encode([
            'status' => "failed",
            'message' => "You account is blocked"
        ]);
    }
    
    }
    else {

        echo json_encode([
            'status' => "failed",
            'message' => "Please verify your mail"
        ]);
    }



} else {

    echo json_encode([
        'status' => "failed",
        'message' => "User does not exist"
    ]);
}


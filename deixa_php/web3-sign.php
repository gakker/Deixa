<?php

header('Content-Type: application/json');
include "db.php";
include "config.php";
include "admin-store-user-country-stats.php";
include "store-financials.php";



$uid = $_POST['uid'];
$email = $_POST['email'];
$password = $_POST['password'];
$firstName = $_POST['firstName'];
$lastName = $_POST['lastName'];
$phone = $_POST['phone'];
$country = $_POST['country'];
$refCode = $_POST['refCode'];
$profilePic = $_POST['profilePic'];
$typeOfLogin = $_POST['typeOfLogin'];



$stmt = $db->prepare( " SELECT * FROM users WHERE email = ? ");
$stmt->execute([$email]);
$res = $stmt->fetchAll(PDO::FETCH_ASSOC);

if($res){

    echo json_encode([
        "status" => "failed",
        'message' => "user exist"
    ]);

} else {

        $hash = password_hash($password , PASSWORD_DEFAULT);

            
        $stmt2 = $db->prepare("INSERT INTO `users` (`s_n`, `uid`, `firstName`, `lastName`, 
        `email`, `password`, `phone`, `country`, `dateCreated`, `blocked`, `disabled`, 
        `disable_end`, `isAdmin`, `profilePic`, `refCode`, `referredBy`, `refBalance`,
        `verified`, `identified`, `session_end`, `refConfirmCount`, `refUnconfirmCount`, `typeOfLogin`) 
        VALUES (?, ?, ?, ?, ?,?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?, ?, ?)");

         $stmt2->execute([NULL, $uid , $firstName ,$lastName , $email , $hash , 
            $phone , $country ,$time_now , 0 , 0 , NULL , 0 , $profilePic , $refCode , 
            'torus' , 0 ,1 , 0 , 0, 0, 0, $typeOfLogin]);



        // OTP
        $stmt4 = $db->prepare("INSERT INTO `otps` (`s_n`, `uid`, `email`, `email_login`, `email_trxn`, `phone`, `phone_login`, `phone_trxn`, `google`, `google_login`, `google_trxn`)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        $stmt4->execute([NULL, $uid , NULL, 0, 0, NULL, 0, 0, NULL, 0, 0]);
        
        // Financials
        addFinancialsFxn($db, $uid);

        // Admin Country
        adminUserCountryUpdateFxn($db, $country);

        // Admin User Stats
       
        echo json_encode([
            "status" => "success",
            'message' => 'Registered',
        ]);
       
      
}
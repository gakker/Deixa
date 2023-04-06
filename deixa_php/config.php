<?php
        
// DB


// Database Settings
$db_name = "u227717343_deixa";
$db_server = "localhost";
$db_user = "u227717343_deixa";
$db_pass = "dessoq-duhxus-3woCmy";

// Auth

// Your Authentication config, should be same with endpoint_username and password in .env_sample in dart folder
$auth_user = 'ij7hfdueHf';
$auth_pass = 'shu&b3yHgwd';

$admin_uid = "admin";


// Google Cloud Message
// get from project settings in firebase console
$server_key = "";


// Coinbase Url
$request_url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=bitcoin%2Cethereum&order=market_cap_desc&per_page=100&page=1&sparkline=false';



// Company
$company_name = 'Deixa';


// End with  a /
// your web url and support url
$web_url = 'https://deixa.ezeematrix.com/';
$support_url = 'https://deixa.ezeematrix.com/';


//Email   
// Server Email Configuration
$smtp_host = "smtp.hostinger.com";
$mail_username = "deixa@ezeematrix.com";                 
$mail_password = "dufrux-kizpo1-piJzyf";                           
$mail_port =  465; //use value without quotes                                   
$mail_from = "deixa@ezeematrix.com";


// Encryption Decryption

$ciphering = "BF-CBC";
  
// Use OpenSSl encryption method
$iv_length = openssl_cipher_iv_length($ciphering);
$options = 0;
  
// Use random_bytes() function which gives
// randomly 16 digit values
$encryption_iv = random_bytes($iv_length);
  
// characters or numeric for iv
$encryption_key = openssl_digest(php_uname(), 'MD5', TRUE);


//Misc

$time_now=strtotime(date("Y-m-d h:i:sa"));


// Your configuration here

$email_expire_time = 7; //in days

$pass_reset_expire_time = 1; //in hour

$referral_bonus = 10; //in percent

$failed_login_attempts_count = 5;

$login_attempts_reset_time = 1 ; //in hour

$disable_end_time = 14; //in days

$session_end = 14; // in days


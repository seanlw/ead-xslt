<?php
require_once('ArchivesSpace.php');

$query = array();
$paths = array();


if (isset($_GET['q'])) {
  $paths = explode('/', $_GET['q']);
}

if (count($paths) % 2 == 0) {
  foreach($paths as $key => $value){
    if ($key % 2 != 0) {
      $query[$paths[$key - 1]] = $value;
    }
  }
}

if (!file_exists('config.ini')) {
  die('Please setup the config.ini');
}
$config = parse_ini_file('config.ini');

$as = new ArchivesSpace(array(
  'username' => $config['username'],
  'password' => $config['password'],
  'endpoint' => $config['api_endpoint'],
  'sessionFile' => $config['tmp_file']
));

if (!$query){
  include('homepage.php');
}
else {
  include('ead.php');
}

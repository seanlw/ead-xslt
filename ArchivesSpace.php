<?php

class ArchivesSpace {

  /**
   * The Authorization session array returned when accessing a session request.
   *
   * @var array
   */
  public $session = array();

  /**
   * The ArchivesSpace configuration
   *
   * @var array
   */
  public $config = array(
    'sessionFile' => '/tmp/ArchivesSpaceSession'
  );

  /**
   * Constructor
   *
   * @param array $config Array of configuration information for Sierra
   */
  public function __construct($config) {
    $this->config = array_merge($this->config, $config);
  }

  /**
   * Gets the EAD from Archives Space
   *
   * @param int $repo The repository ID
   * @param int $resource The resource ID
   * @return string
   */
  public function getEad($repo, $resource) {
    if (!$this->_checkSession()) return null;

    $headers = array('X-ArchivesSpace-Session: ' . $this->session['token']);
    $response = $this->_request($this->config['endpoint'] . '/repositories/' . $repo . '/resource_descriptions/' . $resource . '.xml', array(), $headers);
    if ($response['status'] != 200) return null;

    return $response['body'];
  }

  /**
   * Gets a list of resources for a repository
   *
   * @param int $repo The repository ID
   * @param int $page The page to be returned
   * @return array
   */
  public function getResources($repo, $page = 1) {
    if (!$this->_checkSession()) return null;

    $headers = array('X-ArchivesSpace-Session: ' . $this->session['token']);
    $response = $this->_request($this->config['endpoint'] . '/repositories/' . $repo . '/resources', array(
      'page' => $page,
      'page_size' => 100
    ), $headers);
    if ($response['status'] != 200 ) return null;

    return json_decode($response['body'], true);
  }

  /**
   * Checks if Authentication session exists or has expired. A new Authentication session will 
   * be created if one does not exist.
   *
   * @return boolean True if token is valid
   */ 
  private function _checkSession() {
    if (file_exists($this->config['sessionFile'])) {
      $this->session = json_decode(file_get_contents($this->config['sessionFile']), true);
    }

    if (!$this->session || (time() >= $this->session['expires_at'])) {
      return $this->_sessionToken();
    }

    return true;
  }

  /**
   * Requests a Session from ArchivesSpace
   *
   * @return boolean True if a session token is created
   */
  private function _sessionToken() {
    $response = $this->_request($this->config['endpoint'] . '/users/' . $this->config['username'] . '/login', array(
      'password' => $this->config['password']
    ), array(), 'post');
    if ( $response['status'] != 200 ) { return false; }
    $data = json_decode($response['body'], true);
    if (!$data) { return false; }

    $this->session = array(
      'expires_at' => time() + 3600,
      'token' => $data['session']
    );
    file_put_contents($this->config['sessionFile'], json_encode($this->session));
    return true;
  }

  /**
   * Requests data from Sierra
   *
   * @param string $url The full URL to the REST API call
   * @param array $params The query paramaters to pass to the call
   * @param array $header Additional header information to include
   * @param string $type The request type 'GET' or 'POST'
   * @return array Result array
   * 
   * ### Result keys returned
   * - 'status': The return status from the server
   * - 'header': The header information fo the server
   * - 'body': The body of the message
   */
  private function _request($url, $params = array(), $header = array(), $type = 'get') {
    $type = strtolower($type);

    $s = curl_init();
    
    if ($type == 'post') {
      $header[] = 'Content-Type: application/x-www-form-urlencoded';
      curl_setopt($s, CURLOPT_POST, true);
      curl_setopt($s, CURLOPT_POSTFIELDS, http_build_query($params));
    }
    else {
      $url .= ($params ? '?' . http_build_query($params) : '');
    }
    
    curl_setopt($s, CURLOPT_URL, $url);
    curl_setopt($s, CURLOPT_TIMEOUT, 60);
    curl_setopt($s, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($s, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($s, CURLOPT_USERAGENT, 'Sierra PHP Test/0.1');
    curl_setopt($s, CURLOPT_HEADER, true);

    if ($header) {
      curl_setopt($s, CURLOPT_HTTPHEADER, $header);
    }

    $result = curl_exec($s);
    $status = curl_getinfo($s, CURLINFO_HTTP_CODE);
    $headerSize = curl_getinfo($s, CURLINFO_HEADER_SIZE);
    $header = $this->_parseResponseHeaders(substr($result, 0, $headerSize));
    $body = substr($result, $headerSize);

    $response = array(
      'status' => $status,
      'header' => $header,
      'body' => $body
    );  
    curl_close($s);

    return $response;
  }

  /**
   * Parse response headers into a array
   *
   * @param string $header The header information as a string
   * @return array
   */
  private function _parseResponseHeaders($header) {
    $headers = array();
    $h = explode("\r\n", $header);
    foreach ($h as $header) {
      if (strpos($header, ':') !== false) {
        list($type, $value) = explode(":", $header, 2);
        if (isset($headers[$type])) {
          if (is_array($headers[$type])) {
            $headers[$type][] = trim($value);
          }
          else {
            $headers[$type] = array($headers[$type], trim($value));
          }
        }
        else {
          $headers[$type] = trim($value);
        }
      }
    }
    return $headers;
  }

}
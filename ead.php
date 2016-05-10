<?php

$ead = $as->getEad((int)$config['repo_id'], $query['resources']);
if (!$ead) { die('Failed to get EAD'); }

header('Content-Type: application/xml');

$xml_stylesheet = '<?xml version="1.0" encoding="utf-8"?>' . "\n"
                . '<?xml-stylesheet type="text/xsl" href="templates/findingaid.xsl"?>';


print str_replace('<?xml version="1.0" encoding="utf-8"?>', $xml_stylesheet, $ead);
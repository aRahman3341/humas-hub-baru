<?php
// Copy to config.php and fill in the Hostinger MySQL credentials.
return [
    'db_host' => 'localhost',
    'db_name' => 'YOUR_DATABASE_NAME',
    'db_user' => 'YOUR_DATABASE_USER',
    'db_pass' => 'YOUR_DATABASE_PASSWORD',
    // Generate with: php -r "echo base64_encode(random_bytes(32)), PHP_EOL;"
    // Keep this secret and do not change it after users have been created.
    'encryption_key' => 'REPLACE_WITH_BASE64_ENCODED_32_BYTE_KEY',
    'upload_dir' => __DIR__ . '/uploads',
    'max_upload_bytes' => 104857600, // 100 MiB per file; tune to Hostinger limits.
    'timezone' => 'Asia/Jakarta',
];

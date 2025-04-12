<?php
/**
 * WordPress Base Configuration adapted for Docker.
 *
 * This config file uses environment variables for all sensitive and variable data.
 * It supports both direct env variables and *_FILE secrets (Docker Swarm / Kubernetes).
 */

if (!function_exists('getenv_docker')) {
	function getenv_docker($env, $default) {
		if ($fileEnv = getenv($env . '_FILE')) {
			return rtrim(file_get_contents($fileEnv), "\r\n");
		}
		$val = getenv($env);
		return ($val !== false) ? $val : $default;
	}
}

// 🔐 Database configuration
define( 'DB_NAME',     getenv_docker('WORDPRESS_DB_NAME', 'wordpress') );
define( 'DB_USER',     getenv_docker('WORDPRESS_DB_USER', 'wp_user') );
define( 'DB_PASSWORD', getenv_docker('WORDPRESS_DB_PASSWORD', 'wp_pass') );
define( 'DB_HOST',     getenv_docker('WORDPRESS_DB_HOST', 'localhost') );
define( 'DB_CHARSET',  getenv_docker('WORDPRESS_DB_CHARSET', 'utf8') );
define( 'DB_COLLATE',  getenv_docker('WORDPRESS_DB_COLLATE', '') );

// 🔐 Authentication unique keys and salts (use secrets!)
define( 'AUTH_KEY',         getenv_docker('WORDPRESS_AUTH_KEY',         'change-me') );
define( 'SECURE_AUTH_KEY',  getenv_docker('WORDPRESS_SECURE_AUTH_KEY',  'change-me') );
define( 'LOGGED_IN_KEY',    getenv_docker('WORDPRESS_LOGGED_IN_KEY',    'change-me') );
define( 'NONCE_KEY',        getenv_docker('WORDPRESS_NONCE_KEY',        'change-me') );
define( 'AUTH_SALT',        getenv_docker('WORDPRESS_AUTH_SALT',        'change-me') );
define( 'SECURE_AUTH_SALT', getenv_docker('WORDPRESS_SECURE_AUTH_SALT', 'change-me') );
define( 'LOGGED_IN_SALT',   getenv_docker('WORDPRESS_LOGGED_IN_SALT',   'change-me') );
define( 'NONCE_SALT',       getenv_docker('WORDPRESS_NONCE_SALT',       'change-me') );

// 🔧 Table prefix
$table_prefix = getenv_docker('WORDPRESS_TABLE_PREFIX', 'wp_');

// ⚙️ Debugging
define( 'WP_DEBUG', filter_var(getenv_docker('WORDPRESS_DEBUG', false), FILTER_VALIDATE_BOOLEAN) );

// 🛡️ Behind reverse proxy (Traefik, Nginx, etc.)
if (isset($_SERVER['HTTP_X_FORWARDED_PROTO']) && strpos($_SERVER['HTTP_X_FORWARDED_PROTO'], 'https') !== false) {
	$_SERVER['HTTPS'] = 'on';
}

// 📦 Extra config injected at runtime (ex: WP_DEBUG_LOG, WP_MEMORY_LIMIT, etc.)
if ($configExtra = getenv_docker('WORDPRESS_CONFIG_EXTRA', '')) {
	eval($configExtra);
}

// 🚀 Set ABSPATH and load
if (!defined('ABSPATH')) {
	define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';

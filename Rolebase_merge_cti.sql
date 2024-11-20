-- Enhanced GDPR-Compliant and RBAC-Enabled MySQL Script with Zero Trust Principles

-- 0. SETUP ENVIRONMENT
-- Ensure strict SQL mode for data integrity
SET sql_mode = 'STRICT_ALL_TABLES';

-- Use UTF8MB4 for full Unicode support
CREATE DATABASE IF NOT EXISTS `rbac_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS `cyber_threat_intel2` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `rbac_system`;

-- 1. ROLE-BASED ACCESS CONTROL (RBAC) SYSTEM

-- Users table
CREATE TABLE IF NOT EXISTS `users` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `password` CHAR(60) NOT NULL, -- bcrypt hash length
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `consent_to_data_usage` BIT NOT NULL,
  `email_encrypted` VARBINARY(255) NOT NULL,
  `enabled` BIT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB;

-- Roles table
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(50) NOT NULL UNIQUE,
  `description` VARCHAR(255),
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB;

-- Permissions table
CREATE TABLE IF NOT EXISTS `permissions` (
  `permission_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `permission_name` VARCHAR(100) NOT NULL UNIQUE,
  `description` VARCHAR(255),
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB;

-- User_Roles junction table
CREATE TABLE IF NOT EXISTS `user_roles` (
  `user_id` BIGINT NOT NULL,
  `role_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Role_Permissions junction table
CREATE TABLE IF NOT EXISTS `role_permissions` (
  `role_id` INT UNSIGNED NOT NULL,
  `permission_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`, `permission_id`),
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`role_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`permission_id`) REFERENCES `permissions`(`permission_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Indexes for performance optimization
CREATE INDEX `idx_user_username` ON `users` (`username`);
CREATE INDEX `idx_user_email_encrypted` ON `users` (`email_encrypted`);
CREATE INDEX `idx_role_name` ON `roles` (`role_name`);
CREATE INDEX `idx_permission_name` ON `permissions` (`permission_name`);

-- Stored procedures for RBAC management

-- Add a new user
DELIMITER //
CREATE PROCEDURE `add_user`(
    IN p_username VARCHAR(50),
    IN p_password_hash CHAR(60),
    IN p_email_encrypted VARBINARY(255),
    IN p_consent_to_data_usage BIT,
    IN p_enabled BIT
)
BEGIN
    INSERT INTO `users` (`username`, `password`, `email_encrypted`, `consent_to_data_usage`, `enabled`)
    VALUES (p_username, p_password_hash, p_email_encrypted, p_consent_to_data_usage, p_enabled);
END;
//
DELIMITER ;

-- Assign role to user
DELIMITER //
CREATE PROCEDURE `assign_role_to_user`(
    IN p_user_id BIGINT,
    IN p_role_id INT UNSIGNED
)
BEGIN
    INSERT IGNORE INTO `user_roles` (`user_id`, `role_id`)
    VALUES (p_user_id, p_role_id);
END;
//
DELIMITER ;

-- Grant permission to role
DELIMITER //
CREATE PROCEDURE `grant_permission_to_role`(
    IN p_role_id INT UNSIGNED,
    IN p_permission_id INT UNSIGNED
)
BEGIN
    INSERT IGNORE INTO `role_permissions` (`role_id`, `permission_id`)
    VALUES (p_role_id, p_permission_id);
END;
//
DELIMITER ;

-- Revoke permission from role
DELIMITER //
CREATE PROCEDURE `revoke_permission_from_role`(
    IN p_role_id INT UNSIGNED,
    IN p_permission_id INT UNSIGNED
)
BEGIN
    DELETE FROM `role_permissions`
    WHERE `role_id` = p_role_id AND `permission_id` = p_permission_id;
END;
//
DELIMITER ;

-- 2. AUDITING AND GDPR COMPLIANCE

USE `cyber_threat_intel2`;

-- Create a comprehensive audit log table
CREATE TABLE IF NOT EXISTS `audit_log` (
    `log_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `event_time` DATETIME DEFAULT CURRENT_TIMESTAMP,
    `user_host` VARCHAR(255),
    `query_text` TEXT,
    `action` ENUM('CREATE', 'READ', 'UPDATE', 'DELETE') NOT NULL,
    `object_type` VARCHAR(50),
    `object_name` VARCHAR(255)
) ENGINE=InnoDB;

-- Stored procedures for logging
DELIMITER //
CREATE PROCEDURE `log_action`(
    IN p_user_host VARCHAR(255),
    IN p_query_text TEXT,
    IN p_action ENUM('CREATE', 'READ', 'UPDATE', 'DELETE'),
    IN p_object_type VARCHAR(50),
    IN p_object_name VARCHAR(255)
)
BEGIN
    INSERT INTO `audit_log` (`user_host`, `query_text`, `action`, `object_type`, `object_name`)
    VALUES (p_user_host, p_query_text, p_action, p_object_type, p_object_name);
END;
//
DELIMITER ;

-- Example Trigger for logging INSERT on users
DELIMITER //
CREATE TRIGGER `users_after_insert`
AFTER INSERT ON `users`
FOR EACH ROW
BEGIN
    CALL `log_action`(CURRENT_USER(), CONCAT('INSERT INTO users VALUES (', NEW.id, ', ', QUOTE(NEW.username), ', ... )'), 'CREATE', 'TABLE', 'users');
END;
//
DELIMITER ;

-- Additional triggers for UPDATE and DELETE can be created similarly

-- Encryption Key Management (Assumed to be handled externally)
-- Example usage in stored procedures should reference secure key storage mechanisms

-- 3. ZERO TRUST IMPLEMENTATIONS

-- Enforce least privilege by restricting direct table access
-- All access should be mediated through stored procedures

-- Revoke direct privileges
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'app_user'@'localhost';
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'admin_user'@'localhost';

-- Grant execute privileges on stored procedures
GRANT EXECUTE ON PROCEDURE `rbac_system`.`add_user` TO 'app_user'@'localhost';
GRANT EXECUTE ON PROCEDURE `rbac_system`.`assign_role_to_user` TO 'app_user'@'localhost';
GRANT EXECUTE ON PROCEDURE `rbac_system`.`grant_permission_to_role` TO 'app_user'@'localhost';
GRANT EXECUTE ON PROCEDURE `rbac_system`.`revoke_permission_from_role` TO 'app_user'@'localhost';

-- Grant necessary read privileges via views
CREATE VIEW `view_user_roles` AS
SELECT
    u.`id`,
    u.`username`,
    r.`role_name`
FROM
    `rbac_system`.`users` u
JOIN
    `rbac_system`.`user_roles` ur ON u.`id` = ur.`user_id`
JOIN
    `rbac_system`.`roles` r ON ur.`role_id` = r.`role_id`;
    
CREATE VIEW `view_role_permissions` AS
SELECT
    r.`role_name`,
    p.`permission_name`
FROM
    `rbac_system`.`roles` r
JOIN
    `rbac_system`.`role_permissions` rp ON r.`role_id` = rp.`role_id`
JOIN
    `rbac_system`.`permissions` p ON rp.`permission_id` = p.`permission_id`;

GRANT SELECT ON `rbac_system`.`view_user_roles` TO 'app_user'@'localhost';
GRANT SELECT ON `rbac_system`.`view_role_permissions` TO 'app_user'@'localhost';

-- 4. DATA RETENTION AND DELETION POLICIES

-- Data retention policies using events
CREATE EVENT IF NOT EXISTS `delete_old_users`
ON SCHEDULE EVERY 1 DAY
DO
    DELETE FROM `rbac_system`.`users`
    WHERE `created_at` < NOW() - INTERVAL 2 YEAR;

-- Similar events can be created for other tables as needed

-- 5. AUDIT LOG EXPORTING

-- Secure export of audit logs via secure stored procedures
DELIMITER //
CREATE PROCEDURE `export_audit_logs`(
    IN p_file_path VARCHAR(255)
)
BEGIN
    -- Ensure the MySQL server has the FILE privilege and access to the directory
    SET @export_query = CONCAT(
        "SELECT * FROM `audit_log` INTO OUTFILE '", p_file_path,
        "' FIELDS TERMINATED BY ',' ENCLOSED BY '\"' LINES TERMINATED BY '\n'"
    );
    PREPARE stmt FROM @export_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END;
//
DELIMITER ;

GRANT EXECUTE ON PROCEDURE `cyber_threat_intel2`.`export_audit_logs` TO 'admin_user'@'localhost';

-- 6. SECURITY ENHANCEMENTS

-- Create application and admin users with least privileges
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'SecureP@ssw0rd!';
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'AdminSecureP@ssw0rd!';

-- Grant minimal required privileges
GRANT EXECUTE ON `rbac_system`.* TO 'app_user'@'localhost';
GRANT EXECUTE ON `cyber_threat_intel2`.* TO 'app_user'@'localhost';

GRANT ALL PRIVILEGES ON `rbac_system`.* TO 'admin_user'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON `cyber_threat_intel2`.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Flush privileges to apply changes
FLUSH PRIVILEGES;

-- 7. INTEGRATING NEW TABLES FOR AUDIT AND DATA SCIENCE

USE `cyber_threat_intel2`;

-- Affected Products table
CREATE TABLE IF NOT EXISTS `affected_products` (
    `product_id` INT AUTO_INCREMENT PRIMARY KEY,
    `product_name` VARCHAR(255) NOT NULL UNIQUE,
    `vendor` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Attack Vector Categories table
CREATE TABLE IF NOT EXISTS `attack_vector_categories` (
    `vector_category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(100) NOT NULL UNIQUE,
    `description` TINYTEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Attack Vectors table
CREATE TABLE IF NOT EXISTS `attack_vectors` (
    `vector_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255),
    `vector_category_id` INT NOT NULL,
    `severity_level` INT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `category` VARCHAR(255),
    FOREIGN KEY (`vector_category_id`) REFERENCES `attack_vector_categories`(`vector_category_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX `idx_vector_category_id` ON `attack_vectors` (`vector_category_id`);

-- Countries table
CREATE TABLE IF NOT EXISTS `countries` (
    `country_code` CHAR(2) NOT NULL PRIMARY KEY,
    `country_name` VARCHAR(100) NOT NULL UNIQUE,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Geolocations table
CREATE TABLE IF NOT EXISTS `geolocations` (
    `geolocation_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `ip_address` VARCHAR(45) NOT NULL UNIQUE, -- Supports IPv6
    `country` CHAR(2) NOT NULL,
    `region` VARCHAR(100),
    `city` VARCHAR(100),
    `latitude` DECIMAL(9,6),
    `longitude` DECIMAL(9,6),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (`country`) REFERENCES `countries`(`country_code`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE INDEX `idx_city` ON `geolocations` (`city`);
CREATE INDEX `idx_country` ON `geolocations` (`country`);
CREATE INDEX `idx_country_city` ON `geolocations` (`country`, `city`);
CREATE INDEX `idx_region` ON `geolocations` (`region`);

-- Global Threats table
CREATE TABLE IF NOT EXISTS `global_threats` (
    `threat_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255),
    `first_detected` DATE NOT NULL,
    `last_updated` DATE,
    `severity_level` INT DEFAULT 0 NOT NULL,
    `data_retention_until` DATETIME NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE INDEX `idx_name` ON `global_threats` (`name`);
CREATE INDEX `idx_severity_level` ON `global_threats` (`severity_level`);

-- Incident Logs Audit table
CREATE TABLE IF NOT EXISTS `incident_logs_audit` (
    `audit_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `action_type` ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    `incident_id` BIGINT,
    `actor_id` INT,
    `vector_id` INT,
    `vulnerability_id` INT,
    `geolocation_id` BIGINT,
    `incident_date` DATETIME,
    `target` VARCHAR(255),
    `industry_id` INT,
    `impact` VARCHAR(255),
    `response` VARCHAR(255),
    `response_date` DATETIME,
    `data_retention_until` DATETIME,
    `action_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `performed_by` VARCHAR(100) DEFAULT 'system'
) ENGINE=InnoDB;

-- Industries table
CREATE TABLE IF NOT EXISTS `industries` (
    `industry_id` INT AUTO_INCREMENT PRIMARY KEY,
    `industry_name` VARCHAR(100) NOT NULL UNIQUE,
    `description` TINYTEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Most Exploited Vulnerabilities table
CREATE TABLE IF NOT EXISTS `most_exploited_vulnerabilities_mat` (
    `cve_id` VARCHAR(20) NOT NULL UNIQUE,
    `description` TINYTEXT NOT NULL,
    `exploitation_count` BIGINT DEFAULT 0 NOT NULL,
    PRIMARY KEY (`cve_id`)
) ENGINE=InnoDB;

-- Privileges table
CREATE TABLE IF NOT EXISTS `privileges` (
    `id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255)
) ENGINE=InnoDB;

-- Statistical Reports table
CREATE TABLE IF NOT EXISTS `statistical_reports` (
    `report_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `content` VARCHAR(255),
    `generated_date` DATE NOT NULL,
    `report_type` VARCHAR(255) NOT NULL,
    `data_retention_until` DATETIME NOT NULL
) ENGINE=InnoDB;

-- Threat Actor Types table
CREATE TABLE IF NOT EXISTS `threat_actor_types` (
    `type_id` INT AUTO_INCREMENT PRIMARY KEY,
    `type_name` VARCHAR(100) NOT NULL UNIQUE,
    `description` TINYTEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Threat Actors Audit table
CREATE TABLE IF NOT EXISTS `threat_actors_audit` (
    `audit_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `action_type` ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    `actor_id` INT,
    `name` VARCHAR(255),
    `type_id` INT,
    `description` VARCHAR(255),
    `origin_country` CHAR(2),
    `first_observed` DATE,
    `last_activity` DATE,
    `category_id` INT,
    `action_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `performed_by` VARCHAR(100) DEFAULT 'system'
) ENGINE=InnoDB;

-- Threat Categories table
CREATE TABLE IF NOT EXISTS `threat_categories` (
    `category_id` INT AUTO_INCREMENT PRIMARY KEY,
    `category_name` VARCHAR(255) NOT NULL UNIQUE,
    `description` VARCHAR(255),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Threat Actors table
CREATE TABLE IF NOT EXISTS `threat_actors` (
    `actor_id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL UNIQUE,
    `type_id` INT NOT NULL,
    `description` VARCHAR(255),
    `origin_country` CHAR(2) NOT NULL,
    `first_observed` DATE NOT NULL,
    `last_activity` DATE,
    `category_id` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `type` VARCHAR(255) NOT NULL,
    FOREIGN KEY (`category_id`) REFERENCES `threat_categories`(`category_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`origin_country`) REFERENCES `countries`(`country_code`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`type_id`) REFERENCES `threat_actor_types`(`type_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Threat Actor Attack Vector Association table
CREATE TABLE IF NOT EXISTS `threat_actor_attack_vector` (
    `threat_actor_id` INT NOT NULL,
    `attack_vector_id` INT NOT NULL,
    PRIMARY KEY (`threat_actor_id`, `attack_vector_id`),
    FOREIGN KEY (`threat_actor_id`) REFERENCES `threat_actors`(`actor_id`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`attack_vector_id`) REFERENCES `attack_vectors`(`vector_id`)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_category_id` ON `threat_actors` (`category_id`);
CREATE INDEX `idx_origin_country` ON `threat_actors` (`origin_country`);
CREATE INDEX `idx_type_id` ON `threat_actors` (`type_id`);

-- Triggers for auditing threat_actors
DELIMITER //
CREATE TRIGGER `threat_actors_after_delete`
AFTER DELETE ON `threat_actors`
FOR EACH ROW
BEGIN
    INSERT INTO `threat_actors_audit` (
        `action_type`, `actor_id`, `name`, `type_id`, `description`, `origin_country`,
        `first_observed`, `last_activity`, `category_id`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'DELETE', OLD.`actor_id`, OLD.`name`, OLD.`type_id`, OLD.`description`, OLD.`origin_country`,
        OLD.`first_observed`, OLD.`last_activity`, OLD.`category_id`, NOW(), 'system'
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `threat_actors_after_insert`
AFTER INSERT ON `threat_actors`
FOR EACH ROW
BEGIN
    INSERT INTO `threat_actors_audit` (
        `action_type`, `actor_id`, `name`, `type_id`, `description`, `origin_country`,
        `first_observed`, `last_activity`, `category_id`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'INSERT', NEW.`actor_id`, NEW.`name`, NEW.`type_id`, NEW.`description`, NEW.`origin_country`,
        NEW.`first_observed`, NEW.`last_activity`, NEW.`category_id`, NOW(), 'system'
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `threat_actors_after_update`
AFTER UPDATE ON `threat_actors`
FOR EACH ROW
BEGIN
    INSERT INTO `threat_actors_audit` (
        `action_type`, `actor_id`, `name`, `type_id`, `description`, `origin_country`,
        `first_observed`, `last_activity`, `category_id`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'UPDATE', OLD.`actor_id`, OLD.`name`, OLD.`type_id`, OLD.`description`, OLD.`origin_country`,
        OLD.`first_observed`, OLD.`last_activity`, OLD.`category_id`, NOW(), 'system'
    );
END;
//
DELIMITER ;

-- Threat Predictions table
CREATE TABLE IF NOT EXISTS `threat_predictions` (
    `prediction_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `prediction_date` DATE NOT NULL,
    `threat_id` INT NOT NULL,
    `probability` DOUBLE NOT NULL CHECK (`probability` BETWEEN 0 AND 1),
    `predicted_impact` VARCHAR(255),
    `data_retention_until` DATETIME NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`threat_id`) REFERENCES `global_threats`(`threat_id`)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_prediction_date` ON `threat_predictions` (`prediction_date`);
CREATE INDEX `idx_threat_id` ON `threat_predictions` (`threat_id`);
CREATE INDEX `idx_threat_prediction_date` ON `threat_predictions` (`threat_id`, `prediction_date`);

-- Incident Logs table
CREATE TABLE IF NOT EXISTS `incident_logs` (
    `incident_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `actor_id` INT NOT NULL,
    `vector_id` INT NOT NULL,
    `vulnerability_id` INT,
    `geolocation_id` BIGINT NOT NULL,
    `incident_date` DATETIME NOT NULL,
    `target` VARCHAR(255) NOT NULL,
    `industry_id` INT NOT NULL,
    `impact` VARCHAR(255),
    `response` VARCHAR(255),
    `response_date` DATETIME,
    `data_retention_until` DATETIME NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `industry` VARCHAR(255),
    `response_time_hours` INT AS (TIMESTAMPDIFF(HOUR, `incident_date`, `response_date`)),
    FOREIGN KEY (`geolocation_id`) REFERENCES `geolocations`(`geolocation_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`actor_id`) REFERENCES `threat_actors`(`actor_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`industry_id`) REFERENCES `industries`(`industry_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`vector_id`) REFERENCES `attack_vectors`(`vector_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities`(`vulnerability_id`)
        ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE INDEX `idx_actor_id` ON `incident_logs` (`actor_id`);
CREATE INDEX `idx_actor_incident_industry` ON `incident_logs` (`actor_id`, `incident_date`, `industry_id`);
CREATE INDEX `idx_geolocation_id` ON `incident_logs` (`geolocation_id`);
CREATE INDEX `idx_incident_date` ON `incident_logs` (`incident_date`);
CREATE INDEX `idx_industry_id` ON `incident_logs` (`industry_id`);
CREATE INDEX `idx_target` ON `incident_logs` (`target`);
CREATE INDEX `idx_target_prefix` ON `incident_logs` (`target`(20));
CREATE INDEX `idx_vector_id` ON `incident_logs` (`vector_id`);
CREATE INDEX `idx_vulnerability_id` ON `incident_logs` (`vulnerability_id`);

-- Incident Logs Audit table (Already created above)

-- Triggers for auditing incident_logs
DELIMITER //
CREATE TRIGGER `incident_logs_after_delete`
AFTER DELETE ON `incident_logs`
FOR EACH ROW
BEGIN
    INSERT INTO `incident_logs_audit` (
        `action_type`, `incident_id`, `actor_id`, `vector_id`, `vulnerability_id`, `geolocation_id`,
        `incident_date`, `target`, `industry_id`, `impact`, `response`, `response_date`,
        `data_retention_until`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'DELETE', OLD.`incident_id`, OLD.`actor_id`, OLD.`vector_id`, OLD.`vulnerability_id`, OLD.`geolocation_id`,
        OLD.`incident_date`, OLD.`target`, OLD.`industry_id`, OLD.`impact`, OLD.`response`, OLD.`response_date`,
        OLD.`data_retention_until`, NOW(), 'system'
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `incident_logs_after_insert`
AFTER INSERT ON `incident_logs`
FOR EACH ROW
BEGIN
    INSERT INTO `incident_logs_audit` (
        `action_type`, `incident_id`, `actor_id`, `vector_id`, `vulnerability_id`, `geolocation_id`,
        `incident_date`, `target`, `industry_id`, `impact`, `response`, `response_date`,
        `data_retention_until`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'INSERT', NEW.`incident_id`, NEW.`actor_id`, NEW.`vector_id`, NEW.`vulnerability_id`, NEW.`geolocation_id`,
        NEW.`incident_date`, NEW.`target`, NEW.`industry_id`, NEW.`impact`, NEW.`response`, NEW.`response_date`,
        NEW.`data_retention_until`, NOW(), 'system'
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `incident_logs_after_update`
AFTER UPDATE ON `incident_logs`
FOR EACH ROW
BEGIN
    INSERT INTO `incident_logs_audit` (
        `action_type`, `incident_id`, `actor_id`, `vector_id`, `vulnerability_id`, `geolocation_id`,
        `incident_date`, `target`, `industry_id`, `impact`, `response`, `response_date`,
        `data_retention_until`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'UPDATE', OLD.`incident_id`, OLD.`actor_id`, OLD.`vector_id`, OLD.`vulnerability_id`, OLD.`geolocation_id`,
        OLD.`incident_date`, OLD.`target`, OLD.`industry_id`, OLD.`impact`, OLD.`response`, OLD.`response_date`,
        OLD.`data_retention_until`, NOW(), 'system'
    );
END;
//
DELIMITER ;

-- Vulnerabilities Audit table
CREATE TABLE IF NOT EXISTS `vulnerabilities_audit` (
    `audit_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `action_type` ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    `vulnerability_id` INT,
    `cve_id` VARCHAR(20),
    `description` TINYTEXT,
    `published_date` DATE,
    `severity_score` DECIMAL(4,1),
    `action_timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `performed_by` VARCHAR(100) DEFAULT 'system'
) ENGINE=InnoDB;

-- Triggers for auditing vulnerabilities
DELIMITER //
CREATE TRIGGER `vulnerabilities_after_delete`
AFTER DELETE ON `vulnerabilities`
FOR EACH ROW
BEGIN
    INSERT INTO `vulnerabilities_audit` (
        `action_type`, `vulnerability_id`, `cve_id`, `description`, `published_date`,
        `severity_score`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'DELETE', OLD.`vulnerability_id`, OLD.`cve_id`, OLD.`description`, OLD.`published_date`,
        OLD.`severity_score`, NOW(), 'system'
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `vulnerabilities_after_insert`
AFTER INSERT ON `vulnerabilities`
FOR EACH ROW
BEGIN
    INSERT INTO `vulnerabilities_audit` (
        `action_type`, `vulnerability_id`, `cve_id`, `description`, `published_date`,
        `severity_score`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'INSERT', NEW.`vulnerability_id`, NEW.`cve_id`, NEW.`description`, NEW.`published_date`,
        NEW.`severity_score`, NOW(), 'system'
    );
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER `vulnerabilities_after_update`
AFTER UPDATE ON `vulnerabilities`
FOR EACH ROW
BEGIN
    INSERT INTO `vulnerabilities_audit` (
        `action_type`, `vulnerability_id`, `cve_id`, `description`, `published_date`,
        `severity_score`, `action_timestamp`, `performed_by`
    )
    VALUES (
        'UPDATE', OLD.`vulnerability_id`, OLD.`cve_id`, OLD.`description`, OLD.`published_date`,
        OLD.`severity_score`, NOW(), 'system'
    );
END;
//
DELIMITER ;

-- Vulnerabilities table
CREATE TABLE IF NOT EXISTS `vulnerabilities` (
    `vulnerability_id` INT AUTO_INCREMENT PRIMARY KEY,
    `cve_id` VARCHAR(20) NOT NULL UNIQUE,
    `description` TINYTEXT NOT NULL,
    `published_date` DATE NOT NULL,
    `severity_score` DECIMAL(4,1) NOT NULL CHECK (`severity_score` BETWEEN 0.0 AND 10.0),
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Vulnerability-Product Association table
CREATE TABLE IF NOT EXISTS `vulnerability_product_association` (
    `vulnerability_id` INT NOT NULL,
    `product_id` INT NOT NULL,
    PRIMARY KEY (`vulnerability_id`, `product_id`),
    FOREIGN KEY (`vulnerability_id`) REFERENCES `vulnerabilities`(`vulnerability_id`)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (`product_id`) REFERENCES `affected_products`(`product_id`)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_product_id` ON `vulnerability_product_association` (`product_id`);

-- Machine Learning Features table
CREATE TABLE IF NOT EXISTS `machine_learning_features` (
    `feature_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `incident_id` BIGINT NOT NULL,
    `feature_vector` JSON,
    `feature_name` VARCHAR(255) NOT NULL,
    `feature_value` DOUBLE NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`incident_id`) REFERENCES `incident_logs`(`incident_id`)
        ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX `idx_incident_id` ON `machine_learning_features` (`incident_id`);

-- Time Series Analytics table
CREATE TABLE IF NOT EXISTS `time_series_analytics` (
    `time_series_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `analysis_date` DATE NOT NULL,
    `metric` VARCHAR(255) NOT NULL,
    `value` DOUBLE NOT NULL,
    `incident_id` BIGINT NOT NULL,
    FOREIGN KEY (`incident_id`) REFERENCES `incident_logs`(`incident_id`)
        ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- Statistical Reports stored procedure
DELIMITER //
CREATE PROCEDURE `update_statistical_reports`()
BEGIN
    DECLARE report_content TEXT;
    SET report_content = CONCAT(
        'Total Incidents Today: ',
        (SELECT COUNT(*) FROM `incident_logs` WHERE DATE(`incident_date`) = CURDATE()),
        ', Date: ', CURDATE()
    );
    INSERT INTO `statistical_reports` (
        `generated_date`, 
        `report_type`, 
        `content`, 
        `data_retention_until`
    )
    VALUES (
        CURDATE(), 
        'Daily Incident Summary', 
        report_content, 
        DATE_ADD(CURDATE(), INTERVAL 1 YEAR)
    );
END;
//
DELIMITER ;

-- Threat Predictions stored procedure
DELIMITER //
CREATE PROCEDURE `generate_threat_predictions`()
BEGIN
    -- Placeholder for ML model integration
    -- Insert predictions generated externally
    INSERT INTO `threat_predictions` (
        `prediction_date`, 
        `threat_id`, 
        `probability`, 
        `predicted_impact`, 
        `data_retention_until`
    )
    VALUES (
        CURDATE(), 
        1, 
        0.85, 
        'High Impact Expected', 
        DATE_ADD(CURDATE(), INTERVAL 2 YEAR)
    );
END;
//
DELIMITER ;

-- Optimize Database stored procedure
DELIMITER //
CREATE PROCEDURE `optimize_database`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE tbl_name VARCHAR(255);
    DECLARE cur CURSOR FOR 
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO tbl_name;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET @stmt = CONCAT('OPTIMIZE TABLE ', tbl_name, ';');
        PREPARE stmt FROM @stmt;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;
    CLOSE cur;
END;
//
DELIMITER ;

-- Alert High Severity Threats stored procedure
DELIMITER //
CREATE PROCEDURE `alert_high_severity_threats`()
BEGIN
    SELECT
        `gt`.`name` AS `threat_name`,
        `gt`.`severity_level`
    FROM
        `global_threats` `gt`
    WHERE
        `gt`.`severity_level` >= 4;
    -- Additional logic to send alerts should be implemented in application layer
END;
//
DELIMITER ;

-- 8. VIEWS FOR DATA SCIENCE AND REPORTING

CREATE DEFINER=`admin_user`@`localhost` VIEW `incident_response_times_by_industry` AS
SELECT 
    `ind`.`industry_name` AS `industry_name`, 
    AVG(`il`.`response_time_hours`) AS `avg_response_time_hours`
FROM 
    `incident_logs` `il`
JOIN 
    `industries` `ind` ON `il`.`industry_id` = `ind`.`industry_id`
WHERE 
    `il`.`response_date` IS NOT NULL
GROUP BY 
    `ind`.`industry_name`;

CREATE DEFINER=`admin_user`@`localhost` VIEW `most_exploited_vulnerabilities` AS
SELECT 
    `v`.`cve_id` AS `cve_id`, 
    `v`.`description` AS `description`, 
    COUNT(`il`.`incident_id`) AS `exploitation_count`
FROM 
    `incident_logs` `il`
JOIN 
    `vulnerabilities` `v` ON `il`.`vulnerability_id` = `v`.`vulnerability_id`
GROUP BY 
    `v`.`cve_id`, `v`.`description`
ORDER BY 
    `exploitation_count` DESC;

CREATE DEFINER=`admin_user`@`localhost` VIEW `top_threats_by_region` AS
SELECT 
    `c`.`country_name` AS `country_name`, 
    COUNT(`il`.`incident_id`) AS `incident_count`
FROM 
    `incident_logs` `il`
JOIN 
    `geolocations` `g` ON `il`.`geolocation_id` = `g`.`geolocation_id`
JOIN 
    `countries` `c` ON `g`.`country` = `c`.`country_code`
GROUP BY 
    `c`.`country_name`
ORDER BY 
    `incident_count` DESC;

-- 9. ADDITIONAL SECURITY MEASURES

-- Implement data encryption at rest using MySQL encryption functions
-- Example stored procedure to decrypt email for authorized users
DELIMITER //
CREATE PROCEDURE `decrypt_user_email`(
    IN p_user_id BIGINT,
    IN p_encryption_key VARBINARY(32)
)
BEGIN
    SELECT 
        `id`, 
        `username`, 
        CAST(AES_DECRYPT(`email_encrypted`, p_encryption_key) AS CHAR(255)) AS `email`,
        `consent_to_data_usage`,
        `enabled`,
        `created_at`,
        `updated_at`
    FROM 
        `rbac_system`.`users`
    WHERE 
        `id` = p_user_id;
END;
//
DELIMITER ;

GRANT EXECUTE ON PROCEDURE `cyber_threat_intel2`.`decrypt_user_email` TO 'app_user'@'localhost';

-- Implement data masking through views
CREATE VIEW `masked_users` AS
SELECT
    `id`,
    CONCAT(LEFT(`username`, 1), '*****') AS `username`,
    NULL AS `email_encrypted`,
    `consent_to_data_usage`,
    `enabled`,
    `created_at`,
    `updated_at`
FROM 
    `rbac_system`.`users`;

GRANT SELECT ON `cyber_threat_intel2`.`masked_users` TO 'app_user'@'localhost';

-- Ensure Zero Trust by enforcing SSL connections
-- This should be configured at the MySQL server level and client connections

-- 10. FINALIZE COMPLIANCE AND SECURITY

-- Ensure all personal data is handled according to GDPR requirements
-- Regularly review and update data processing agreements and policies

-- Implement data anonymization where possible
CREATE VIEW `anonymized_users` AS
SELECT
    `id`,
    CONCAT(LEFT(`username`, 1), REPEAT('*', LENGTH(`username`)-1)) AS `username`,
    NULL AS `email_encrypted`,
    `consent_to_data_usage`,
    `enabled`,
    `created_at`,
    `updated_at`
FROM 
    `rbac_system`.`users`;

GRANT SELECT ON `cyber_threat_intel2`.`anonymized_users` TO 'app_user'@'localhost';

-- Ensure secure key management and avoid hardcoding sensitive information
-- Encryption keys should be managed via secure vaults or environment variables

-- Regularly update and enforce security practices and audits
-- Schedule regular reviews of user roles, permissions, and audit logs

-- GDPR COMPLIANCE, RBAC, AND ZERO TRUST ENHANCED SCRIPT COMPLETE

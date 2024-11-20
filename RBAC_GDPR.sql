-- GDPR-Compliant and RBAC-Enhanced SQL Script for MySQL Community Edition

-- Ensure strict SQL mode for data integrity
SET sql_mode = 'STRICT_ALL_TABLES';

-- 1. ENABLING AUDITING (Use with caution to avoid performance impact)
SET GLOBAL general_log = 'ON';
SET GLOBAL log_output = 'TABLE';

-- Create a user activity audit table for granular tracking
CREATE TABLE IF NOT EXISTS audit_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    event_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    user_host VARCHAR(255),
    query_text TEXT
) ENGINE=InnoDB;

-- Use triggers to populate custom audit log
DELIMITER //
CREATE TRIGGER audit_user_insert
AFTER INSERT ON users
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (user_host, query_text)
    VALUES (CURRENT_USER(), CONCAT('INSERT INTO users VALUES (', NEW.user_id, ', ', QUOTE(NEW.username), ', ... )'));
END;
//
DELIMITER ;

-- 2. ENCRYPTION OF SENSITIVE DATA
-- Ensure secure key management outside of this script
-- Add column for encrypted email
ALTER TABLE users ADD COLUMN email_encrypted VARBINARY(255) AFTER email;

-- Encrypt existing emails (Assume @encryption_key is set securely)
UPDATE users
SET email_encrypted = AES_ENCRYPT(email, @encryption_key)
WHERE email IS NOT NULL;

-- Remove plaintext email column after encryption
ALTER TABLE users DROP COLUMN email;

-- Decrypt data for authorized access
-- Example usage: SELECT id, AES_DECRYPT(email_encrypted, @encryption_key) AS email FROM users;

-- 3. MASKING SENSITIVE DATA (VIEW FOR MASKED DATA)
CREATE VIEW masked_users AS
SELECT
    id,
    CONCAT(LEFT(name, 1), '*****') AS name,
    CONCAT(LEFT(AES_DECRYPT(email_encrypted, @encryption_key), 3), '*****@', SUBSTRING_INDEX(AES_DECRYPT(email_encrypted, @encryption_key), '@', -1)) AS email
FROM users;

-- 4. IMPLEMENTING ROLE-BASED ACCESS CONTROL (RBAC)

-- Create RBAC database
CREATE DATABASE IF NOT EXISTS `rbac_system` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `rbac_system`;

-- Users table
CREATE TABLE `users` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password_hash` CHAR(64) NOT NULL,
  `email_encrypted` VARBINARY(255) NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB;

-- Roles table
CREATE TABLE `roles` (
  `role_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(50) NOT NULL UNIQUE,
  `description` VARCHAR(255),
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB;

-- Permissions table
CREATE TABLE `permissions` (
  `permission_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `permission_name` VARCHAR(100) NOT NULL UNIQUE,
  `description` VARCHAR(255),
  PRIMARY KEY (`permission_id`)
) ENGINE=InnoDB;

-- User_Roles junction table
CREATE TABLE `user_roles` (
  `user_id` INT UNSIGNED NOT NULL,
  `role_id` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`user_id`, `role_id`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`role_id`) REFERENCES `roles`(`role_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Role_Permissions junction table
CREATE TABLE `role_permissions` (
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
    IN p_password_hash CHAR(64),
    IN p_email_encrypted VARBINARY(255)
)
BEGIN
    INSERT INTO `users` (`username`, `password_hash`, `email_encrypted`)
    VALUES (p_username, p_password_hash, p_email_encrypted);
END;
//
DELIMITER ;

-- Assign role to user
DELIMITER //
CREATE PROCEDURE `assign_role_to_user`(
    IN p_user_id INT UNSIGNED,
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

-- Views for confidentiality (limit data exposure)

-- View to get user roles
CREATE VIEW `view_user_roles` AS
SELECT
    u.`user_id`,
    u.`username`,
    r.`role_name`
FROM
    `users` u
JOIN
    `user_roles` ur ON u.`user_id` = ur.`user_id`
JOIN
    `roles` r ON ur.`role_id` = r.`role_id`;

-- View to get role permissions
CREATE VIEW `view_role_permissions` AS
SELECT
    r.`role_name`,
    p.`permission_name`
FROM
    `roles` r
JOIN
    `role_permissions` rp ON r.`role_id` = rp.`role_id`
JOIN
    `permissions` p ON rp.`permission_id` = p.`permission_id`;

-- 5. DATA RETENTION POLICY
-- Automatically delete records older than 2 years
CREATE EVENT IF NOT EXISTS delete_old_records
ON SCHEDULE EVERY 1 DAY
DO
DELETE FROM users
WHERE last_activity < NOW() - INTERVAL 2 YEAR;

-- 6. DATA SUBJECT REQUESTS (STORED PROCEDURES)

-- Procedure for retrieving user data
DELIMITER //
CREATE PROCEDURE `GetUserData`(
    IN p_user_id INT,
    IN p_encryption_key VARBINARY(32)
)
BEGIN
    SELECT 
        user_id, 
        username, 
        AES_DECRYPT(email_encrypted, p_encryption_key) AS email,
        created_at,
        updated_at
    FROM 
        users
    WHERE 
        user_id = p_user_id;
END;
//
DELIMITER ;

-- Procedure for deleting user data
DELIMITER //
CREATE PROCEDURE `DeleteUserData`(
    IN p_user_id INT
)
BEGIN
    DELETE FROM users WHERE user_id = p_user_id;
END;
//
DELIMITER ;

-- 7. PRIVILEGE AUDIT
-- Identify users with excessive privileges
SELECT 
    user, 
    host, 
    GROUP_CONCAT(DISTINCT privilege_type) AS privileges
FROM 
    information_schema.user_privileges
GROUP BY 
    user, host
HAVING 
    privileges LIKE '%ALL%';

-- 8. MONITORING DATABASE INTEGRITY
-- Log integrity issues to a dedicated table
CREATE TABLE IF NOT EXISTS integrity_issues (
    issue_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    issue_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255)
) ENGINE=InnoDB;

CREATE EVENT IF NOT EXISTS integrity_check
ON SCHEDULE EVERY 1 WEEK
DO
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM users 
        WHERE email_encrypted IS NULL OR last_activity IS NULL
    ) THEN
        INSERT INTO integrity_issues (description)
        VALUES ('Data integrity violation detected in users table');
    END IF;
END;

-- 9. EXPORTING AUDIT LOGS
-- Export audit log securely (ensure FILE privilege and secure path)
-- Ensure the MySQL server has write access to the specified directory
SELECT * FROM audit_log 
INTO OUTFILE '/secure/path/audit_log.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n';

-- 10. COMPLIANCE AUDIT SCRIPTS

-- Verify sensitive fields encryption status
SELECT 
    user_id, 
    username, 
    email_encrypted IS NOT NULL AS is_encrypted
FROM 
    users;

-- Verify access permissions
SELECT 
    user, 
    host, 
    GROUP_CONCAT(DISTINCT privilege_type) AS privileges
FROM 
    information_schema.user_privileges
GROUP BY 
    user, host;

-- 11. USER AUDIT TRIGGERS

-- Create user audit table
CREATE TABLE `user_audit` (
  `audit_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `user_id` INT UNSIGNED NOT NULL,
  `changed_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `changed_by` VARCHAR(255),
  `change_type` VARCHAR(50),
  `old_username` VARCHAR(50),
  `new_username` VARCHAR(50),
  `old_email_encrypted` VARBINARY(255),
  `new_email_encrypted` VARBINARY(255),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Trigger for auditing user updates
DELIMITER //
CREATE TRIGGER `after_user_update`
AFTER UPDATE ON `users`
FOR EACH ROW
BEGIN
    INSERT INTO `user_audit` (
        `user_id`,
        `changed_by`,
        `change_type`,
        `old_username`,
        `new_username`,
        `old_email_encrypted`,
        `new_email_encrypted`
    ) VALUES (
        OLD.`user_id`,
        CURRENT_USER(),
        'UPDATE',
        OLD.`username`,
        NEW.`username`,
        OLD.`email_encrypted`,
        NEW.`email_encrypted`
    );
END;
//
DELIMITER ;

-- Trigger for auditing user deletions
DELIMITER //
CREATE TRIGGER `after_user_delete`
AFTER DELETE ON `users`
FOR EACH ROW
BEGIN
    INSERT INTO `user_audit` (
        `user_id`,
        `changed_by`,
        `change_type`,
        `old_username`,
        `old_email_encrypted`
    ) VALUES (
        OLD.`user_id`,
        CURRENT_USER(),
        'DELETE',
        OLD.`username`,
        OLD.`email_encrypted`
    );
END;
//
DELIMITER ;

-- 12. SECURITY ENHANCEMENTS

-- Enforce strong password policy (placeholder comment)
-- Actual enforcement should be handled in application logic

-- Ensure that passwords are stored as secure hashes (e.g., SHA-256, bcrypt)
-- This script assumes `password_hash` stores hashed passwords

-- Limit access to tables by revoking all and granting minimal privileges

-- Revoke all privileges from public
REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'public'@'%';

-- Create application user with limited privileges
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT SELECT, INSERT, UPDATE, DELETE ON `rbac_system`.* TO 'app_user'@'localhost';

-- Create admin user with all privileges
CREATE USER IF NOT EXISTS 'admin_user'@'localhost' IDENTIFIED BY 'admin_secure_password';
GRANT ALL PRIVILEGES ON `rbac_system`.* TO 'admin_user'@'localhost' WITH GRANT OPTION;

-- Flush privileges to ensure all changes take effect
FLUSH PRIVILEGES;

-- 13. ADDITIONAL GDPR COMPLIANCE MEASURES

-- Ensure all personal data is handled according to GDPR requirements
-- Regularly review and update data processing agreements and policies

-- Implement data anonymization where possible
-- Example: Create a view with anonymized data for reporting
CREATE VIEW `anonymized_users` AS
SELECT
    user_id,
    CONCAT(LEFT(username, 1), REPEAT('*', LENGTH(username)-1)) AS username,
    NULL AS email_encrypted,
    created_at,
    updated_at
FROM 
    users;

-- 14. PERFORMANCE OPTIMIZATION

-- Optimize query performance with appropriate indexing
CREATE INDEX `idx_user_last_activity` ON `users` (`last_activity`);

-- Regularly analyze and optimize tables
-- Example: OPTIMIZE TABLE `users`;

-- 15. BACKUP AND RECOVERY

-- Ensure regular backups of the database
-- Example command (to be run externally):
-- mysqldump -u admin_user -p rbac_system > rbac_system_backup.sql

-- Secure backup storage to comply with GDPR data protection requirements

-- GDPR COMPLIANCE AND RBAC ENHANCED SCRIPT COMPLETE

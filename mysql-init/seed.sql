-- Step 1: Database Creation
CREATE DATABASE IF NOT EXISTS cyberThreatIntel;
USE cyberThreatIntel;

-- Step 1: Create Users Table
CREATE TABLE IF NOT EXISTS users (
                                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
                                     password VARCHAR(100) NOT NULL,
                                     email VARCHAR(255) NOT NULL UNIQUE,
                                     enabled BOOLEAN NOT NULL DEFAULT TRUE,
                                     consent_to_data_usage BOOLEAN NOT NULL DEFAULT FALSE,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 2: Create Roles Table
CREATE TABLE IF NOT EXISTS roles (
                                     id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                     name VARCHAR(50) NOT NULL UNIQUE, -- Example: ROLE_ADMIN, ROLE_USER
                                     description VARCHAR(255) DEFAULT NULL,
                                     created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 3: Create Privileges Table
CREATE TABLE IF NOT EXISTS privileges (
                                          id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                          name VARCHAR(50) NOT NULL UNIQUE, -- Example: READ_PRIVILEGE
                                          description VARCHAR(255) DEFAULT NULL,
                                          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 4: Map Roles to Privileges
CREATE TABLE IF NOT EXISTS roles_privileges (
                                                role_id BIGINT NOT NULL,
                                                privilege_id BIGINT NOT NULL,
                                                PRIMARY KEY (role_id, privilege_id),
                                                FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE,
                                                FOREIGN KEY (privilege_id) REFERENCES privileges (id) ON DELETE CASCADE
);

-- Step 5: Map Users to Roles
CREATE TABLE IF NOT EXISTS user_roles (
                                          user_id BIGINT NOT NULL,
                                          role_id BIGINT NOT NULL,
                                          PRIMARY KEY (user_id, role_id),
                                          FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
                                          FOREIGN KEY (role_id) REFERENCES roles (id) ON DELETE CASCADE
);
-- Step 2: Independent Tables
CREATE TABLE IF NOT EXISTS countries (
                                         country_code CHAR(2) NOT NULL PRIMARY KEY,
                                         country_name VARCHAR(100) NOT NULL,
                                         created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                         updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                         CONSTRAINT country_name_UNIQUE UNIQUE (country_name)
);

CREATE TABLE IF NOT EXISTS threat_categories (
                                                 category_id INT AUTO_INCREMENT PRIMARY KEY,
                                                 category_name VARCHAR(255) NOT NULL,
                                                 description VARCHAR(255) NULL,
                                                 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                                 CONSTRAINT category_name_UNIQUE UNIQUE (category_name)
);

CREATE TABLE IF NOT EXISTS attack_vector_categories (
                                                        vector_category_id INT AUTO_INCREMENT PRIMARY KEY,
                                                        category_name VARCHAR(100) NOT NULL,
                                                        description TINYTEXT NULL,
                                                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                                        CONSTRAINT category_name_UNIQUE UNIQUE (category_name)
);

-- Step 3: Dependent Tables
CREATE TABLE IF NOT EXISTS attack_vectors (
                                              vector_id INT AUTO_INCREMENT PRIMARY KEY,
                                              name VARCHAR(255) NOT NULL UNIQUE,
                                              description VARCHAR(255) NULL,
                                              vector_category_id INT NOT NULL,
                                              severity_level INT NULL,
                                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                              updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                              CONSTRAINT fk_attack_vectors_category
                                                  FOREIGN KEY (vector_category_id) REFERENCES attack_vector_categories (vector_category_id) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS geolocations (
                                            geolocation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                            ip_address VARCHAR(16) NOT NULL,
                                            country CHAR(2) NOT NULL,
                                            region VARCHAR(100) NULL,
                                            city VARCHAR(100) NULL,
                                            latitude DECIMAL(9, 6) NULL,
                                            longitude DECIMAL(9, 6) NULL,
                                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                            CONSTRAINT unique_ip UNIQUE (ip_address),
                                            CONSTRAINT fk_geolocations_country
                                                FOREIGN KEY (country) REFERENCES countries (country_code) ON UPDATE CASCADE
);

-- Add more dependent tables
CREATE TABLE IF NOT EXISTS threat_actors (
                                             actor_id INT AUTO_INCREMENT PRIMARY KEY,
                                             name VARCHAR(255) NOT NULL UNIQUE,
                                             type_id INT NOT NULL,
                                             description VARCHAR(255) NULL,
                                             origin_country CHAR(2) NOT NULL,
                                             first_observed DATE NOT NULL,
                                             last_activity DATE NULL,
                                             category_id INT NOT NULL,
                                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                             updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                             CONSTRAINT fk_threat_actors_category
                                                 FOREIGN KEY (category_id) REFERENCES threat_categories (category_id) ON UPDATE CASCADE,
                                             CONSTRAINT fk_threat_actors_country
                                                 FOREIGN KEY (origin_country) REFERENCES countries (country_code) ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vulnerabilities (
                                               vulnerability_id INT AUTO_INCREMENT PRIMARY KEY,
                                               cve_id VARCHAR(20) NOT NULL UNIQUE,
                                               description TINYTEXT NOT NULL,
                                               published_date DATE NOT NULL,
                                               severity_score DECIMAL(4, 1) NOT NULL CHECK (`severity_score` BETWEEN 0.0 AND 10.0),
                                               created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                               updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS incident_logs (
                                             incident_id BIGINT AUTO_INCREMENT PRIMARY KEY,
                                             actor_id INT NOT NULL,
                                             vector_id INT NOT NULL,
                                             vulnerability_id INT NULL,
                                             geolocation_id BIGINT NOT NULL,
                                             incident_date DATETIME NOT NULL,
                                             target VARCHAR(255) NOT NULL,
                                             impact VARCHAR(255) NULL,
                                             created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                             updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                                             CONSTRAINT fk_incident_logs_actor FOREIGN KEY (actor_id) REFERENCES threat_actors (actor_id) ON UPDATE CASCADE,
                                             CONSTRAINT fk_incident_logs_vector FOREIGN KEY (vector_id) REFERENCES attack_vectors (vector_id) ON UPDATE CASCADE,
                                             CONSTRAINT fk_incident_logs_geolocation FOREIGN KEY (geolocation_id) REFERENCES geolocations (geolocation_id) ON UPDATE CASCADE
);

-- Step 4: Views
CREATE OR REPLACE VIEW most_exploited_vulnerabilities AS
SELECT v.cve_id AS cve_id, v.description AS description, COUNT(il.incident_id) AS exploitation_count
FROM incident_logs il
         JOIN vulnerabilities v ON il.vulnerability_id = v.vulnerability_id
GROUP BY v.cve_id, v.description
ORDER BY exploitation_count DESC;

CREATE OR REPLACE VIEW top_threats_by_region AS
SELECT c.country_name AS country_name, COUNT(il.incident_id) AS incident_count
FROM incident_logs il
         JOIN geolocations g ON il.geolocation_id = g.geolocation_id
         JOIN countries c ON g.country = c.country_code
GROUP BY c.country_name
ORDER BY incident_count DESC;

-- Step 5: Triggers
DELIMITER $$

CREATE TRIGGER incident_logs_after_insert
    AFTER INSERT ON incident_logs
    FOR EACH ROW
BEGIN
    INSERT INTO incident_logs_audit (action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id, incident_date, target)
    VALUES ('INSERT', NEW.incident_id, NEW.actor_id, NEW.vector_id, NEW.vulnerability_id, NEW.geolocation_id, NEW.incident_date, NEW.target);
END$$

DELIMITER ;

-- Step 3: Inserts for Roles, Privileges, and Users
-- Insert Roles (with ROLE_ prefix for Spring Security compatibility)
INSERT INTO roles (name) VALUES
                             ('ROLE_ADMIN'),
                             ('ROLE_USER'),
                             ('ROLE_MODERATOR');

-- Insert Privileges
INSERT INTO privileges (name) VALUES
                                  ('READ_PRIVILEGE'),
                                  ('WRITE_PRIVILEGE'),
                                  ('DELETE_PRIVILEGE');

-- Map Privileges to Roles
INSERT INTO roles_privileges (privilege_id, role_id) VALUES
                                                         (1, 1), -- ROLE_ADMIN has READ_PRIVILEGE
                                                         (2, 1), -- ROLE_ADMIN has WRITE_PRIVILEGE
                                                         (3, 1), -- ROLE_ADMIN has DELETE_PRIVILEGE
                                                         (1, 2), -- ROLE_USER has READ_PRIVILEGE
                                                         (2, 2), -- ROLE_USER has WRITE_PRIVILEGE
                                                         (1, 3), -- ROLE_MODERATOR has READ_PRIVILEGE
                                                         (2, 3); -- ROLE_MODERATOR has WRITE_PRIVILEGE

-- Insert Users (hashed passwords for Spring Security compliance)
-- Use BCrypt for password hashing: e.g., BCryptPasswordEncoder().encode("password")
INSERT INTO users (username, password, email, enabled, consent_to_data_usage) VALUES
                                                                                  ('adminUser', '$2a$10$TjJ1YJVJIEI.LdRfmlpZ9OjDaZILKQov8i5JZW7z6D5RMKQ/A5HdK', 'admin@example.com', 1, 1), -- Password: @Password123
                                                                                  ('regularUser', '$2a$10$TjJ1YJVJIEI.LdRfmlpZ9OjDaZILKQov8i5JZW7z6D5RMKQ/A5HdK', 'user@example.com', 1, 1), -- Password: @Password123
                                                                                  ('moderatorUser', '$2a$10$TjJ1YJVJIEI.LdRfmlpZ9OjDaZILKQov8i5JZW7z6D5RMKQ/A5HdK', 'moderator@example.com', 1, 1); -- Password: @Password123

-- Assign Roles to Users
INSERT INTO user_roles (user_id, role_id) VALUES
                                              (1, 1), -- adminUser is ROLE_ADMIN
                                              (2, 2), -- regularUser is ROLE_USER
                                              (3, 3); -- moderatorUser is ROLE_MODERATOR                                (3, 3); -- moderatorUser is MODERATOR
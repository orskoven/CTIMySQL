-- Create the Cyber Threat Intelligence (CTI) database
CREATE DATABASE cti_db_revised;

-- Use the database
USE cti_db_revised;

-- Table for storing threat indicators
CREATE TABLE indicators (
    indicator_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    value VARCHAR(255) UNIQUE NOT NULL, -- IP, domain, hash, etc.
    type_id BIGINT NOT NULL, -- Foreign key to indicator types
    description TEXT,
    confidence_level TINYINT CHECK (confidence_level BETWEEN 0 AND 100), -- Indicator reliability
    status ENUM('Active', 'Inactive', 'Deprecated') DEFAULT 'Active',
    enrichment JSON, -- Enrichment data (e.g., geolocation, ASN, threat score)
    source_id BIGINT, -- Linked to the intelligence source
    stix_id VARCHAR(255) UNIQUE, -- Integration with STIX/TAXII systems
    first_seen DATETIME,
    last_seen DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_indicator_value (value),
    FOREIGN KEY (type_id) REFERENCES indicator_types(type_id),
    FOREIGN KEY (source_id) REFERENCES sources(source_id)
);

-- Table for indicator types
CREATE TABLE indicator_types (
    type_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., IP Address, Domain, Hash
    description TEXT
);

-- Table for storing threat actors
CREATE TABLE threat_actors (
    actor_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    alias VARCHAR(255),
    description TEXT,
    motivation_id BIGINT, -- Reference to motivations table
    confidence_level TINYINT CHECK (confidence_level BETWEEN 0 AND 100), -- Actor reliability
    activity_status ENUM('Active', 'Dormant', 'Unknown') DEFAULT 'Active',
    first_seen DATETIME,
    last_seen DATETIME,
    stix_id VARCHAR(255) UNIQUE, -- Integration with STIX/TAXII systems
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (motivation_id) REFERENCES motivations(motivation_id)
);

-- Table for motivations
CREATE TABLE motivations (
    motivation_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., Espionage, Financial Gain
    description TEXT
);

-- Table for campaigns
CREATE TABLE campaigns (
    campaign_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    start_date DATETIME,
    end_date DATETIME,
    associated_actor_id BIGINT, -- Foreign key to threat actors
    confidence_level TINYINT CHECK (confidence_level BETWEEN 0 AND 100), -- Campaign attribution confidence
    stix_id VARCHAR(255) UNIQUE, -- Integration with STIX/TAXII systems
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (associated_actor_id) REFERENCES threat_actors(actor_id)
);

-- Table for incidents
CREATE TABLE incidents (
    incident_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    severity ENUM('Low', 'Medium', 'High', 'Critical') DEFAULT 'Medium',
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') DEFAULT 'Open',
    first_detected DATETIME,
    last_updated DATETIME,
    stix_id VARCHAR(255) UNIQUE, -- Integration with STIX/TAXII systems
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Dynamic relationships table for mapping any two entities
CREATE TABLE relationships (
    relationship_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    source_id BIGINT NOT NULL, -- Source entity ID
    target_id BIGINT NOT NULL, -- Target entity ID
    source_type ENUM('Indicator', 'Actor', 'Campaign', 'Incident', 'Malware') NOT NULL,
    target_type ENUM('Indicator', 'Actor', 'Campaign', 'Incident', 'Malware') NOT NULL,
    relationship_type ENUM('Associated With', 'Attributed To', 'Impacts', 'Part Of') NOT NULL,
    confidence_level TINYINT CHECK (confidence_level BETWEEN 0 AND 100), -- Relationship confidence
    start_date DATETIME,
    end_date DATETIME,
    is_bidirectional BOOLEAN DEFAULT FALSE, -- Indicates bidirectional relationships
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for malware
CREATE TABLE malware (
    malware_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    type_id BIGINT NOT NULL, -- Reference to malware types
    description TEXT,
    hash_value VARCHAR(255) UNIQUE,
    enrichment JSON, -- Behavior analysis, signatures, etc.
    stix_id VARCHAR(255) UNIQUE, -- Integration with STIX/TAXII systems
    first_seen DATETIME,
    last_seen DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES malware_types(type_id)
);

-- Table for malware types
CREATE TABLE malware_types (
    type_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- e.g., Ransomware, Trojan
    description TEXT
);

-- Table for threat intelligence sources
CREATE TABLE sources (
    source_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL, -- e.g., FireEye, OpenCTI
    type ENUM('Open Source', 'Commercial', 'Private') DEFAULT 'Open Source',
    contact_info VARCHAR(255),
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Comprehensive audit logs table
CREATE TABLE audit_logs (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT NOT NULL, -- Reference to users table
    action VARCHAR(255), -- e.g., INSERT, UPDATE, DELETE
    target_type ENUM('Indicator', 'Actor', 'Campaign', 'Incident', 'Malware'),
    target_id BIGINT,
    action_description TEXT, -- Detailed description of the action
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Table for user accounts with RBAC support
CREATE TABLE users (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('Admin', 'Analyst', 'Viewer') DEFAULT 'Analyst',
    organization_id BIGINT, -- Reference to organizations table
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (organization_id) REFERENCES organizations(organization_id)
);

-- Table for organizations (multi-tenancy support)
CREATE TABLE organizations (
    organization_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    contact_info VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Future Enhancements:
-- 1. Implement table partitioning for high-volume tables (e.g., indicators, audit_logs) to enhance performance.
-- 2. Develop materialized views for frequently queried relationships to reduce JOIN overhead.
-- 3. Automate ingestion pipelines for real-time updates from TAXII/STIX feeds.
-- 4. Add row-level encryption for sensitive data fields (e.g., enrichment).
-- 5. Integrate machine learning-based scoring for automated prioritization of high-risk entities.
-- 6. Enable API endpoints for seamless integration with external tools.
-- 7. Establish alerting triggers for anomalous database activities (e.g., unauthorized data access).

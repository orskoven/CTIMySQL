create table affected_products
(
    product_id   int auto_increment
        primary key,
    product_name varchar(255)                        not null,
    vendor       varchar(255)                        null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    updated_at   timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint product_name
        unique (product_name)
);

create table attack_vector_categories
(
    vector_category_id int auto_increment
        primary key,
    category_name      varchar(100)                        not null,
    description        tinytext                            null,
    created_at         timestamp default CURRENT_TIMESTAMP null,
    updated_at         timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint category_name_UNIQUE
        unique (category_name)
);

create table attack_vectors
(
    vector_id          int auto_increment
        primary key,
    name               varchar(255)                        not null,
    description        varchar(255)                        null,
    vector_category_id int                                 not null,
    severity_level     int                                 null,
    created_at         timestamp default CURRENT_TIMESTAMP null,
    updated_at         timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    category           varchar(255)                        null,
    constraint name_UNIQUE
        unique (name),
    constraint fk_attack_vectors_category
        foreign key (vector_category_id) references attack_vector_categories (vector_category_id)
            on update cascade
);

create index idx_vector_category_id
    on attack_vectors (vector_category_id);

create table countries
(
    country_code char(2)                             not null
        primary key,
    country_name varchar(100)                        not null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    updated_at   timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint country_name_UNIQUE
        unique (country_name)
);

create table geolocation_data
(
    geolocation_id bigint       not null
        primary key,
    city           varchar(255) null,
    country        varchar(255) null,
    ip_address     varchar(255) not null,
    latitude       double       null,
    longitude      double       null,
    region         varchar(255) null
);

create table geolocations
(
    geolocation_id bigint auto_increment
        primary key,
    ip_address     varchar(16)                         not null,
    country        char(2)                             not null,
    region         varchar(100)                        null,
    city           varchar(100)                        null,
    latitude       decimal(9, 6)                       null,
    longitude      decimal(9, 6)                       null,
    created_at     timestamp default CURRENT_TIMESTAMP null,
    updated_at     timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint unique_ip
        unique (ip_address),
    constraint fk_geolocations_country
        foreign key (country) references countries (country_code)
            on update cascade
);

create index idx_city
    on geolocations (city);

create index idx_country
    on geolocations (country);

create index idx_country_city
    on geolocations (country, city);

create index idx_region
    on geolocations (region);

create table global_threats
(
    threat_id            int auto_increment
        primary key,
    name                 varchar(255)                        not null,
    description          varchar(255)                        null,
    first_detected       date                                not null,
    last_updated         date                                null,
    severity_level       int       default 0                 not null,
    data_retention_until datetime                            not null,
    created_at           timestamp default CURRENT_TIMESTAMP null,
    updated_at           timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint name_UNIQUE
        unique (name)
);

create index idx_name
    on global_threats (name);

create index idx_severity_level
    on global_threats (severity_level);

create table incident_logs_audit
(
    audit_id             bigint auto_increment
        primary key,
    action_type          enum ('INSERT', 'UPDATE', 'DELETE')    not null,
    incident_id          bigint                                 null,
    actor_id             int                                    null,
    vector_id            int                                    null,
    vulnerability_id     int                                    null,
    geolocation_id       bigint                                 null,
    incident_date        datetime                               null,
    target               varchar(255)                           null,
    industry_id          int                                    null,
    impact               varchar(255)                           null,
    response             varchar(255)                           null,
    response_date        datetime                               null,
    data_retention_until datetime                               null,
    action_timestamp     timestamp    default CURRENT_TIMESTAMP null,
    performed_by         varchar(100) default 'system'          null
);

create table industries
(
    industry_id   int auto_increment
        primary key,
    industry_name varchar(100)                        not null,
    description   tinytext                            null,
    created_at    timestamp default CURRENT_TIMESTAMP null,
    updated_at    timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint industry_name_UNIQUE
        unique (industry_name)
);

create table most_exploited_vulnerabilities_mat
(
    cve_id             varchar(20)      not null,
    description        tinytext         not null,
    exploitation_count bigint default 0 not null
);

create table privileges
(
    id   bigint auto_increment
        primary key,
    name varchar(255) not null,
    constraint name
        unique (name)
);

create table roles
(
    id   bigint auto_increment
        primary key,
    name varchar(255) not null,
    constraint name
        unique (name)
);

create table roles_privileges
(
    role_id      bigint not null,
    privilege_id bigint not null,
    primary key (role_id, privilege_id),
    constraint roles_privileges_ibfk_1
        foreign key (role_id) references roles (id)
            on delete cascade,
    constraint roles_privileges_ibfk_2
        foreign key (privilege_id) references privileges (id)
            on delete cascade
);

create index privilege_id
    on roles_privileges (privilege_id);

create table statistical_reports
(
    report_id      bigint       not null
        primary key,
    content        varchar(255) null,
    generated_date date         not null,
    report_type    varchar(255) not null
);

create table threat_actor_types
(
    type_id     int auto_increment
        primary key,
    type_name   varchar(100)                        not null,
    description tinytext                            null,
    created_at  timestamp default CURRENT_TIMESTAMP null,
    updated_at  timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint type_name_UNIQUE
        unique (type_name)
);

create table threat_actors_audit
(
    audit_id         bigint auto_increment
        primary key,
    action_type      enum ('INSERT', 'UPDATE', 'DELETE')    not null,
    actor_id         int                                    null,
    name             varchar(255)                           null,
    type_id          int                                    null,
    description      varchar(255)                           null,
    origin_country   char(2)                                null,
    first_observed   date                                   null,
    last_activity    date                                   null,
    category_id      int                                    null,
    action_timestamp timestamp    default CURRENT_TIMESTAMP null,
    performed_by     varchar(100) default 'system'          null
);

create table threat_categories
(
    category_id   int auto_increment
        primary key,
    category_name varchar(255)                        not null,
    description   varchar(255)                        null,
    created_at    timestamp default CURRENT_TIMESTAMP null,
    updated_at    timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint category_name_UNIQUE
        unique (category_name)
);

create table threat_actors
(
    actor_id       int auto_increment
        primary key,
    name           varchar(255)                        not null,
    type_id        int                                 not null,
    description    varchar(255)                        null,
    origin_country char(2)                             not null,
    first_observed date                                not null,
    last_activity  date                                null,
    category_id    int                                 not null,
    created_at     timestamp default CURRENT_TIMESTAMP null,
    updated_at     timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    type           varchar(255)                        not null,
    constraint name_UNIQUE
        unique (name),
    constraint fk_threat_actors_category
        foreign key (category_id) references threat_categories (category_id)
            on update cascade,
    constraint fk_threat_actors_country
        foreign key (origin_country) references countries (country_code)
            on update cascade,
    constraint fk_threat_actors_type
        foreign key (type_id) references threat_actor_types (type_id)
            on update cascade
);

create table threat_actor_attack_vector
(
    threat_actor_id  int not null,
    attack_vector_id int not null,
    primary key (threat_actor_id, attack_vector_id),
    constraint FK2hqe73ok61q3ul2icjdt0x9gr
        foreign key (threat_actor_id) references threat_actors (actor_id),
    constraint FKf5x6vp5yv5jfo2ce15eo6kjfy
        foreign key (attack_vector_id) references attack_vectors (vector_id)
);

create index idx_category_id
    on threat_actors (category_id);

create index idx_origin_country
    on threat_actors (origin_country);

create index idx_type_id
    on threat_actors (type_id);

create definer = root@localhost trigger threat_actors_after_delete
    after delete
    on threat_actors
    for each row
BEGIN
    INSERT INTO threat_actors_audit (
        action_type, actor_id, name, type_id, description, origin_country,
        first_observed, last_activity, category_id, action_timestamp, performed_by
    )
    VALUES (
        'DELETE', OLD.actor_id, OLD.name, OLD.type_id, OLD.description, OLD.origin_country,
        OLD.first_observed, OLD.last_activity, OLD.category_id, NOW(), 'system'
    );
END;

create definer = root@localhost trigger threat_actors_after_insert
    after insert
    on threat_actors
    for each row
BEGIN
    INSERT INTO threat_actors_audit (
        action_type, actor_id, name, type_id, description, origin_country,
        first_observed, last_activity, category_id, action_timestamp, performed_by
    )
    VALUES (
        'INSERT', NEW.actor_id, NEW.name, NEW.type_id, NEW.description, NEW.origin_country,
        NEW.first_observed, NEW.last_activity, NEW.category_id, NOW(), 'system'
    );
END;

create definer = root@localhost trigger threat_actors_after_update
    after update
    on threat_actors
    for each row
BEGIN
    INSERT INTO threat_actors_audit (
        action_type, actor_id, name, type_id, description, origin_country,
        first_observed, last_activity, category_id, action_timestamp, performed_by
    )
    VALUES (
        'UPDATE', OLD.actor_id, OLD.name, OLD.type_id, OLD.description, OLD.origin_country,
        OLD.first_observed, OLD.last_activity, OLD.category_id, NOW(), 'system'
    );
END;

create table threat_predictions
(
    prediction_id        bigint auto_increment
        primary key,
    prediction_date      date                                not null,
    threat_id            int                                 not null,
    probability          double                              not null,
    predicted_impact     varchar(255)                        null,
    data_retention_until datetime                            not null,
    created_at           timestamp default CURRENT_TIMESTAMP null,
    constraint fk_threat_predictions_threat
        foreign key (threat_id) references global_threats (threat_id)
            on update cascade on delete cascade
);

create index idx_prediction_date
    on threat_predictions (prediction_date);

create index idx_threat_id
    on threat_predictions (threat_id);

create index idx_threat_prediction_date
    on threat_predictions (threat_id, prediction_date);

create table users
(
    id                    bigint auto_increment
        primary key,
    password              varchar(100) not null,
    username              varchar(50)  not null,
    consent_to_data_usage bit          not null,
    email                 varchar(255) not null,
    enabled               bit          not null,
    constraint UKr43af9ap4edm43mmtq01oddj6
        unique (username)
);

create table user_roles
(
    user_id bigint       not null,
    role    varchar(255) null,
    role_id bigint       not null,
    id      bigint       not null,
    constraint FKhfh9dx7w3ubf1co1vdev94g3f
        foreign key (user_id) references users (id)
);

create table vulnerabilities
(
    vulnerability_id int auto_increment
        primary key,
    cve_id           varchar(20)                         not null,
    description      tinytext                            not null,
    published_date   date                                not null,
    severity_score   decimal(4, 1)                       not null,
    created_at       timestamp default CURRENT_TIMESTAMP null,
    updated_at       timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    constraint cve_id
        unique (cve_id),
    check (`severity_score` between 0.0 and 10.0)
);

create table incident_logs
(
    incident_id          bigint auto_increment
        primary key,
    actor_id             int                                 not null,
    vector_id            int                                 not null,
    vulnerability_id     int                                 null,
    geolocation_id       bigint                              not null,
    incident_date        datetime                            not null,
    target               varchar(255)                        not null,
    industry_id          int                                 not null,
    impact               varchar(255)                        null,
    response             varchar(255)                        null,
    response_date        datetime                            null,
    data_retention_until datetime                            not null,
    created_at           timestamp default CURRENT_TIMESTAMP null,
    updated_at           timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    industry             varchar(255)                        null,
    response_time_hours  int as (timestampdiff(HOUR, `incident_date`, `response_date`)),
    constraint FKan3r4ytjdq0f1x5qa9r7bfu6u
        foreign key (geolocation_id) references geolocation_data (geolocation_id),
    constraint fk_incident_logs_actor
        foreign key (actor_id) references threat_actors (actor_id)
            on update cascade,
    constraint fk_incident_logs_geolocation
        foreign key (geolocation_id) references geolocations (geolocation_id)
            on update cascade,
    constraint fk_incident_logs_industry
        foreign key (industry_id) references industries (industry_id)
            on update cascade,
    constraint fk_incident_logs_vector
        foreign key (vector_id) references attack_vectors (vector_id)
            on update cascade,
    constraint fk_incident_logs_vulnerability
        foreign key (vulnerability_id) references vulnerabilities (vulnerability_id)
            on update cascade on delete set null
);

create index idx_actor_id
    on incident_logs (actor_id);

create index idx_actor_incident_industry
    on incident_logs (actor_id, incident_date, industry_id);

create index idx_geolocation_id
    on incident_logs (geolocation_id);

create index idx_incident_date
    on incident_logs (incident_date);

create index idx_industry_id
    on incident_logs (industry_id);

create index idx_target
    on incident_logs (target);

create index idx_target_prefix
    on incident_logs (target(20));

create index idx_vector_id
    on incident_logs (vector_id);

create index idx_vulnerability_id
    on incident_logs (vulnerability_id);

create definer = root@localhost trigger incident_logs_after_delete
    after delete
    on incident_logs
    for each row
BEGIN
    INSERT INTO incident_logs_audit (
        action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id,
        incident_date, target, industry_id, impact, response, response_date,
        data_retention_until, action_timestamp, performed_by
    )
    VALUES (
        'DELETE', OLD.incident_id, OLD.actor_id, OLD.vector_id, OLD.vulnerability_id, OLD.geolocation_id,
        OLD.incident_date, OLD.target, OLD.industry_id, OLD.impact, OLD.response, OLD.response_date,
        OLD.data_retention_until, NOW(), 'system'
    );
END;

create definer = root@localhost trigger incident_logs_after_insert
    after insert
    on incident_logs
    for each row
BEGIN
    INSERT INTO incident_logs_audit (
        action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id,
        incident_date, target, industry_id, impact, response, response_date,
        data_retention_until, action_timestamp, performed_by
    )
    VALUES (
        'INSERT', NEW.incident_id, NEW.actor_id, NEW.vector_id, NEW.vulnerability_id, NEW.geolocation_id,
        NEW.incident_date, NEW.target, NEW.industry_id, NEW.impact, NEW.response, NEW.response_date,
        NEW.data_retention_until, NOW(), 'system'
    );
END;

create definer = root@localhost trigger incident_logs_after_update
    after update
    on incident_logs
    for each row
BEGIN
    INSERT INTO incident_logs_audit (
        action_type, incident_id, actor_id, vector_id, vulnerability_id, geolocation_id,
        incident_date, target, industry_id, impact, response, response_date,
        data_retention_until, action_timestamp, performed_by
    )
    VALUES (
        'UPDATE', OLD.incident_id, OLD.actor_id, OLD.vector_id, OLD.vulnerability_id, OLD.geolocation_id,
        OLD.incident_date, OLD.target, OLD.industry_id, OLD.impact, OLD.response, OLD.response_date,
        OLD.data_retention_until, NOW(), 'system'
    );
END;

create table machine_learning_features
(
    feature_id     bigint auto_increment
        primary key,
    incident_id    bigint                              not null,
    feature_vector json                                null,
    feature_name   varchar(255)                        not null,
    feature_value  double                              not null,
    created_at     timestamp default CURRENT_TIMESTAMP null,
    constraint fk_ml_features_incident
        foreign key (incident_id) references incident_logs (incident_id)
            on update cascade on delete cascade
);

create index idx_incident_id
    on machine_learning_features (incident_id);

create table time_series_analytics
(
    time_series_id bigint       not null
        primary key,
    analysis_date  date         not null,
    metric         varchar(255) not null,
    value          double       not null,
    incident_id    bigint       not null,
    constraint FK3ccjv365hi2e3tvm93a374k3o
        foreign key (incident_id) references incident_logs (incident_id)
);

create index idx_cve_id
    on vulnerabilities (cve_id);

create index idx_published_date
    on vulnerabilities (published_date);

create index idx_severity_score
    on vulnerabilities (severity_score);

create definer = root@localhost trigger vulnerabilities_after_delete
    after delete
    on vulnerabilities
    for each row
BEGIN
    INSERT INTO vulnerabilities_audit (
        action_type, vulnerability_id, cve_id, description, published_date,
        severity_score, action_timestamp, performed_by
    )
    VALUES (
        'DELETE', OLD.vulnerability_id, OLD.cve_id, OLD.description, OLD.published_date,
        OLD.severity_score, NOW(), 'system'
    );
END;

create definer = root@localhost trigger vulnerabilities_after_insert
    after insert
    on vulnerabilities
    for each row
BEGIN
    INSERT INTO vulnerabilities_audit (
        action_type, vulnerability_id, cve_id, description, published_date,
        severity_score, action_timestamp, performed_by
    )
    VALUES (
        'INSERT', NEW.vulnerability_id, NEW.cve_id, NEW.description, NEW.published_date,
        NEW.severity_score, NOW(), 'system'
    );
END;

create definer = root@localhost trigger vulnerabilities_after_update
    after update
    on vulnerabilities
    for each row
BEGIN
    INSERT INTO vulnerabilities_audit (
        action_type, vulnerability_id, cve_id, description, published_date,
        severity_score, action_timestamp, performed_by
    )
    VALUES (
        'UPDATE', OLD.vulnerability_id, OLD.cve_id, OLD.description, OLD.published_date,
        OLD.severity_score, NOW(), 'system'
    );
END;

create table vulnerabilities_audit
(
    audit_id         bigint auto_increment
        primary key,
    action_type      enum ('INSERT', 'UPDATE', 'DELETE')    not null,
    vulnerability_id int                                    null,
    cve_id           varchar(20)                            null,
    description      tinytext                               null,
    published_date   date                                   null,
    severity_score   decimal(4, 1)                          null,
    action_timestamp timestamp    default CURRENT_TIMESTAMP null,
    performed_by     varchar(100) default 'system'          null
);

create table vulnerability_product_association
(
    vulnerability_id int not null,
    product_id       int not null,
    primary key (vulnerability_id, product_id),
    constraint vulnerability_product_association_ibfk_1
        foreign key (vulnerability_id) references vulnerabilities (vulnerability_id)
            on update cascade on delete cascade,
    constraint vulnerability_product_association_ibfk_2
        foreign key (product_id) references affected_products (product_id)
            on update cascade on delete cascade
);

create index idx_product_id
    on vulnerability_product_association (product_id);

create definer = root@localhost view incident_response_times_by_industry as
select `ind`.`industry_name` AS `industry_name`, avg(`il`.`response_time_hours`) AS `avg_response_time_hours`
from (`cyber_threat_intel2`.`incident_logs` `il` join `cyber_threat_intel2`.`industries` `ind`
      on ((`il`.`industry_id` = `ind`.`industry_id`)))
where (`il`.`response_date` is not null)
group by `ind`.`industry_name`;

create definer = root@localhost view most_exploited_vulnerabilities as
select `v`.`cve_id` AS `cve_id`, `v`.`description` AS `description`, count(`il`.`incident_id`) AS `exploitation_count`
from (`cyber_threat_intel2`.`incident_logs` `il` join `cyber_threat_intel2`.`vulnerabilities` `v`
      on ((`il`.`vulnerability_id` = `v`.`vulnerability_id`)))
group by `v`.`cve_id`, `v`.`description`
order by `exploitation_count` desc;

create definer = root@localhost view top_threats_by_region as
select `c`.`country_name` AS `country_name`, count(`il`.`incident_id`) AS `incident_count`
from ((`cyber_threat_intel2`.`incident_logs` `il` join `cyber_threat_intel2`.`geolocations` `g`
       on ((`il`.`geolocation_id` = `g`.`geolocation_id`))) join `cyber_threat_intel2`.`countries` `c`
      on ((`g`.`country` = `c`.`country_code`)))
group by `c`.`country_name`
order by `incident_count` desc;

create
    definer = root@localhost procedure alert_high_severity_threats()
BEGIN
    SELECT
        gt.name AS threat_name,
        gt.severity_level
    FROM
        global_threats gt
    WHERE
        gt.severity_level >= 4;
    -- Additional logic to send alerts can be implemented in application code
END;

create
    definer = root@localhost procedure generate_threat_predictions()
BEGIN
    -- Placeholder for ML model integration
    -- Insert predictions generated externally
    INSERT INTO threat_predictions (
        prediction_date, 
        threat_id, 
        probability, 
        predicted_impact, 
        data_retention_until
    )
    VALUES (
        CURDATE(), 
        1, 
        0.8500, 
        'High Impact Expected', 
        DATE_ADD(CURDATE(), INTERVAL 2 YEAR)
    );
END;

create
    definer = root@localhost procedure optimize_database()
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

create
    definer = root@localhost procedure update_statistical_reports()
BEGIN
    DECLARE report_content TEXT;
    SET report_content = CONCAT(
        'Total Incidents Today: ',
        (SELECT COUNT(*) FROM incident_logs WHERE DATE(incident_date) = CURDATE()),
        ', Date: ', CURDATE()
    );
    INSERT INTO statistical_reports (
        generated_date, 
        report_type, 
        content, 
        data_retention_until
    )
    VALUES (
        CURDATE(), 
        'Daily Incident Summary', 
        report_content, 
        DATE_ADD(CURDATE(), INTERVAL 1 YEAR)
    );
END;


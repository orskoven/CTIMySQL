# ===========================================
# Step 1: Update Model Classes
# ===========================================

echo "=== Step 1: Updating Model Classes ==="

# List of model classes to update with their content
declare -A MODEL_CLASSES=(
    ["JpaThreatActor.java"]="package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = \"threat_actors\")
public class JpaThreatActor {
    @Id
    @Column(name = \"actor_id\", nullable = false)
    private Integer id;

    @Column(name = \"actor_name\", nullable = false)
    private String actorName;

    @Column(name = \"motivation\")
    private String motivation;

    @Column(name = \"capabilities\")
    private String capabilities;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = \"type_id\", nullable = false)
    private JpaThreatActorType type;

    @Column(name = \"description\")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = \"origin_country\", nullable = false)
    private JpaCountry originCountry;

    @Column(name = \"first_observed\", nullable = false)
    private LocalDate firstObserved;

    @Column(name = \"last_activity\")
    private LocalDate lastActivity;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = \"category_id\", nullable = false)
    private JpaThreatCategory category;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"created_at\")
    private Instant createdAt;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"updated_at\")
    private Instant updatedAt;

    @Column(name = \"type\", nullable = false)
    private String type1;

    @ManyToMany
    @JoinTable(
            name = \"threat_actor_attack_vector\",
            joinColumns = @JoinColumn(name = \"threat_actor_id\"),
            inverseJoinColumns = @JoinColumn(name = \"attack_vector_id\")
    )
    private Set<JpaAttackVector> attackVectors = new HashSet<>();
}"

    ["JpaVulnerability.java"]="package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.math.BigDecimal;
import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = \"vulnerabilities\")
public class JpaVulnerability {
    @Id
    @Column(name = \"vulnerability_id\", nullable = false)
    private Integer id;

    @Column(name = \"cve_id\", nullable = false, length = 20)
    private String cveId;

    @Lob
    @Column(name = \"description\", nullable = false)
    private String description;

    @Column(name = \"published_date\", nullable = false)
    private LocalDate publishedDate;

    @Column(name = \"severity_score\", nullable = false, precision = 4, scale = 1)
    private BigDecimal severityScore;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"created_at\")
    private Instant createdAt;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"updated_at\")
    private Instant updatedAt;
}"

    ["JpaAttackVector.java"]="package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = \"attack_vectors\")
public class JpaAttackVector {
    @Id
    @Column(name = \"vector_id\", nullable = false)
    private Integer id;

    @Column(name = \"vector_name\", nullable = false)
    private String vectorName;

    @Column(name = \"description\")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = \"vector_category_id\", nullable = false)
    private JpaAttackVectorCategory vectorCategory;

    @Column(name = \"severity_level\")
    private Integer severityLevel;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"created_at\")
    private Instant createdAt;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"updated_at\")
    private Instant updatedAt;

    @Column(name = \"category\")
    private String category;

    @ManyToMany(mappedBy = \"attackVectors\")
    private Set<JpaThreatActor> threatActors = new HashSet<>();
}"

    ["User.java"]="package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = \"users\")
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true, length = 50)
    private String username;

    @Column(nullable = false, length = 100)
    private String password;

    @Column(nullable = false, unique = true, length = 255)
    private String email;

    @Column(nullable = false)
    private Boolean enabled = false;

    @Column(nullable = false, name = \"consent_to_data_usage\")
    private Boolean consentToDataUsage = false;

    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = \"user_roles\",
            joinColumns = @JoinColumn(name = \"user_id\"),
            inverseJoinColumns = @JoinColumn(name = \"role_id\")
    )
    private Set<JpaRole> roles = new HashSet<>();

    @OneToMany(mappedBy = \"user\", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private Set<RefreshToken> refreshTokens = new HashSet<>();

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }
}"

    ["JpaCountry.java"]="package orsk.compli.entities.jpa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = \"countries\")
public class JpaCountry {
    @Id
    @Column(name = \"country_code\", nullable = false, length = 2)
    private String countryCode;

    @Column(name = \"country_name\", nullable = false, length = 100)
    private String countryName;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"created_at\")
    private Instant createdAt;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"updated_at\")
    private Instant updatedAt;

    public String getName() {
        return countryName;
    }

    public void setName(String name) {
        this.countryName = name;
    }
}"

    ["JpaAffectedProduct.java"]="package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = \"affected_products\")
public class JpaAffectedProduct {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = \"product_id\", nullable = false)
    private Integer id;

    @Column(name = \"product_name\", nullable = false)
    private String productName;

    @Column(name = \"vendor\")
    private String vendor;

    @Column(name = \"version\")
    private String version;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"created_at\")
    private Instant createdAt;

    @ColumnDefault(\"CURRENT_TIMESTAMP\")
    @Column(name = \"updated_at\")
    private Instant updatedAt;
}"
)

# Iterate over MODEL_CLASSES and update/create files
for FILE in "${!MODEL_CLASSES[@]}"; do
    FILE_PATH="$ENTITIES_DIR/$FILE"
    backup_file "$FILE_PATH"
    create_or_update_file "$FILE_PATH" "${MODEL_CLASSES[$FILE]}"
done
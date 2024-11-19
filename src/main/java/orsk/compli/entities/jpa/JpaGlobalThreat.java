package orsk.compli.entities.jpa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "global_threats")
public class JpaGlobalThreat {
    @Id
    @Column(name = "threat_id", nullable = false)
    private Integer id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @Column(name = "first_detected", nullable = false)
    private LocalDate firstDetected;

    @Column(name = "last_updated")
    private LocalDate lastUpdated;

    @ColumnDefault("0")
    @Column(name = "severity_level", nullable = false)
    private Integer severityLevel;

    @Column(name = "data_retention_until", nullable = false)
    private Instant dataRetentionUntil;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at")
    private Instant updatedAt;

}
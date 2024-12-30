package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "incident_logs")
public class IncidentLog {
    @Id
    @Column(name = "incident_id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "actor_id", nullable = false)
    private ThreatActor actor;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_id", nullable = false)
    private AttackVector vector;

    @ManyToOne(fetch = FetchType.LAZY)
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JoinColumn(name = "vulnerability_id")
    private Vulnerability vulnerability;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "geolocation_id", nullable = false)
    private GeolocationDatum geolocation;

    @Column(name = "incident_date", nullable = false)
    private Instant incidentDate;

    @Column(name = "target", nullable = false)
    private String target;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "industry_id", nullable = false)
    private Industry industry;

    @Column(name = "impact")
    private String impact;

    @Column(name = "response")
    private String response;

    @Column(name = "response_date")
    private Instant responseDate;

    @Column(name = "data_retention_until", nullable = false)
    private Instant dataRetentionUntil;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "industry")
    private String industry1;

}
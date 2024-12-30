package orsk.compli.entities;

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
@Table(name = "threat_actors")
public class ThreatActor {
    @Id
    @Column(name = "actor_id", nullable = false)
    private Integer id;

    @Column(name = "actor_name", nullable = false)
    private String actorName;



    @Column(name = "motivation")
    private String motivation;

    @Column(name = "capabilities")
    private String capabilities;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_id", nullable = false)
    private ThreatActorType type;

    @Column(name = "description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "origin_country", nullable = false)
    private Country originCountry;

    @Column(name = "first_observed", nullable = false)
    private LocalDate firstObserved;

    @Column(name = "last_activity")
    private LocalDate lastActivity;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private ThreatCategory category;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "type", nullable = false)
    private String type1;

    @ManyToMany
    @JoinTable(
            name = "threat_actor_attack_vector",
            joinColumns = @JoinColumn(name = "threat_actor_id"),
            inverseJoinColumns = @JoinColumn(name = "attack_vector_id")
    )
    private Set<AttackVector> attackVectors = new HashSet<>();
}
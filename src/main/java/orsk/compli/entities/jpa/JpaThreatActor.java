package orsk.compli.entities.jpa;

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
public class JpaThreatActor {
    @Id
    @Column(name = "actor_id", nullable = false)
    private Integer id;

    @Column(name = "name", nullable = false)
    private String name;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "type_id", nullable = false)
    private JpaThreatActorType type;

    @Column(name = "description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "origin_country", nullable = false)
    private JpaCountry originCountry;

    @Column(name = "first_observed", nullable = false)
    private LocalDate firstObserved;

    @Column(name = "last_activity")
    private LocalDate lastActivity;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private JpaThreatCategory category;

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
    private Set<JpaAttackVector> attackVectors = new HashSet<>();

}
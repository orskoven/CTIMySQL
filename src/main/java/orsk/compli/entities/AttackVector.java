package orsk.compli.entities;

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
@Table(name = "attack_vectors")
public class AttackVector {
    @Id
    @Column(name = "vector_id", nullable = false)
    private Integer id;

    @Column(name = "vector_name", nullable = false)
    private String vectorName;

    @Column(name = "description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_category_id", nullable = false)
    private AttackVectorCategory vectorCategory;

    @Column(name = "severity_level")
    private Integer severityLevel;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "category")
    private String category;

    @ManyToMany(mappedBy = "attackVectors")
    private Set<ThreatActor> threatActors = new HashSet<>();
}
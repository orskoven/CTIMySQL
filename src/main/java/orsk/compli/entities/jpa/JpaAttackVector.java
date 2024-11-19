package orsk.compli.entities.jpa;

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
public class JpaAttackVector {
    @Id
    @Column(name = "vector_id", nullable = false)
    private Integer id;

    @Column(name = "name", nullable = false)
    private String name;

    @Column(name = "description")
    private String description;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "vector_category_id", nullable = false)
    private JpaAttackVectorCategory vectorCategory;

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
    private Set<JpaThreatActor> threatActors = new HashSet<>();

}
package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "attack_vector_categories")
public class AttackVectorCategory {
    @Id
    @Column(name = "vector_category_id", nullable = false)
    private Integer id;

    @Column(name = "category_name", nullable = false, length = 100)
    private String categoryName;

    @Lob
    @Column(name = "description")
    private String description;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "updated_at")
    private Instant updatedAt;

}
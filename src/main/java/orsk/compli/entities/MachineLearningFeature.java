package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.util.Map;

@Getter
@Setter
@Entity
@Table(name = "machine_learning_features")
public class MachineLearningFeature {
    @Id
    @Column(name = "feature_id", nullable = false)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "incident_id", nullable = false)
    private IncidentLog incident;

    @Column(name = "feature_vector")
    @JdbcTypeCode(SqlTypes.JSON)
    private Map<String, Object> featureVector;

    @Column(name = "feature_name", nullable = false)
    private String featureName;

    @Column(name = "feature_value", nullable = false)
    private Double featureValue;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

}
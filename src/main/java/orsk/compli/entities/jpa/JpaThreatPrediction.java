package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.ColumnDefault;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import java.time.Instant;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "threat_predictions")
public class JpaThreatPrediction {
    @Id
    @Column(name = "prediction_id", nullable = false)
    private Long id;

    @Column(name = "prediction_date", nullable = false)
    private LocalDate predictionDate;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JoinColumn(name = "threat_id", nullable = false)
    private JpaGlobalThreat threat;

    @Column(name = "probability", nullable = false)
    private Double probability;

    @Column(name = "predicted_impact")
    private String predictedImpact;

    @Column(name = "data_retention_until", nullable = false)
    private Instant dataRetentionUntil;

    @ColumnDefault("CURRENT_TIMESTAMP")
    @Column(name = "created_at")
    private Instant createdAt;

}
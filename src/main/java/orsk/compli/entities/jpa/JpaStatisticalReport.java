package orsk.compli.entities.jpa;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "statistical_reports")
public class JpaStatisticalReport {
    @Id
    @Column(name = "report_id", nullable = false)
    private Long id;

    @Column(name = "content")
    private String content;

    @Column(name = "generated_date", nullable = false)
    private LocalDate generatedDate;

    @Column(name = "report_type", nullable = false)
    private String reportType;

}
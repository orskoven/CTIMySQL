package orsk.compli.repository.jpa;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.GlobalThreat;

import java.time.LocalDate;
import java.util.List;

@Repository("GlobalThreatJpaRepository")
public interface GlobalThreatJpaRepository extends JpaRepository<GlobalThreat, Long>, JpaSpecificationExecutor<GlobalThreat> {
    @Query("SELECT g.name FROM GlobalThreat g")
    List<String> findAllThreatNames();

    // Find global threats active within a date range
    List<GlobalThreat> findByFirstDetectedBetween(LocalDate startDate, LocalDate endDate);

    // Find threats by severity level
    List<GlobalThreat> findBySeverityLevelGreaterThanEqual(int level);

    // Custom query using Specifications
    static Specification<GlobalThreat> isActive() {
        return (root, query, cb) -> cb.greaterThan(root.get("dataRetentionUntil"), LocalDate.now());
    }

    // Custom Specification for severity level
    static Specification<GlobalThreat> hasSeverityLevel(int level) {
        return (root, query, cb) -> cb.ge(root.get("severityLevel"), level);
    }
}

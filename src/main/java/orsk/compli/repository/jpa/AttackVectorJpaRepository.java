package orsk.compli.repository.jpa;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.AttackVector;

import java.util.List;

@Repository("AttackVectorJpaRepository")
public interface AttackVectorJpaRepository extends JpaRepository<AttackVector, Long>, JpaSpecificationExecutor<AttackVector> {

    // Find attack vectors by severity level
    List<AttackVector> findBySeverityLevelGreaterThanEqual(int level);

    // Find attack vectors by category name
    List<AttackVector> findByCategory(String categoryName);

    // Custom Specification for dynamic querying
    static Specification<AttackVector> hasSeverityLevel(int level) {
        return (root, query, cb) -> cb.ge(root.get("severityLevel"), level);
    }

    // Custom Specification for category
    static Specification<AttackVector> hasCategory(String categoryName) {
        return (root, query, cb) -> cb.equal(root.join("category").get("name"), categoryName);
    }
}

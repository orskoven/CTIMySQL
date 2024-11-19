package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaThreatCategory;

@Repository("ThreatCategoryJpaRepository")
public interface ThreatCategoryJpaRepository extends JpaRepository<JpaThreatCategory, Long>, JpaSpecificationExecutor<JpaThreatCategory> {

}

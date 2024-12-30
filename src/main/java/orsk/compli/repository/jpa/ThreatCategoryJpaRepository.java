package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.ThreatCategory;

@Repository("ThreatCategoryJpaRepository")
public interface ThreatCategoryJpaRepository extends JpaRepository<ThreatCategory, Long>, JpaSpecificationExecutor<ThreatCategory> {

}

package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.ThreatActorType;

@Repository("ThreatActorTypeJpaRepository")
public interface ThreatActorTypeJpaRepository extends JpaRepository<ThreatActorType, Long> {

}

package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaGeolocation;

@Repository("GeolocationJpaRepository")
public interface GeolocationJpaRepository extends JpaRepository<JpaGeolocation, Long>, JpaSpecificationExecutor<JpaGeolocation> {

}

package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.Geolocation;

@Repository("GeolocationJpaRepository")
public interface GeolocationJpaRepository extends JpaRepository<Geolocation, Long>, JpaSpecificationExecutor<Geolocation> {

}

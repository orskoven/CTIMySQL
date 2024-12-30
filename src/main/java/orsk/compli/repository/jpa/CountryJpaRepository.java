package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.Country;

import java.util.List;

@Repository("CountryJpaRepository")
public interface CountryJpaRepository extends JpaRepository<Country, Long>, JpaSpecificationExecutor<Country> {
    @Query("SELECT c.countryName FROM Country c")
    List<String> findAllCountryNames();

}

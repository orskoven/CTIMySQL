package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaCountry;

import java.util.List;

@Repository("CountryJpaRepository")
public interface CountryJpaRepository extends JpaRepository<JpaCountry, Long>, JpaSpecificationExecutor<JpaCountry> {
    @Query("SELECT c.countryName FROM JpaCountry c")
    List<String> findAllCountryNames();

}

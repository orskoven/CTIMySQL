package orsk.compli.repository.jpa;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaThreatActor;

import java.util.List;

@Repository("ThreatActorJpaRepository")
public interface ThreatActorJpaRepository extends JpaRepository<JpaThreatActor, Long>, JpaSpecificationExecutor<JpaThreatActor> {

    // Find threat actors by type
    List<JpaThreatActor> findByName(String typeName);

    // Find threat actors by origin country
    List<JpaThreatActor> findByOriginCountryCountryCode(String countryCode);

    // Fetch threat actors with their attack vectors eagerly using a custom query
    @Query("SELECT t FROM JpaThreatActor t LEFT JOIN FETCH t.attackVectors")
    List<JpaThreatActor> findAllActorsWithAttackVectors();

    // Custom Specification for dynamic querying
    static Specification<JpaThreatActor> hasType(String typeName) {
        return (root, query, cb) -> cb.equal(root.join("type").get("name"), typeName);
    }

    // Custom Specification for country
    static Specification<JpaThreatActor> hasOriginCountry(String countryCode) {
        return (root, query, cb) -> cb.equal(root.join("originCountry").get("code"), countryCode);
    }
}
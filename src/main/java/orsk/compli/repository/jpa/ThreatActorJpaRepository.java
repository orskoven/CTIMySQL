package orsk.compli.repository.jpa;

import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.ThreatActor;

import java.util.List;

@Repository("ThreatActorJpaRepository")
public interface ThreatActorJpaRepository extends JpaRepository<ThreatActor, Long>, JpaSpecificationExecutor<ThreatActor> {

    // Find threat actors by type
    List<ThreatActor> findByActorName(String typeName);

    // Find threat actors by origin country
    List<ThreatActor> findByOriginCountryCountryCode(String countryCode);

    // Fetch threat actors with their attack vectors eagerly using a custom query
    @Query("SELECT t FROM ThreatActor t LEFT JOIN FETCH t.attackVectors")
    List<ThreatActor> findAllActorsWithAttackVectors();

    // Custom Specification for dynamic querying
    static Specification<ThreatActor> hasType(String typeName) {
        return (root, query, cb) -> cb.equal(root.join("type").get("name"), typeName);
    }

    // Custom Specification for country
    static Specification<ThreatActor> hasOriginCountry(String countryCode) {
        return (root, query, cb) -> cb.equal(root.join("originCountry").get("code"), countryCode);
    }
}
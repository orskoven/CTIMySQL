package orsk.compli.repository.jpa;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.AffectedProduct;

import java.util.List;

@Repository("jpaAffectedProductRepository")
public interface AffectedProductJpaRepository extends JpaRepository<AffectedProduct, Long>, JpaSpecificationExecutor<AffectedProduct> {

    @Query("SELECT a.productName FROM AffectedProduct a")
    List<String> findAllProductNames();

    // Find products by vendor with pagination support
    Page<AffectedProduct> findByVendor(String vendor, Pageable pageable);

    // Find products by name
    List<AffectedProduct> findByProductNameContainingIgnoreCase(String name);

    // Custom Specification for advanced querying
    static Specification<AffectedProduct> hasVendor(String vendor) {
        return (root, query, cb) -> cb.equal(root.get("vendor"), vendor);
    }

    // Custom Specification for product version
    static Specification<AffectedProduct> hasVersion(String version) {
        return (root, query, cb) -> cb.equal(root.get("version"), version);
    }
}

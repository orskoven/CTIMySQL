package orsk.compli.repository.jpa;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaAffectedProduct;

import java.util.List;

@Repository("jpaAffectedProductRepository")
public interface AffectedProductJpaRepository extends JpaRepository<JpaAffectedProduct, Long>, JpaSpecificationExecutor<JpaAffectedProduct> {

    @Query("SELECT a.productName FROM JpaAffectedProduct a")
    List<String> findAllProductNames();

    // Find products by vendor with pagination support
    Page<JpaAffectedProduct> findByVendor(String vendor, Pageable pageable);

    // Find products by name
    List<JpaAffectedProduct> findByProductNameContainingIgnoreCase(String name);

    // Custom Specification for advanced querying
    static Specification<JpaAffectedProduct> hasVendor(String vendor) {
        return (root, query, cb) -> cb.equal(root.get("vendor"), vendor);
    }

    // Custom Specification for product version
    static Specification<JpaAffectedProduct> hasVersion(String version) {
        return (root, query, cb) -> cb.equal(root.get("version"), version);
    }
}


package orsk.compli.service.jpa;

import jakarta.persistence.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.AffectedProduct;
import orsk.compli.repository.jpa.AffectedProductJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaAffectedProductService")
public class AffectedProductJpaService extends AbstractGenericService<AffectedProduct, String>{

    private static final Logger LOGGER = LoggerFactory.getLogger(AffectedProductJpaService.class);

    private final AffectedProductJpaRepository affectedProductRepository;

    @Autowired
    public AffectedProductJpaService(AffectedProductJpaRepository affectedProductRepository) {
        this.affectedProductRepository = affectedProductRepository;
    }

    @Override
    @Transactional
    public AffectedProduct create(AffectedProduct entity) {
        LOGGER.info("Creating Affected Product: {}", entity);
        return affectedProductRepository.save(entity);
    }

    @Override
    public List<AffectedProduct> createBatch(List<AffectedProduct> entities) {
        return List.of();
    }

    @Override
    public List<AffectedProduct> getAll() {
        LOGGER.info("Retrieving all Affected Products");
        return affectedProductRepository.findAll();
    }

    @Override
    public Optional<AffectedProduct> getById(Long id) {
        LOGGER.info("Retrieving Affected Product with ID: {}", id);
        return affectedProductRepository.findById(id);
    }

    @Override
    @Transactional
    public AffectedProduct update(Long id, AffectedProduct entity) {
        LOGGER.info("Updating Affected Product with ID: {}", id);
        return affectedProductRepository.findById(id)
                .map(existing -> {
                    existing.setProductName(entity.getProductName());
                    existing.setVendor(entity.getVendor());
                    existing.setVersion(entity.getVersion());
                    // Add other field mappings as necessary
                    return affectedProductRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Affected Product not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Affected Product with ID: {}", id);
        if (affectedProductRepository.existsById(id)) {
            affectedProductRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Affected Product with ID: {} not found for deletion", id);
        return false;
    }

}


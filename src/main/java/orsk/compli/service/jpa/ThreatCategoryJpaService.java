
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.ThreatCategory;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.ThreatCategoryJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaThreatCategoryService")
public class ThreatCategoryJpaService implements CrudService<ThreatCategory, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ThreatCategoryJpaService.class);

    private final ThreatCategoryJpaRepository threatCategoryRepository;

    @Autowired
    public ThreatCategoryJpaService(ThreatCategoryJpaRepository threatCategoryRepository) {
        this.threatCategoryRepository = threatCategoryRepository;
    }

    @Override
    @Transactional
    public ThreatCategory create(ThreatCategory entity) {
        LOGGER.info("Creating Threat Category: {}", entity);
        return threatCategoryRepository.save(entity);
    }

    @Override
    public List<ThreatCategory> createBatch(List<ThreatCategory> entities) {
        return List.of();
    }

    @Override
    public List<ThreatCategory> getAll() {
        LOGGER.info("Retrieving all Threat Categories");
        return threatCategoryRepository.findAll();
    }

    @Override
    public Optional<ThreatCategory> getById(Long id) {
        LOGGER.info("Retrieving Threat Category with ID: {}", id);
        return threatCategoryRepository.findById(id);
    }

    @Override
    @Transactional
    public ThreatCategory update(Long id, ThreatCategory entity) {
        LOGGER.info("Updating Threat Category with ID: {}", id);
        return threatCategoryRepository.findById(id)
                .map(existing -> {
                    existing.setCategoryName(entity.getCategoryName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return threatCategoryRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Threat Category not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Threat Category with ID: {}", id);
        if (threatCategoryRepository.existsById(id)) {
            threatCategoryRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Threat Category with ID: {} not found for deletion", id);
        return false;
    }
}


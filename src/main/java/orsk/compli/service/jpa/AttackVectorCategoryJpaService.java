
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.AttackVectorCategory;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.AttackVectorCategoryJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaAttackVectorCategoryService")
public class AttackVectorCategoryJpaService implements CrudService<AttackVectorCategory, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(AttackVectorCategoryJpaService.class);

    private final AttackVectorCategoryJpaRepository attackVectorCategoryRepository;

    @Autowired
    public AttackVectorCategoryJpaService(AttackVectorCategoryJpaRepository attackVectorCategoryRepository) {
        this.attackVectorCategoryRepository = attackVectorCategoryRepository;
    }

    @Override
    @Transactional
    public AttackVectorCategory create(AttackVectorCategory entity) {
        LOGGER.info("Creating Attack Vector Category: {}", entity);
        return attackVectorCategoryRepository.save(entity);
    }

    @Override
    public List<AttackVectorCategory> createBatch(List<AttackVectorCategory> entities) {
        return List.of();
    }

    @Override
    public List<AttackVectorCategory> getAll() {
        LOGGER.info("Retrieving all Attack Vector Categories");
        return attackVectorCategoryRepository.findAll();
    }

    @Override
    public Optional<AttackVectorCategory> getById(Long id) {
        LOGGER.info("Retrieving Attack Vector Category with ID: {}", id);
        return attackVectorCategoryRepository.findById(id);
    }

    @Override
    @Transactional
    public AttackVectorCategory update(Long id, AttackVectorCategory entity) {
        LOGGER.info("Updating Attack Vector Category with ID: {}", id);
        return attackVectorCategoryRepository.findById(id)
                .map(existing -> {
                    existing.setCategoryName(entity.getCategoryName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return attackVectorCategoryRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Attack Vector Category not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Attack Vector Category with ID: {}", id);
        if (attackVectorCategoryRepository.existsById(id)) {
            attackVectorCategoryRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Attack Vector Category with ID: {} not found for deletion", id);
        return false;
    }
}


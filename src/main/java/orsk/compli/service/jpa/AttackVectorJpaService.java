
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.AttackVector;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.AttackVectorJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaAttackVectorService")
public class AttackVectorJpaService implements CrudService<AttackVector, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(AttackVectorJpaService.class);

    private final AttackVectorJpaRepository attackVectorRepository;

    @Autowired
    public AttackVectorJpaService(AttackVectorJpaRepository attackVectorRepository) {
        this.attackVectorRepository = attackVectorRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_USER')")
    public AttackVector create(AttackVector entity) {
        LOGGER.info("Creating Attack Vector: {}", entity);
        return attackVectorRepository.save(entity);
    }

    @Override
    public List<AttackVector> createBatch(List<AttackVector> entities) {
        LOGGER.info("Creating batch of all Attack Vectors");
        return List.of();
    }

    @Override
    public List<AttackVector> getAll() {
        LOGGER.info("Retrieving all Attack Vectors");
        return attackVectorRepository.findAll();
    }

    @Override
    public Optional<AttackVector> getById(Long id) {
        LOGGER.info("Retrieving Attack Vector with ID: {}", id);
        return attackVectorRepository.findById(id);
    }

    @Override
    @Transactional
    public AttackVector update(Long id, AttackVector entity) {
        LOGGER.info("Updating Attack Vector with ID: {}", id);
        return attackVectorRepository.findById(id)
                .map(existing -> {
                    existing.setVectorName(entity.getVectorName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return attackVectorRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Attack Vector not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Attack Vector with ID: {}", id);
        if (attackVectorRepository.existsById(id)) {
            attackVectorRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Attack Vector with ID: {} not found for deletion", id);
        return false;
    }
}


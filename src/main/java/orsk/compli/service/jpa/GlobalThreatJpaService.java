package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaGlobalThreat;
import orsk.compli.repository.jpa.GlobalThreatJpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * Service class for managing JpaGlobalThreat entities.
 */
@Service("jpaGlobalThreatService")
public class GlobalThreatJpaService implements CrudService<JpaGlobalThreat, Long> {

    private final GlobalThreatJpaRepository globalThreatJpaRepository;

    @Autowired
    public GlobalThreatJpaService(GlobalThreatJpaRepository globalThreatJpaRepository) {
        this.globalThreatJpaRepository = globalThreatJpaRepository;
    }

    /**
     * Creates a new JpaGlobalThreat entity.
     *
     * @param entity the entity to create
     * @return the created entity
     */
    @Override
    public JpaGlobalThreat create(JpaGlobalThreat entity) {
        return globalThreatJpaRepository.save(entity);
    }

    /**
     * Retrieves all JpaGlobalThreat entities.
     *
     * @return a list of all entities
     */
    @Override
    public List<JpaGlobalThreat> getAll() {
        return globalThreatJpaRepository.findAll();
    }

    /**
     * Retrieves a JpaGlobalThreat entity by its ID.
     *
     * @param id the ID of the entity
     * @return an Optional containing the entity if found, or empty otherwise
     */
    @Override
    public Optional<JpaGlobalThreat> getById(Long id) {
        return globalThreatJpaRepository.findById(id);
    }

    /**
     * Updates an existing JpaGlobalThreat entity.
     *
     * @param id     the ID of the entity to update
     * @param entity the entity with updated values
     * @return the updated entity
     * @throws RuntimeException if the entity with the given ID is not found
     */
    @Override
    public JpaGlobalThreat update(Long id, JpaGlobalThreat entity) {
        // Update fields of existingEntity with values from entity
        //existingEntity.setField1(entity.getField1());
        //existingEntity.setField2(entity.getField2());
        // Add more field mappings as necessary
        return globalThreatJpaRepository.findById(id)
                .map(globalThreatJpaRepository::save)
                .orElseThrow(() -> new RuntimeException("Entity not found with id " + id));
    }

    /**
     * Deletes a JpaGlobalThreat entity by its ID.
     *
     * @param id the ID of the entity to delete
     * @return true if the entity was deleted, false otherwise
     */
    @Override
    public boolean delete(Long id) {
        if (globalThreatJpaRepository.existsById(id)) {
            globalThreatJpaRepository.deleteById(id);
            return true;
        }
        return false;
    }
}


package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.GlobalThreat;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.GlobalThreatJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaGlobalThreatService")
public class GlobalThreatJpaService implements CrudService<GlobalThreat, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(GlobalThreatJpaService.class);

    private final GlobalThreatJpaRepository globalThreatRepository;

    @Autowired
    public GlobalThreatJpaService(GlobalThreatJpaRepository globalThreatRepository) {
        this.globalThreatRepository = globalThreatRepository;
    }

    @Override
    @Transactional
    public GlobalThreat create(GlobalThreat entity) {
        LOGGER.info("Creating Global Threat: {}", entity);
        return globalThreatRepository.save(entity);
    }

    @Override
    public List<GlobalThreat> createBatch(List<GlobalThreat> entities) {
        return List.of();
    }

    @Override
    public List<GlobalThreat> getAll() {
        LOGGER.info("Retrieving all Global Threats");
        return globalThreatRepository.findAll();
    }

    @Override
    public Optional<GlobalThreat> getById(Long id) {
        LOGGER.info("Retrieving Global Threat with ID: {}", id);
        return globalThreatRepository.findById(id);
    }

    @Override
    @Transactional
    public GlobalThreat update(Long id, GlobalThreat entity) {
        LOGGER.info("Updating Global Threat with ID: {}", id);
        return globalThreatRepository.findById(id)
                .map(existing -> {
                    existing.setName(entity.getName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return globalThreatRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Global Threat not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Global Threat with ID: {}", id);
        if (globalThreatRepository.existsById(id)) {
            globalThreatRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Global Threat with ID: {} not found for deletion", id);
        return false;
    }
}


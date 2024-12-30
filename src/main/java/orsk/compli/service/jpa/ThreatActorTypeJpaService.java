
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.ThreatActorType;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.ThreatActorTypeJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaThreatActorTypeService")
public class ThreatActorTypeJpaService implements CrudService<ThreatActorType, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ThreatActorTypeJpaService.class);

    private final ThreatActorTypeJpaRepository threatActorTypeRepository;

    @Autowired
    public ThreatActorTypeJpaService(ThreatActorTypeJpaRepository threatActorTypeRepository) {
        this.threatActorTypeRepository = threatActorTypeRepository;
    }

    @Override
    @Transactional
    public ThreatActorType create(ThreatActorType entity) {
        LOGGER.info("Creating Threat Actor Type: {}", entity);
        return threatActorTypeRepository.save(entity);
    }

    @Override
    public List<ThreatActorType> createBatch(List<ThreatActorType> entities) {
        return List.of();
    }

    @Override
    public List<ThreatActorType> getAll() {
        LOGGER.info("Retrieving all Threat Actor Types");
        return threatActorTypeRepository.findAll();
    }

    @Override
    public Optional<ThreatActorType> getById(Long id) {
        LOGGER.info("Retrieving Threat Actor Type with ID: {}", id);
        return threatActorTypeRepository.findById(id);
    }

    @Override
    @Transactional
    public ThreatActorType update(Long id, ThreatActorType entity) {
        LOGGER.info("Updating Threat Actor Type with ID: {}", id);
        return threatActorTypeRepository.findById(id)
                .map(existing -> {
                    existing.setTypeName(entity.getTypeName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return threatActorTypeRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Threat Actor Type not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Threat Actor Type with ID: {}", id);
        if (threatActorTypeRepository.existsById(id)) {
            threatActorTypeRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Threat Actor Type with ID: {} not found for deletion", id);
        return false;
    }
}


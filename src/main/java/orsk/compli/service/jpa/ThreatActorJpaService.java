
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.ThreatActor;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.ThreatActorJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaThreatActorService")
public class ThreatActorJpaService implements CrudService<ThreatActor, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ThreatActorJpaService.class);

    private final ThreatActorJpaRepository threatActorRepository;

    @Autowired
    public ThreatActorJpaService(ThreatActorJpaRepository threatActorRepository) {
        this.threatActorRepository = threatActorRepository;
    }

    @Override
    @Transactional
    public ThreatActor create(ThreatActor entity) {
        LOGGER.info("Creating Threat Actor: {}", entity);
        return threatActorRepository.save(entity);
    }

    @Override
    public List<ThreatActor> createBatch(List<ThreatActor> entities) {
        return List.of();
    }

    @Override
    public List<ThreatActor> getAll() {
        LOGGER.info("Retrieving all Threat Actors");
        return threatActorRepository.findAll();
    }

    @Override
    public Optional<ThreatActor> getById(Long id) {
        LOGGER.info("Retrieving Threat Actor with ID: {}", id);
        return threatActorRepository.findById(id);
    }

    @Override
    @Transactional
    public ThreatActor update(Long id, ThreatActor entity) {
        LOGGER.info("Updating Threat Actor with ID: {}", id);
        return threatActorRepository.findById(id)
                .map(existing -> {
                    existing.setActorName(entity.getActorName());
                    existing.setMotivation(entity.getMotivation());
                    existing.setCapabilities(entity.getCapabilities());
                    // Add other field mappings as necessary
                    return threatActorRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Threat Actor not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Threat Actor with ID: {}", id);
        if (threatActorRepository.existsById(id)) {
            threatActorRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Threat Actor with ID: {} not found for deletion", id);
        return false;
    }
}


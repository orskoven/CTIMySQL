package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaThreatActor;
import orsk.compli.repository.jpa.ThreatActorJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaThreatActorService")
public class ThreatActorJpaService implements CrudService<JpaThreatActor, Long> {

    private final ThreatActorJpaRepository threatActorServiceRepository;

    @Autowired
    public ThreatActorJpaService(ThreatActorJpaRepository threatActorServiceRepository) {
        this.threatActorServiceRepository = threatActorServiceRepository;
    }

    @Override
    public JpaThreatActor create(JpaThreatActor entity) {
        return threatActorServiceRepository.save(entity);
    }

    @Override
    public List<JpaThreatActor> getAll() {
        return threatActorServiceRepository.findAll();
    }

    @Override
    public Optional<JpaThreatActor> getById(Long id) {
        return threatActorServiceRepository.findById(id);
    }

    @Override
    public JpaThreatActor update(Long id, JpaThreatActor entity) {
        Optional<JpaThreatActor> optionalEntity = threatActorServiceRepository.findById(id);
        if (optionalEntity.isPresent()) {
            JpaThreatActor existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return threatActorServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (threatActorServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            threatActorServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

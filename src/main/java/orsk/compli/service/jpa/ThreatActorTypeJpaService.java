package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaThreatActorType;
import orsk.compli.repository.jpa.ThreatActorTypeJpaRepository;

import java.util.List;
import java.util.Optional;

@Service()
public class ThreatActorTypeJpaService implements CrudService<JpaThreatActorType, Long> {

    private final ThreatActorTypeJpaRepository threatActorTypeServiceRepository;

    @Autowired
    public ThreatActorTypeJpaService(ThreatActorTypeJpaRepository threatActorTypeServiceRepository) {
        this.threatActorTypeServiceRepository = threatActorTypeServiceRepository;
    }

    @Override
    public JpaThreatActorType create(JpaThreatActorType entity) {
        return threatActorTypeServiceRepository.save(entity);
    }

    @Override
    public List<JpaThreatActorType> getAll() {
        return threatActorTypeServiceRepository.findAll();
    }

    @Override
    public Optional<JpaThreatActorType> getById(Long id) {
        return threatActorTypeServiceRepository.findById(Long.valueOf(String.valueOf(id)));
    }

    @Override
    public JpaThreatActorType update(Long id, JpaThreatActorType entity) {
        Optional<JpaThreatActorType> optionalEntity = threatActorTypeServiceRepository.findById(Long.valueOf(String.valueOf(id)));
        if (optionalEntity.isPresent()) {
            JpaThreatActorType existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return threatActorTypeServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (threatActorTypeServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            threatActorTypeServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaThreatCategory;
import orsk.compli.repository.jpa.ThreatCategoryJpaRepository;

import java.util.List;
import java.util.Optional;

@Service()
public class ThreatCategoryJpaService implements CrudService<JpaThreatCategory, Long> {

    private final ThreatCategoryJpaRepository threatCategoryServiceRepository;

    @Autowired
    public ThreatCategoryJpaService(ThreatCategoryJpaRepository threatCategoryServiceRepository) {
        this.threatCategoryServiceRepository = threatCategoryServiceRepository;
    }

    @Override
    public JpaThreatCategory create(JpaThreatCategory entity) {
        return threatCategoryServiceRepository.save(entity);
    }

    @Override
    public List<JpaThreatCategory> getAll() {
        return threatCategoryServiceRepository.findAll();
    }

    @Override
    public Optional<JpaThreatCategory> getById(Long id) {
        return threatCategoryServiceRepository.findById(Long.valueOf(String.valueOf(id)));
    }

    @Override
    public JpaThreatCategory update(Long id, JpaThreatCategory entity) {
        Optional<JpaThreatCategory> optionalEntity = threatCategoryServiceRepository.findById(Long.valueOf(String.valueOf(id)));
        if (optionalEntity.isPresent()) {
            JpaThreatCategory existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return threatCategoryServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (threatCategoryServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            threatCategoryServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

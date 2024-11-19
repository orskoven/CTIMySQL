package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaAffectedProduct;
import orsk.compli.repository.jpa.AffectedProductJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaAffectedProductService")
public class AffectedProductJpaService implements CrudService<JpaAffectedProduct, Long> {

    private final AffectedProductJpaRepository affectedProductServiceRepository;

    @Autowired
    public AffectedProductJpaService(AffectedProductJpaRepository affectedProductServiceRepository) {
        this.affectedProductServiceRepository = affectedProductServiceRepository;
    }

    @Override
    public JpaAffectedProduct create(JpaAffectedProduct entity) {
        return affectedProductServiceRepository.save(entity);
    }

    @Override
    public List<JpaAffectedProduct> getAll() {
        return affectedProductServiceRepository.findAll();
    }

    @Override
    public Optional<JpaAffectedProduct> getById(Long id) {
        return affectedProductServiceRepository.findById(Long.valueOf(String.valueOf(id)));
    }

    @Override
    public JpaAffectedProduct update(Long id, JpaAffectedProduct entity) {
        Optional<JpaAffectedProduct> optionalEntity = affectedProductServiceRepository.findById(Long.valueOf(String.valueOf(id)));
        if (optionalEntity.isPresent()) {
            JpaAffectedProduct existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return affectedProductServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (affectedProductServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            affectedProductServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

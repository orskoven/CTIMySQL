package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaAttackVectorCategory;
import orsk.compli.repository.jpa.AttackVectorCategoryJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaAttackVectorCategoryService")
public class AttackVectorCategoryJpaService implements CrudService<JpaAttackVectorCategory, Long> {

    private final AttackVectorCategoryJpaRepository attackVectorCategoryServiceRepository;

    @Autowired
    public AttackVectorCategoryJpaService(AttackVectorCategoryJpaRepository attackVectorCategoryServiceRepository) {
        this.attackVectorCategoryServiceRepository = attackVectorCategoryServiceRepository;
    }

    @Override
    public JpaAttackVectorCategory create(JpaAttackVectorCategory entity) {
        return attackVectorCategoryServiceRepository.save(entity);
    }

    @Override
    public List<JpaAttackVectorCategory> getAll() {
        return attackVectorCategoryServiceRepository.findAll();
    }

    @Override
    public Optional<JpaAttackVectorCategory> getById(Long id) {
        return attackVectorCategoryServiceRepository.findById(Long.valueOf(String.valueOf(id)));
    }

    @Override
    public JpaAttackVectorCategory update(Long id, JpaAttackVectorCategory entity) {
        Optional<JpaAttackVectorCategory> optionalEntity = attackVectorCategoryServiceRepository.findById(Long.valueOf(String.valueOf(id)));
        if (optionalEntity.isPresent()) {
            JpaAttackVectorCategory existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return attackVectorCategoryServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (attackVectorCategoryServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            attackVectorCategoryServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

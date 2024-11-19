package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaAttackVector;
import orsk.compli.repository.jpa.AttackVectorJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaAttackVectorService")
public class AttackVectorJpaService implements CrudService<JpaAttackVector, Long> {

    private final AttackVectorJpaRepository attackVectorServiceRepository;

    @Autowired
    public AttackVectorJpaService(AttackVectorJpaRepository attackVectorServiceRepository) {
        this.attackVectorServiceRepository = attackVectorServiceRepository;
    }

    @Override
    public JpaAttackVector create(JpaAttackVector entity) {
        return attackVectorServiceRepository.save(entity);
    }

    @Override
    public List<JpaAttackVector> getAll() {
        return attackVectorServiceRepository.findAll();
    }

    @Override
    public Optional<JpaAttackVector> getById(Long id) {
        return attackVectorServiceRepository.findById(Long.valueOf(String.valueOf(id)));
    }

    @Override
    public JpaAttackVector update(Long id, JpaAttackVector entity) {
        Optional<JpaAttackVector> optionalEntity = attackVectorServiceRepository.findById(Long.valueOf(String.valueOf(id)));
        if (optionalEntity.isPresent()) {
            JpaAttackVector existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return attackVectorServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (attackVectorServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            attackVectorServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

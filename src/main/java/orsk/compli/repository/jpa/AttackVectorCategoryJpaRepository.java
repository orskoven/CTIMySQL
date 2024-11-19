package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaAttackVectorCategory;

@Repository("AttackVectorCategoryJpaRepository")
public interface AttackVectorCategoryJpaRepository extends JpaRepository<JpaAttackVectorCategory, Long> {

}

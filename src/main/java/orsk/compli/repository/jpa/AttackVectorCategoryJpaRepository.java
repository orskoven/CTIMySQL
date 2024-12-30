package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.AttackVectorCategory;

@Repository("AttackVectorCategoryJpaRepository")
public interface AttackVectorCategoryJpaRepository extends JpaRepository<AttackVectorCategory, Long> {

}

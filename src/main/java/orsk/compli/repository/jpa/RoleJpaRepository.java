package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaRole;

import java.util.Optional;

@Repository("RoleJpaRepository")
public interface RoleJpaRepository extends JpaRepository<JpaRole, Long> {
    Optional<JpaRole> findByName(String name);
}

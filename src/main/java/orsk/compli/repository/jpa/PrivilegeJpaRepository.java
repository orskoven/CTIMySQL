package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.JpaPrivilege;

import java.util.Optional;

@Repository("PrivilegeJpaRepository")
public interface PrivilegeJpaRepository extends JpaRepository<JpaPrivilege, Long> {
    Optional<JpaPrivilege> findByName(String name);
}

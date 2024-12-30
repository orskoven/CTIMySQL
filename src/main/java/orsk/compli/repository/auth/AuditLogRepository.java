package orsk.compli.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.AuditLog;

@Repository("AuditLogJpaRepository")
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {
}
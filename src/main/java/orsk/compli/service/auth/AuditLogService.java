package orsk.compli.service.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.AuditLog;
import orsk.compli.repository.auth.AuditLogRepository;
import orsk.compli.entities.User;


import java.time.Instant;

@Service("AuditLogService")
public class AuditLogService {

    @Autowired
    private AuditLogRepository auditLogRepository;

    public void logAction(User user, String action, String ipAddress, String details) {
        AuditLog auditLog = new AuditLog();
        auditLog.setUser(user);
        auditLog.setAction(action);
        auditLog.setIpAddress(ipAddress);
        auditLog.setTimestamp(Instant.now());
        auditLog.setDetails(details);
        auditLogRepository.save(auditLog);
    }
}
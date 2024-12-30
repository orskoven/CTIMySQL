// src/test/java/orsk/authmodule/tests/AuditLogServiceTest.java
package auth.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import orsk.authmodule.model.AuditLog;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.AuditLogRepository;
import orsk.authmodule.service.AuditLogService;

import static org.mockito.Mockito.*;

public class AuditLogServiceTest {

    @InjectMocks
    private AuditLogService auditLogService;

    @Mock
    private AuditLogRepository auditLogRepository;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    @DisplayName("Log User Action Successfully")
    public void testLogAction_Success() {
        User user = new User();
        user.setUsername("auditUser");

        auditLogService.logAction(user, "TEST_ACTION", "127.0.0.1", "Test details");

        verify(auditLogRepository, times(1)).save(any(AuditLog.class));
    }

    // Additional audit log tests...
}
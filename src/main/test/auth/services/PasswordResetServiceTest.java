// src/test/java/orsk/authmodule/services/PasswordResetServiceTest.java
package auth.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.security.crypto.password.PasswordEncoder;
import orsk.authmodule.dto.PasswordResetRequest;
import orsk.authmodule.exceptions.EmailNotFoundException;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.PasswordResetTokenRepository;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.service.AuditLogService;
import orsk.authmodule.service.AuthService;

import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.Mockito.*;

public class PasswordResetServiceTest {

    @InjectMocks
    private AuthService authService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordResetTokenRepository passwordResetTokenRepository;

    @Mock
    private RoleRepository roleRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private AuditLogService auditLogService;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        Role userRole = new Role();
        userRole.setName("ROLE_USER");
        when(roleRepository.findByName("ROLE_USER")).thenReturn(Optional.of(userRole));
    }

    @Test
    @DisplayName("Initiate Password Reset Successfully")
    public void testInitiatePasswordReset_Success() {
        PasswordResetRequest request = new PasswordResetRequest();
        request.setEmail("testuser@example.com");

        User user = new User();
        user.setUsername("testuser");
        user.setEmail("testuser@example.com");
        user.setEnabled(true);
        user.setRoles(Set.of(roleRepository.findByName("ROLE_USER").get()));

        when(userRepository.findByEmail("testuser@example.com")).thenReturn(Optional.of(user));

        assertDoesNotThrow(() -> authService.initiatePasswordReset(request));

        verify(passwordResetTokenRepository, times(1)).save(any());
        verify(auditLogService, times(1)).logAction(eq(user), eq("PASSWORD_RESET_INITIATED"), any(), eq("Password reset initiated"));
    }

    @Test
    @DisplayName("Initiate Password Reset with Non-Existent Email")
    public void testInitiatePasswordReset_EmailNotFound() {
        PasswordResetRequest request = new PasswordResetRequest();
        request.setEmail("nonexistent@example.com");

        when(userRepository.findByEmail("nonexistent@example.com")).thenReturn(Optional.empty());

        EmailNotFoundException exception = assertThrows(EmailNotFoundException.class, () -> authService.initiatePasswordReset(request));
        assertEquals("Email not found", exception.getMessage());

        verify(passwordResetTokenRepository, never()).save(any());
        verify(auditLogService, never()).logAction(any(), any(), any(), any());
    }

    // Additional password reset tests...
}
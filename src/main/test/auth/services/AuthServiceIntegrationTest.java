package auth.services;

import org.hibernate.Hibernate;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import orsk.authmodule.dto.RegistrationRequest;
import orsk.authmodule.exceptions.UserAlreadyExistsException;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.service.AuditLogService;
import orsk.authmodule.service.AuthService;

import java.util.Optional;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
class AuthServiceIntegrationTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Mock
    private AuditLogService auditLogService;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);

        userRepository.deleteAll();
        roleRepository.deleteAll();

        // Save ROLE_USER to the database
        Role userRole = new Role();
        userRole.setName("ROLE_USER");
        roleRepository.save(userRole);
    }

    @Test
    @DisplayName("Integration Test: Register User Successfully")
    public void testRegisterUser_Success() {
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("integrationUser");
        request.setEmail("integration@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        assertDoesNotThrow(() -> authService.registerUser(request));

        // Fetch user from the repository and initialize roles
        User user = userRepository.findByEmailWithRoles("integration@example.com")
                .orElseThrow(() -> new RuntimeException("User not found"));
        // Initialize lazy-loaded roles
        Hibernate.initialize(user.getRoles());

        assertEquals("integrationUser", user.getUsername());
        assertTrue(passwordEncoder.matches("StrongPassword@123", user.getPassword()));
        assertFalse(user.getEnabled());
        assertTrue(user.getRoles().stream().anyMatch(role -> "ROLE_USER".equals(role.getName())));
        // Verify audit logging
        verify(auditLogService, times(1)).logAction(eq(user), eq("USER_REGISTERED"), anyString(), anyString());
    }

    @Test
    @DisplayName("Integration Test: Register User with Existing Username")
    void testRegisterUser_ExistingUsername() {
        // Arrange
        User existingUser = new User();
        existingUser.setUsername("existingUser");
        existingUser.setEmail("existing@example.com");
        existingUser.setPassword(passwordEncoder.encode("password123"));
        existingUser.setEnabled(true);
        existingUser.setConsentToDataUsage(true);
        existingUser.setRoles(Set.of(roleRepository.findByName("ROLE_USER").get()));
        userRepository.save(existingUser);

        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("existingUser"); // Same username as existingUser
        request.setEmail("newemail@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        // Act & Assert
        UserAlreadyExistsException exception = assertThrows(UserAlreadyExistsException.class, () -> authService.registerUser(request));
        assertEquals("Username or email already exists", exception.getMessage());

        // Verify that no new user is created
        assertEquals(1, userRepository.count(), "No additional user should be created");

        // Verify audit logging was not called
        verify(auditLogService, never()).logAction(any(), any(), anyString(), anyString());
    }

    @Test
    @DisplayName("Integration Test: Register User with Invalid Data")
    void testRegisterUser_InvalidData() {
        // Arrange
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername(""); // Invalid username
        request.setEmail("invalidemail.com"); // Invalid email format
        request.setPassword(""); // Missing password
        request.setConsentToDataUsage(true);

        // Act & Assert
        assertThrows(Exception.class, () -> authService.registerUser(request), "Invalid data should throw an exception");

        // Verify that no user is created
        assertEquals(0, userRepository.count(), "No user should be created with invalid data");

        // Verify audit logging was not called
        verify(auditLogService, never()).logAction(any(), any(), anyString(), anyString());
    }

    @Test
    @DisplayName("Integration Test: Ensure ROLE_USER Exists")
    void testRoleUserExists() {
        // Arrange & Act
        Optional<Role> roleOpt = roleRepository.findByName("ROLE_USER");

        // Assert
        assertTrue(roleOpt.isPresent(), "ROLE_USER should exist in the database");
    }

    @Test
    @DisplayName("Integration Test: Register User with Audit Logging Disabled")
    void testRegisterUser_AuditLoggingDisabled() {
        // Arrange
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("noAuditUser");
        request.setEmail("noaudit@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        // Disable audit logging (mock behavior)
        doThrow(new RuntimeException("Audit logging disabled")).when(auditLogService).logAction(any(), anyString(), anyString(), anyString());

        // Act & Assert
        assertDoesNotThrow(() -> authService.registerUser(request), "User registration should proceed even if audit logging fails");

        // Verify user is created despite audit logging failure
        Optional<User> userOpt = userRepository.findByEmail("noaudit@example.com");
        assertTrue(userOpt.isPresent(), "User should be created despite audit logging failure");
    }

    // Additional Tests (Examples)
    // - Test login functionality with valid and invalid credentials.
    // - Test password reset flow with valid and invalid tokens.
    // - Test MFA verification flow.
}
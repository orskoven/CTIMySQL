package auth.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.crypto.password.PasswordEncoder;
import orsk.authmodule.dto.*;
import orsk.authmodule.exceptions.UserAlreadyExistsException;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.*;
import orsk.authmodule.security.JwtTokenProvider;
import orsk.authmodule.service.AuditLogService;
import orsk.authmodule.service.AuthService;
import orsk.authmodule.service.MfaTokenService;
import orsk.authmodule.service.RefreshTokenService;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

public class AuthServiceTest {

    @InjectMocks
    private AuthService authService;

    @Mock
    private AuthenticationManager authenticationManager;

    @Mock
    private UserRepository userRepository;

    @Mock
    private RoleRepository roleRepository;

    @Mock
    private VerificationTokenRepository verificationTokenRepository;

    @Mock
    private PasswordResetTokenRepository passwordResetTokenRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtTokenProvider tokenProvider;

    @Mock
    private RefreshTokenService refreshTokenService;

    @Mock
    private MfaTokenService mfaTokenService;

    @Mock
    private AuditLogService auditLogService;

    @BeforeEach
    public void setup() {
        // Clear existing data
        userRepository.deleteAll();
        roleRepository.deleteAll();

        // Initialize ROLE_USER
        Role userRole = new Role();
        userRole.setName("ROLE_USER");
        roleRepository.save(userRole);
    }

    @Test
    @DisplayName("Register User Successfully")
    public void testRegisterUser_Success() {
        // Arrange
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("newuser");
        request.setEmail("newuser@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        when(userRepository.existsByUsernameOrEmail(anyString(), anyString())).thenReturn(false);

        Role role = new Role();
        role.setName("ROLE_USER");
        when(roleRepository.findByName("ROLE_USER")).thenReturn(Optional.of(role));

        when(passwordEncoder.encode(anyString())).thenReturn("hashedPassword");

        // Act
        assertDoesNotThrow(() -> authService.registerUser(request));

        // Assert
        verify(userRepository, times(1)).save(any(User.class));
        verify(verificationTokenRepository, times(1)).save(any());
        verify(auditLogService, times(1)).logAction(any(), eq("USER_REGISTERED"), any(), any());
    }

    @Test
    @DisplayName("Register User with Existing Username or Email")
    public void testRegisterUser_UserAlreadyExists() {
        // Arrange
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("existinguser");
        request.setEmail("existinguser@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        when(userRepository.existsByUsernameOrEmail(anyString(), anyString())).thenReturn(true);

        // Act & Assert
        UserAlreadyExistsException exception = assertThrows(UserAlreadyExistsException.class, () -> authService.registerUser(request));
        assertEquals("Username or email already exists", exception.getMessage());

        verify(userRepository, never()).save(any(User.class));
        verify(verificationTokenRepository, never()).save(any());
        verify(auditLogService, never()).logAction(any(), any(), any(), any());
    }

    // Additional unit tests for other methods (login, password reset, etc.)
}
// src/test/java/orsk/authmodule/tests/UserServiceTest.java
package auth.services;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.service.UserService;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

public class UserServiceTest {

    @InjectMocks
    private UserService userService;

    @Mock
    private UserRepository userRepository;

    @Mock
    private RoleRepository roleRepository;

    @Mock
    private org.springframework.security.crypto.password.PasswordEncoder passwordEncoder;

    @BeforeEach
    public void setup() {
        MockitoAnnotations.openMocks(this);
        Role userRole = new Role();
        userRole.setName("ROLE_USER");
        when(roleRepository.findByName("ROLE_USER")).thenReturn(Optional.of(userRole));
    }

    @Test
    @DisplayName("Register New User Successfully")
    public void testRegisterNewUser_Success() {
        User user = new User();
        user.setUsername("newUser");
        user.setEmail("newuser@example.com");
        user.setPassword("plainPassword");

        when(userRepository.findByUsername("newUser")).thenReturn(Optional.empty());
        when(passwordEncoder.encode("plainPassword")).thenReturn("hashedPassword");
        when(userRepository.save(any(User.class))).thenReturn(user);

        User registeredUser = userService.registerNewUser(user);

        assertNotNull(registeredUser);
        assertEquals("newUser", registeredUser.getUsername());
        assertEquals("hashedPassword", registeredUser.getPassword());
        assertFalse(registeredUser.getEnabled());
        assertTrue(registeredUser.getRoles().contains(roleRepository.findByName("ROLE_USER").get()));

        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    @DisplayName("Register New User with Existing Username")
    public void testRegisterNewUser_ExistingUsername() {
        User existingUser = new User();
        existingUser.setUsername("existingUser");
        existingUser.setEmail("existing@example.com");

        when(userRepository.findByUsername("existingUser")).thenReturn(Optional.of(existingUser));

        User newUser = new User();
        newUser.setUsername("existingUser");
        newUser.setEmail("newuser@example.com");
        newUser.setPassword("plainPassword");

        RuntimeException exception = assertThrows(RuntimeException.class, () -> userService.registerNewUser(newUser));
        assertEquals("Username already exists", exception.getMessage());

        verify(userRepository, never()).save(any(User.class));
    }

    // Additional user service tests...
}
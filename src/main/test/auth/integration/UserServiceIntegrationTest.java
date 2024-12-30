// src/test/java/orsk/authmodule/tests/UserServiceIntegrationTest.java
package auth.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.security.crypto.password.PasswordEncoder;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.service.UserService;

import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@SpringBootTest
public class UserServiceIntegrationTest {

    @Autowired
    private UserService userService;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @MockBean
    private PasswordEncoder mockPasswordEncoder;

    @BeforeEach
    public void setup() {
        userRepository.deleteAll();
        roleRepository.deleteAll();

        Role userRole = new Role();
        userRole.setName("ROLE_USER");
        roleRepository.save(userRole);
    }

    @Test
    @DisplayName("Integration Test: Register New User")
    public void testRegisterNewUser_Integration() {
        User user = new User();
        user.setUsername("integrationUser");
        user.setEmail("integration@example.com");
        user.setPassword("plainPassword");

        when(mockPasswordEncoder.encode("plainPassword")).thenReturn("hashedPassword");

        User registeredUser = userService.registerNewUser(user);

        assertNotNull(registeredUser);
        assertEquals("integrationUser", registeredUser.getUsername());
        assertEquals("hashedPassword", registeredUser.getPassword());
        assertFalse(registeredUser.getEnabled());
        assertTrue(registeredUser.getRoles().contains(roleRepository.findByName("ROLE_USER").get()));

        verify(mockPasswordEncoder, times(1)).encode("plainPassword");
        assertEquals(1, userRepository.count());
    }

    @Test
    @DisplayName("Integration Test: Register User with Existing Username")
    public void testRegisterUser_ExistingUsername_Integration() {
        User existingUser = new User();
        existingUser.setUsername("existingUser");
        existingUser.setEmail("existing@example.com");
        existingUser.setPassword(passwordEncoder.encode("password123"));
        existingUser.setEnabled(true);
        existingUser.setRoles(Set.of(roleRepository.findByName("ROLE_USER").get()));
        userRepository.save(existingUser);

        User newUser = new User();
        newUser.setUsername("existingUser");
        newUser.setEmail("newuser@example.com");
        newUser.setPassword("plainPassword");

        RuntimeException exception = assertThrows(RuntimeException.class, () -> userService.registerNewUser(newUser));
        assertEquals("Username already exists", exception.getMessage());

        verify(mockPasswordEncoder, never()).encode(anyString());
        assertEquals(1, userRepository.count());
    }

    // Additional integration tests...
}
package auth.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;

import java.util.HashSet;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@DisplayName("Enhanced Database Integration Tests for User Entity")
public class DatabaseIntegrationTests {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    @BeforeEach
    public void setup() {
        roleRepository.deleteAll(); // Optional: Remove if roles should persist between tests
        userRepository.deleteAll();

        // Ensure ROLE_USER exists
        if (!roleRepository.findByName("ROLE_USER").isPresent()) {
            Role userRole = new Role();
            userRole.setName("ROLE_USER");
            roleRepository.save(userRole);
        }
    }
    @Test
    @DisplayName("Saving and Retrieving a User")
    public void saveAndRetrieveUser() {
        // Arrange
        User user = createUser("testuser11", "testuser11@example.com", "password123");

        // Act
        Optional<User> retrievedUser = userRepository.findById(user.getId());

        // Assert
        assertTrue(retrievedUser.isPresent(), "Retrieved user should be present.");
        assertEquals("testuser11", retrievedUser.get().getUsername(), "Username should match.");
        assertTrue(passwordEncoder.matches("password123", retrievedUser.get().getPassword()), "Password should match.");
    }

    //FINE_>  tests run ok -> could improve matching errors and exceptions to enhance passing with green marks
    @ParameterizedTest
    @MethodSource("provideInvalidUserData")
    @DisplayName("Invalid Data Handling")
    public void invalidDataHandling(User user, String expectedMessageFragment) {
        Exception exception = assertThrows(Exception.class, () -> userRepository.save(user));

        Throwable cause = exception.getCause();
        assertNotNull(cause, "The cause of the exception should not be null.");
        assertTrue(cause instanceof org.hibernate.exception.ConstraintViolationException,
                "Expected ConstraintViolationException, but got: " + cause.getClass().getName());

        // Check message fragment
        String message = cause.getMessage().toLowerCase();
        assertTrue(message.contains(expectedMessageFragment.toLowerCase()),
                "Exception message should contain: '" + expectedMessageFragment + "', but got: " + message);
    }



    @Test
    @DisplayName("Unique Constraint Violation for Username")
    public void uniqueConstraintOnUsername() {
        // Arrange
        createUser("duplicateuser", "user1@example.com", "password123");
        User user2 = new User();
        user2.setUsername("duplicateuser"); // Duplicate username
        user2.setEmail("user2@example.com");
        user2.setPassword(passwordEncoder.encode("password456"));
        user2.setEnabled(true);
        user2.setRoles(Set.of(roleRepository.findByName("ROLE_USER").get()));

        // Act & Assert
        Exception exception = assertThrows(Exception.class, () -> userRepository.save(user2));
        assertTrue(exception.getMessage().contains("Duplicate entry") ||
                        exception.getCause().getMessage().contains("Duplicate entry"),
                "Exception should indicate duplicate entry.");
    }

    @Test
    @DisplayName("Find User By Email")
    public void findUserByEmail() {
        // Arrange
        createUser("testuser1", "testuser1@example.com", "password123");

        // Act
        Optional<User> foundUser = userRepository.findByEmail("testuser1@example.com");

        // Assert
        assertTrue(foundUser.isPresent(), "User should be found by email.");
        assertEquals("testuser1", foundUser.get().getUsername(), "Username should match the email.");
    }

    @Test
    @DisplayName("Updating a User")
    public void updateUser() {
        // Arrange
        User user = createUser("testuser1", "testuser1@example.com", "password123");

        // Act
        user.setEmail("updated@example.com");
        userRepository.save(user);
        Optional<User> updatedUser = userRepository.findById(user.getId());

        // Assert
        assertTrue(updatedUser.isPresent(), "Updated user should be found.");
        assertEquals("updated@example.com", updatedUser.get().getEmail(), "Email should be updated.");
    }

    @Test
    @DisplayName("Deleting a User")
    public void deleteUser() {
        // Arrange
        User user = createUser("testuser1", "testuser1@example.com", "password123");

        // Act
        userRepository.deleteById(user.getId());
        Optional<User> deletedUser = userRepository.findById(user.getId());

        // Assert
        assertFalse(deletedUser.isPresent(), "User should no longer exist after deletion.");
    }

    @Test
    @DisplayName("Find All Users")
    public void findAllUsers() {
        // Arrange
        createUser("user1", "user1@example.com", "password123");
        createUser("user2", "user2@example.com", "password456");

        // Act
        Iterable<User> users = userRepository.findAll();

        // Assert
        assertNotNull(users, "Users should not be null.");
        assertTrue(users.iterator().hasNext(), "Users list should not be empty.");
    }

    private static Stream<Arguments> provideInvalidUserData() {
        return Stream.of(
                Arguments.of(new User(null, "user@example.com", "password123", true, new HashSet<>()), "username cannot be null"),
                Arguments.of(new User("user", null, "password123", true, new HashSet<>()), "email cannot be null"),
                Arguments.of(new User("user", "user@example.com", null, true, new HashSet<>()), "password cannot be null")
        );
    }

    // TO DO : ensure string compatability
    /*
    private static Stream<User[]> provideInvalidUserData() {
        Role defaultRole = new Role();
        defaultRole.setName("ROLE_USER");

        return Stream.of(
                new User[]{new User(null, "user@example.com", "password123", true, Set.of(defaultRole)), "username"},
                new User[]{new User("user", null, "password123", true, Set.of(defaultRole)), "email"},
                new User[]{new User("user", "user@example.com", null, true, Set.of(defaultRole)), new User().toString().}
        );
    }

     */

    private User createUser(String username, String email, String password) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(password));
        user.setEnabled(true);
        user.setRoles(new HashSet<>(Set.of(roleRepository.findByName("ROLE_USER").orElseThrow())));
        return userRepository.save(user);
    }
}
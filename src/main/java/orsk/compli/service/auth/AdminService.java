package orsk.compli.service.auth;

import jakarta.persistence.EntityNotFoundException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.Role;
import orsk.compli.entities.User;
import orsk.compli.repository.auth.RoleRepository;
import orsk.compli.repository.auth.UserRepository;


import javax.management.relation.RoleNotFoundException;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
public class AdminService {

    private static final Logger LOGGER = LoggerFactory.getLogger(AdminService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    /**
     * Enables a user account by userId.
     * Admin access required.
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public void enableUser(Long userId) {
        LOGGER.info("Enabling user with ID: {}", userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + userId));

        if (user.getEnabled()) {
            LOGGER.warn("Attempted to enable an already enabled user with ID: {}", userId);
            throw new IllegalStateException("User is already enabled");
        }

        user.setEnabled(true);
        userRepository.save(user);
        LOGGER.info("User with ID: {} successfully enabled", userId);
    }

    /**
     * Disables a user account by userId.
     * Admin access required.
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public void disableUser(Long userId) {
        LOGGER.info("Disabling user with ID: {}", userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + userId));

        if (!user.getEnabled()) {
            LOGGER.warn("Attempted to disable an already disabled user with ID: {}", userId);
            throw new IllegalStateException("User is already disabled");
        }

        user.setEnabled(false);
        userRepository.save(user);
        LOGGER.info("User with ID: {} successfully disabled", userId);
    }

    /**
     * Updates a user's roles by userId.
     * Admin access required.
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public void updateUserRoles(Long userId, List<String> roles) {
        LOGGER.info("Updating roles for user with ID: {}", userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + userId));

        Set<Role> newRoles = roles.stream()
                .map(roleName -> {
                    try {
                        return roleRepository.findByName(roleName)
                                .orElseThrow(() -> new RoleNotFoundException("Role not found: " + roleName));
                    } catch (RoleNotFoundException e) {
                        throw new RuntimeException(e);
                    }
                })
                .collect(Collectors.toSet());

        user.setRoles(newRoles);
        userRepository.save(user);
        LOGGER.info("Roles updated successfully for user with ID: {}", userId);
    }

    /**
     * Retrieves all users (Admin access only).
     */
    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('ADMIN')")
    public List<User> getAllUsers() {
        LOGGER.info("Fetching all users");
        return userRepository.findAll();
    }

    /**
     * Deletes a user by userId (Admin access only).
     */
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public void deleteUser(Long userId) {
        LOGGER.info("Deleting user with ID: {}", userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + userId));

        userRepository.delete(user);
        LOGGER.info("User with ID: {} deleted successfully", userId);
    }

    /**
     * Fetches roles of a user by userId (Admin access only).
     */
    @Transactional(readOnly = true)
    @PreAuthorize("hasRole('ADMIN')")
    public Set<String> getUserRoles(Long userId) {
        LOGGER.info("Fetching roles for user with ID: {}", userId);
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new EntityNotFoundException("User not found with ID: " + userId));

        Set<String> roles = user.getRoles().stream()
                .map(Role::getName)
                .collect(Collectors.toSet());

        LOGGER.info("Roles for user with ID: {} fetched successfully", userId);
        return roles;
    }
}
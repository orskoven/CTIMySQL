package orsk.compli.service.auth;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import orsk.compli.entities.Role;
import orsk.compli.repository.auth.RoleRepository;
import orsk.compli.repository.auth.UserRepository;
import orsk.compli.entities.User;


import java.util.Collections;

@Service("UserService")
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerNewUser(User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setEnabled(false); // User needs to be enabled after registration or email verification
        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("ROLE_USER not found"));
        user.setRoles(Collections.singleton(userRole));
        return userRepository.save(user);
    }
}

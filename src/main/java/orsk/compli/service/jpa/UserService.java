package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaRole;
import orsk.compli.entities.jpa.User;
import orsk.compli.repository.jpa.RoleJpaRepository;
import orsk.compli.repository.jpa.UserJpaRepository;

import java.util.Collections;

@Service("jpaUserService")
public class UserService {

    @Autowired
    private UserJpaRepository userRepository;

    @Autowired
    private RoleJpaRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public User registerNewUser(User user) {
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setEnabled(false); // User needs to be enabled after registration or email verification
        JpaRole userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("ROLE_USER not found"));
        user.setRoles(Collections.singleton(userRole));
        return userRepository.save(user);
    }
}

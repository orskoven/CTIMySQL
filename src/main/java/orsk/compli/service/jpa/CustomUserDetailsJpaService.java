package orsk.compli.service.jpa;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.User;
import orsk.compli.repository.jpa.UserJpaRepository;

import java.util.stream.Collectors;

@Service("jpaCustomUserDetailsService")
public class CustomUserDetailsJpaService implements UserDetailsService {

    @Autowired
    private UserJpaRepository userRepository;

    @Override
    //transactional to By annotating the loadUserByUsername method with @Transactional, you ensure that the Hibernate session remains open for the duration of the method execution, allowing lazy loading to occur seamlessly.
    @Transactional(readOnly = true)
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(usernameOrEmail)
                .or(() -> userRepository.findByEmail(usernameOrEmail))
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username or email: " + usernameOrEmail));
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                user.getEnabled(),
                true,
                true,
                true,
                user.getRoles().stream()
                        .flatMap(role -> role.getPrivileges().stream())
                        .map(privilege -> new SimpleGrantedAuthority(privilege.getName()))
                        .collect(Collectors.toList()));
    }

}

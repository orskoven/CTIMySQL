#!/bin/bash
#    @PreAuthorize("hasAnyRole('ROLE_ADMIN', 'ROLE_MANAGER', 'ROLE_USER')")
# Enhanced Java Service Classes for Cyber Threat Intelligence Management System
# This script overwrites existing service classes with upgraded versions ensuring
# proper transactions, ACID compliance, role-based access, and enhanced security.

# Function to write content to a file using cat
write_file() {
  local filepath="$1"    # The first argument is the file path
  shift                  # Remove the first argument
  cat > "$filepath" <<EOF
$@
EOF
}

# 1. VulnerabilityService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//VulnerabilityService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..Vulnerability;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..VulnerabilityRepository;

import java.util.List;
import java.util.Optional;

@Service("VulnerabilityService")
public class VulnerabilityService implements CrudService<Vulnerability, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(VulnerabilityService.class);

    private final VulnerabilityRepository vulnerabilityRepository;

    @Autowired
    public VulnerabilityService(VulnerabilityRepository vulnerabilityRepository) {
        this.vulnerabilityRepository = vulnerabilityRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public Vulnerability create(Vulnerability entity) {
        LOGGER.info("Creating Vulnerability: {}", entity);
        return vulnerabilityRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<Vulnerability> getAll() {
        LOGGER.info("Retrieving all Vulnerabilities");
        return vulnerabilityRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<Vulnerability> getById(Long id) {
        LOGGER.info("Retrieving Vulnerability with ID: {}", id);
        return vulnerabilityRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public Vulnerability update(Long id, Vulnerability entity) {
        LOGGER.info("Updating Vulnerability with ID: {}", id);
        return vulnerabilityRepository.findById(id)
                .map(existing -> {
                    existing.setName(entity.getName());
                    existing.setDescription(entity.getDescription());
                    existing.setSeverity(entity.getSeverity());
                    // Add other field mappings as necessary
                    return vulnerabilityRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Vulnerability not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Vulnerability with ID: {}", id);
        if (vulnerabilityRepository.existsById(id)) {
            vulnerabilityRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Vulnerability with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 2. CountryService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//CountryService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..Country;
import orsk.compli.exception.DatabaseOperationException;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..CountryRepository;

import java.util.List;

@Service("CountryService")
public class CountryService implements CrudService<Country, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryService.class);

    private final CountryRepository countryRepository;

    @Autowired
    public CountryService(CountryRepository countryRepository) {
        this.countryRepository = countryRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public Country create(Country entity) {
        LOGGER.info("Creating Country: {}", entity);
        return countryRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<Country> getAll() {
        LOGGER.info("Retrieving all Countries");
        return countryRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<Country> getById(Long id) {
        LOGGER.info("Retrieving Country with ID: {}", id);
        return countryRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public Country update(Long id, Country entity) {
        LOGGER.info("Updating Country with ID: {}", id);
        return countryRepository.findById(id)
                .map(existing -> {
                    existing.setCountryCode(entity.getCountryCode());
                    existing.setName(entity.getName());
                    // Add other field mappings as necessary
                    return countryRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Country not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Country with ID: {}", id);
        if (countryRepository.existsById(id)) {
            countryRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Country with ID: {} not found for deletion", id);
        return false;
    }

    // Batch creation of countries
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public List<Country> createAll(List<Country> countries) {
        try {
            LOGGER.info("Batch creating Countries");
            return countryRepository.saveAll(countries);
        } catch (DataAccessException e) {
            LOGGER.error("Error creating countries: {}", e.getMessage());
            throw new DatabaseOperationException("Error creating countries", e);
        }
    }
}
'

# 3. GlobalThreatService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//GlobalThreatService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..GlobalThreat;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..GlobalThreatRepository;

import java.util.List;
import java.util.Optional;

@Service("GlobalThreatService")
public class GlobalThreatService implements CrudService<GlobalThreat, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(GlobalThreatService.class);

    private final GlobalThreatRepository globalThreatRepository;

    @Autowired
    public GlobalThreatService(GlobalThreatRepository globalThreatRepository) {
        this.globalThreatRepository = globalThreatRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public GlobalThreat create(GlobalThreat entity) {
        LOGGER.info("Creating Global Threat: {}", entity);
        return globalThreatRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<GlobalThreat> getAll() {
        LOGGER.info("Retrieving all Global Threats");
        return globalThreatRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<GlobalThreat> getById(Long id) {
        LOGGER.info("Retrieving Global Threat with ID: {}", id);
        return globalThreatRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public GlobalThreat update(Long id, GlobalThreat entity) {
        LOGGER.info("Updating Global Threat with ID: {}", id);
        return globalThreatRepository.findById(id)
                .map(existing -> {
                    existing.setName(entity.getName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return globalThreatRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Global Threat not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Global Threat with ID: {}", id);
        if (globalThreatRepository.existsById(id)) {
            globalThreatRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Global Threat with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 4. ThreatActorTypeService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//ThreatActorTypeService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..ThreatActorType;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..ThreatActorTypeRepository;

import java.util.List;
import java.util.Optional;

@Service("ThreatActorTypeService")
public class ThreatActorTypeService implements CrudService<ThreatActorType, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ThreatActorTypeService.class);

    private final ThreatActorTypeRepository threatActorTypeRepository;

    @Autowired
    public ThreatActorTypeService(ThreatActorTypeRepository threatActorTypeRepository) {
        this.threatActorTypeRepository = threatActorTypeRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public ThreatActorType create(ThreatActorType entity) {
        LOGGER.info("Creating Threat Actor Type: {}", entity);
        return threatActorTypeRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<ThreatActorType> getAll() {
        LOGGER.info("Retrieving all Threat Actor Types");
        return threatActorTypeRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<ThreatActorType> getById(Long id) {
        LOGGER.info("Retrieving Threat Actor Type with ID: {}", id);
        return threatActorTypeRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public ThreatActorType update(Long id, ThreatActorType entity) {
        LOGGER.info("Updating Threat Actor Type with ID: {}", id);
        return threatActorTypeRepository.findById(id)
                .map(existing -> {
                    existing.setTypeName(entity.getTypeName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return threatActorTypeRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Threat Actor Type not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Threat Actor Type with ID: {}", id);
        if (threatActorTypeRepository.existsById(id)) {
            threatActorTypeRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Threat Actor Type with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 5. UserService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//UserService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..Role;
import orsk.compli.entities..User;
import orsk.compli.exception.EntityAlreadyExistsException;
import orsk.compli.exception.RoleNotFoundException;
import orsk.compli.repository..RoleRepository;
import orsk.compli.repository..UserRepository;

import java.util.Collections;

@Service("UserService")
public class UserService {

    private static final Logger LOGGER = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public User registerNewUser(User user) {
        LOGGER.info("Registering new user: {}", user.getUsername());
        if (userRepository.findByUsername(user.getUsername()).isPresent()) {
            LOGGER.error("Username {} already exists", user.getUsername());
            throw new EntityAlreadyExistsException("Username already exists");
        }
        if (userRepository.findByEmail(user.getEmail()).isPresent()) {
            LOGGER.error("Email {} already exists", user.getEmail());
            throw new EntityAlreadyExistsException("Email already exists");
        }

        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setEnabled(false); // User needs to be enabled after registration or email verification
        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RoleNotFoundException("ROLE_USER not found"));
        user.setRoles(Collections.singleton(userRole));
        User savedUser = userRepository.save(user);
        LOGGER.info("User registered successfully: {}", savedUser.getUsername());
        return savedUser;
    }
}
'

# 6. GeolocationService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//GeolocationService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..Geolocation;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..GeolocationRepository;

import java.util.List;
import java.util.Optional;

@Service("GeolocationService")
public class GeolocationService implements CrudService<Geolocation, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(GeolocationService.class);

    private final GeolocationRepository geolocationRepository;

    @Autowired
    public GeolocationService(GeolocationRepository geolocationRepository) {
        this.geolocationRepository = geolocationRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public Geolocation create(Geolocation entity) {
        LOGGER.info("Creating Geolocation: {}", entity);
        return geolocationRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<Geolocation> getAll() {
        LOGGER.info("Retrieving all Geolocations");
        return geolocationRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<Geolocation> getById(Long id) {
        LOGGER.info("Retrieving Geolocation with ID: {}", id);
        return geolocationRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public Geolocation update(Long id, Geolocation entity) {
        LOGGER.info("Updating Geolocation with ID: {}", id);
        return geolocationRepository.findById(id)
                .map(existing -> {
                    existing.setLatitude(entity.getLatitude());
                    existing.setLongitude(entity.getLongitude());
                    existing.setCountry(entity.getCountry());
                    // Add other field mappings as necessary
                    return geolocationRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Geolocation not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Geolocation with ID: {}", id);
        if (geolocationRepository.existsById(id)) {
            geolocationRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Geolocation with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 7. AttackVectorService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//AttackVectorService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..AttackVector;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..AttackVectorRepository;

import java.util.List;
import java.util.Optional;

@Service("AttackVectorService")
public class AttackVectorService implements CrudService<AttackVector, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(AttackVectorService.class);

    private final AttackVectorRepository attackVectorRepository;

    @Autowired
    public AttackVectorService(AttackVectorRepository attackVectorRepository) {
        this.attackVectorRepository = attackVectorRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public AttackVector create(AttackVector entity) {
        LOGGER.info("Creating Attack Vector: {}", entity);
        return attackVectorRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<AttackVector> getAll() {
        LOGGER.info("Retrieving all Attack Vectors");
        return attackVectorRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<AttackVector> getById(Long id) {
        LOGGER.info("Retrieving Attack Vector with ID: {}", id);
        return attackVectorRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public AttackVector update(Long id, AttackVector entity) {
        LOGGER.info("Updating Attack Vector with ID: {}", id);
        return attackVectorRepository.findById(id)
                .map(existing -> {
                    existing.setVectorName(entity.getVectorName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return attackVectorRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Attack Vector not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Attack Vector with ID: {}", id);
        if (attackVectorRepository.existsById(id)) {
            attackVectorRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Attack Vector with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 8. CustomUserDetailsService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//CustomUserDetailsService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import orsk.compli.entities..User;
import orsk.compli.exception.UsernameOrEmailNotFoundException;
import orsk.compli.repository..UserRepository;

import java.util.stream.Collectors;

@Service("CustomUserDetailsService")
public class CustomUserDetailsService implements UserDetailsService {

    private static final Logger LOGGER = LoggerFactory.getLogger(CustomUserDetailsService.class);

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        LOGGER.info("Loading user by username or email: {}", usernameOrEmail);
        User user = userRepository.findByUsername(usernameOrEmail)
                .or(() -> userRepository.findByEmail(usernameOrEmail))
                .orElseThrow(() -> {
                    LOGGER.error("User not found with username or email: {}", usernameOrEmail);
                    return new UsernameOrEmailNotFoundException("User not found with username or email: " + usernameOrEmail);
                });
        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                user.isEnabled(),
                true,
                true,
                true,
                user.getRoles().stream()
                        .flatMap(role -> role.getPrivileges().stream())
                        .map(privilege -> new SimpleGrantedAuthority(privilege.getName()))
                        .collect(Collectors.toList()));
    }

}
'

# 9. AffectedProductService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//AffectedProductService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..AffectedProduct;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..AffectedProductRepository;

import java.util.List;
import java.util.Optional;

@Service("AffectedProductService")
public class AffectedProductService implements CrudService<AffectedProduct, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(AffectedProductService.class);

    private final AffectedProductRepository affectedProductRepository;

    @Autowired
    public AffectedProductService(AffectedProductRepository affectedProductRepository) {
        this.affectedProductRepository = affectedProductRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public AffectedProduct create(AffectedProduct entity) {
        LOGGER.info("Creating Affected Product: {}", entity);
        return affectedProductRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<AffectedProduct> getAll() {
        LOGGER.info("Retrieving all Affected Products");
        return affectedProductRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<AffectedProduct> getById(Long id) {
        LOGGER.info("Retrieving Affected Product with ID: {}", id);
        return affectedProductRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public AffectedProduct update(Long id, AffectedProduct entity) {
        LOGGER.info("Updating Affected Product with ID: {}", id);
        return affectedProductRepository.findById(id)
                .map(existing -> {
                    existing.setProductName(entity.getProductName());
                    existing.setVendor(entity.getVendor());
                    existing.setVersion(entity.getVersion());
                    // Add other field mappings as necessary
                    return affectedProductRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Affected Product not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Affected Product with ID: {}", id);
        if (affectedProductRepository.existsById(id)) {
            affectedProductRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Affected Product with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 10. AuthService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//AuthService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.dtos.*;
import orsk.compli.entities..PasswordResetToken;
import orsk.compli.entities..RefreshToken;
import orsk.compli.entities..User;
import orsk.compli.entities..VerificationToken;
import orsk.compli.exception.InvalidTokenException;
import orsk.compli.exception.UserNotFoundException;
import orsk.compli.repository..PasswordResetTokenRepository;
import orsk.compli.repository..RoleRepository;
import orsk.compli.repository..UserRepository;
import orsk.compli.repository..VerificationTokenRepository;
import orsk.compli.security.JwtTokenProvider;

import javax.management.relation.RoleNotFoundException;
import java.time.Instant;
import java.util.Set;
import java.util.UUID;

@Service("AuthService")
public class AuthService {

    private static final Logger LOGGER = LoggerFactory.getLogger(AuthService.class);

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private RoleRepository roleRepository;

    @Autowired
    private VerificationTokenRepository verificationTokenRepository;

    @Autowired
    private PasswordResetTokenRepository passwordResetTokenRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private RefreshTokenService refreshTokenService;

    @Transactional
    @PreAuthorize("permitAll()")
    public void registerUser(RegistrationRequest registrationRequest) {
        LOGGER.info("Registering user: {}", registrationRequest.getUsername());
        if (userRepository.findByUsername(registrationRequest.getUsername()).isPresent()) {
            LOGGER.error("Username {} already exists", registrationRequest.getUsername());
            throw new EntityAlreadyExistsException("Username already exists");
        }
        if (userRepository.findByEmail(registrationRequest.getEmail()).isPresent()) {
            LOGGER.error("Email {} already exists", registrationRequest.getEmail());
            throw new EntityAlreadyExistsException("Email already exists");
        }

        try {
            User user = new User();
            user.setUsername(registrationRequest.getUsername());
            user.setPassword(passwordEncoder.encode(registrationRequest.getPassword()));
            user.setEmail(registrationRequest.getEmail());
            user.setConsentToDataUsage(registrationRequest.getConsentToDataUsage());
            user.setEnabled(false); // User needs to verify email

            // Assign ROLE_USER
            user.setRoles(Set.of(roleRepository.findByName("ROLE_USER")
                    .orElseThrow(() -> new RoleNotFoundException("ROLE_USER not found"))));

            userRepository.save(user);
            LOGGER.info("User registered successfully: {}", user.getUsername());

            // Generate verification token
            String token = generateVerificationToken(user);

            // TODO: Integrate with EmailService to send verification email
            LOGGER.info("Verification token generated for user: {}", user.getUsername());

        } catch (Exception e) {
            LOGGER.error("Registration failed for user {}: {}", registrationRequest.getUsername(), e.getMessage());
            throw new RuntimeException("Registration failed due to an unexpected error", e);
        }
    }

    @Transactional
    @PreAuthorize("permitAll()")
    public JwtAuthenticationResponse authenticateUser(LoginRequest loginRequest) {
        LOGGER.info("Authenticating user with email: {}", loginRequest.getEmail());
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getEmail(),
                        loginRequest.getPassword()
                )
        );

        String jwt = tokenProvider.generateToken(authentication);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(authentication.getName());

        LOGGER.info("User authenticated successfully: {}", authentication.getName());
        return new JwtAuthenticationResponse(jwt, refreshToken.getToken());
    }

    @Transactional
    @PreAuthorize("permitAll()")
    public JwtAuthenticationResponse refreshToken(TokenRefreshRequest request) {
        String requestRefreshToken = request.getRefreshToken();
        LOGGER.info("Refreshing token for refresh token: {}", requestRefreshToken);

        return refreshTokenService.findByToken(requestRefreshToken)
                .map(refreshTokenService::verifyExpiration)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String token = tokenProvider.generateTokenFromUsername(user.getUsername());
                    LOGGER.info("Token refreshed successfully for user: {}", user.getUsername());
                    return new JwtAuthenticationResponse(token, requestRefreshToken);
                })
                .orElseThrow(() -> {
                    LOGGER.error("Refresh token not found: {}", requestRefreshToken);
                    return new InvalidTokenException("Refresh token not found");
                });
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public void logoutUser(LogoutRequest logoutRequest) {
        LOGGER.info("Logging out user by invalidating refresh token: {}", logoutRequest.getRefreshToken());
        refreshTokenService.deleteByToken(logoutRequest.getRefreshToken());
    }

    @Transactional
    @PreAuthorize("permitAll()")
    public void initiatePasswordReset(PasswordResetRequest passwordResetRequest) {
        LOGGER.info("Initiating password reset for email: {}", passwordResetRequest.getEmail());
        User user = userRepository.findByEmail(passwordResetRequest.getEmail())
                .orElseThrow(() -> new UserNotFoundException("Email not found"));

        String token = UUID.randomUUID().toString();
        PasswordResetToken passwordResetToken = new PasswordResetToken();
        passwordResetToken.setToken(token);
        passwordResetToken.setUser(user);
        passwordResetToken.setExpiryDate(Instant.now().plusSeconds(3600)); // 1 hour expiry

        passwordResetTokenRepository.save(passwordResetToken);
        LOGGER.info("Password reset token generated for user: {}", user.getUsername());

        // TODO: Integrate with EmailService to send password reset email
    }

    @Transactional
    @PreAuthorize("permitAll()")
    public void changePassword(PasswordChangeRequest passwordChangeRequest) {
        LOGGER.info("Changing password using token: {}", passwordChangeRequest.getToken());
        PasswordResetToken passwordResetToken = passwordResetTokenRepository.findByToken(passwordChangeRequest.getToken())
                .orElseThrow(() -> new InvalidTokenException("Invalid password reset token"));

        if (passwordResetToken.getExpiryDate().isBefore(Instant.now())) {
            LOGGER.error("Password reset token expired for user: {}", passwordResetToken.getUser().getUsername());
            throw new InvalidTokenException("Password reset token expired");
        }

        User user = passwordResetToken.getUser();
        user.setPassword(passwordEncoder.encode(passwordChangeRequest.getNewPassword()));
        userRepository.save(user);
        LOGGER.info("Password changed successfully for user: {}", user.getUsername());

        passwordResetTokenRepository.delete(passwordResetToken);
    }

    @Transactional
    @PreAuthorize("permitAll()")
    public void verifyEmail(String token) {
        LOGGER.info("Verifying email with token: {}", token);
        VerificationToken verificationToken = verificationTokenRepository.findByToken(token)
                .orElseThrow(() -> new InvalidTokenException("Invalid verification token"));

        User user = verificationToken.getUser();
        user.setEnabled(true);
        userRepository.save(user);
        LOGGER.info("Email verified and user enabled: {}", user.getUsername());

        verificationTokenRepository.delete(verificationToken);
    }

    private String generateVerificationToken(User user) {
        String token = UUID.randomUUID().toString();
        VerificationToken verificationToken = new VerificationToken();
        verificationToken.setToken(token);
        verificationToken.setUser(user);
        verificationToken.setExpiryDate(Instant.now().plusSeconds(86400)); // 24 hours expiry

        verificationTokenRepository.save(verificationToken);
        LOGGER.info("Verification token saved for user: {}", user.getUsername());

        return token;
    }
}
'

# 11. ThreatCategoryService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//ThreatCategoryService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..ThreatCategory;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..ThreatCategoryRepository;

import java.util.List;
import java.util.Optional;

@Service("ThreatCategoryService")
public class ThreatCategoryService implements CrudService<ThreatCategory, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ThreatCategoryService.class);

    private final ThreatCategoryRepository threatCategoryRepository;

    @Autowired
    public ThreatCategoryService(ThreatCategoryRepository threatCategoryRepository) {
        this.threatCategoryRepository = threatCategoryRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public ThreatCategory create(ThreatCategory entity) {
        LOGGER.info("Creating Threat Category: {}", entity);
        return threatCategoryRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<ThreatCategory> getAll() {
        LOGGER.info("Retrieving all Threat Categories");
        return threatCategoryRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<ThreatCategory> getById(Long id) {
        LOGGER.info("Retrieving Threat Category with ID: {}", id);
        return threatCategoryRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public ThreatCategory update(Long id, ThreatCategory entity) {
        LOGGER.info("Updating Threat Category with ID: {}", id);
        return threatCategoryRepository.findById(id)
                .map(existing -> {
                    existing.setCategoryName(entity.getCategoryName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return threatCategoryRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Threat Category not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Threat Category with ID: {}", id);
        if (threatCategoryRepository.existsById(id)) {
            threatCategoryRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Threat Category with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 12. RefreshTokenService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//RefreshTokenService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..RefreshToken;
import orsk.compli.entities..User;
import orsk.compli.exception.UserNotFoundException;
import orsk.compli.repository..RefreshTokenRepository;
import orsk.compli.repository..UserRepository;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service("RefreshTokenService")
public class RefreshTokenService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RefreshTokenService.class);

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private UserRepository userRepository;

    public Optional<RefreshToken> findByToken(String token) {
        LOGGER.info("Finding Refresh Token: {}", token);
        return refreshTokenRepository.findByToken(token);
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public RefreshToken createRefreshToken(String username) {
        LOGGER.info("Creating Refresh Token for user: {}", username);
        RefreshToken refreshToken = new RefreshToken();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UserNotFoundException("User not found"));

        refreshToken.setUser(user);
        refreshToken.setExpiryDate(Instant.now().plusSeconds(604800)); // 7 days
        refreshToken.setToken(UUID.randomUUID().toString());

        RefreshToken savedToken = refreshTokenRepository.save(refreshToken);
        LOGGER.info("Refresh Token created: {}", savedToken.getToken());
        return savedToken;
    }

    public RefreshToken verifyExpiration(RefreshToken token) {
        LOGGER.info("Verifying expiration for Refresh Token: {}", token.getToken());
        if (token.getExpiryDate().isBefore(Instant.now())) {
            LOGGER.warn("Refresh Token expired: {}", token.getToken());
            refreshTokenRepository.delete(token);
            throw new InvalidTokenException("Refresh token expired");
        }
        return token;
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public int deleteByUserId(Long userId) {
        LOGGER.info("Deleting Refresh Tokens for User ID: {}", userId);
        return refreshTokenRepository.deleteByUser(userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("User not found")));
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public void deleteByToken(String token) {
        LOGGER.info("Deleting Refresh Token: {}", token);
        refreshTokenRepository.findByToken(token).ifPresent(rt -> {
            refreshTokenRepository.delete(rt);
            LOGGER.info("Refresh Token deleted: {}", token);
        });
    }
}
'

# 13. SearchService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//SearchService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.repository..AffectedProductRepository;
import orsk.compli.repository..CountryRepository;
import orsk.compli.repository..GlobalThreatRepository;

import java.util.List;

@Service("SearchService")
public class SearchService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SearchService.class);

    private final AffectedProductRepository affectedProductRepository;
    private final CountryRepository countryRepository;
    private final GlobalThreatRepository globalThreatRepository;

    @Autowired
    public SearchService(AffectedProductRepository affectedProductRepository,
                         CountryRepository countryRepository,
                         GlobalThreatRepository globalThreatRepository) {
        this.affectedProductRepository = affectedProductRepository;
        this.countryRepository = countryRepository;
        this.globalThreatRepository = globalThreatRepository;
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<String> getAffectedProductNames() {
        LOGGER.info("Fetching Affected Product Names");
        return affectedProductRepository.findAllProductNames();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<String> getCountryNames() {
        LOGGER.info("Fetching Country Names");
        return countryRepository.findAllCountryNames();
    }

    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<String> getGlobalThreatNames() {
        LOGGER.info("Fetching Global Threat Names");
        return globalThreatRepository.findAllThreatNames();
    }

    // Add more search methods as needed with appropriate logging and security
}
'

# 14. AttackVectorCategoryService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//AttackVectorCategoryService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..AttackVectorCategory;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..AttackVectorCategoryRepository;

import java.util.List;
import java.util.Optional;

@Service("AttackVectorCategoryService")
public class AttackVectorCategoryService implements CrudService<AttackVectorCategory, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(AttackVectorCategoryService.class);

    private final AttackVectorCategoryRepository attackVectorCategoryRepository;

    @Autowired
    public AttackVectorCategoryService(AttackVectorCategoryRepository attackVectorCategoryRepository) {
        this.attackVectorCategoryRepository = attackVectorCategoryRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public AttackVectorCategory create(AttackVectorCategory entity) {
        LOGGER.info("Creating Attack Vector Category: {}", entity);
        return attackVectorCategoryRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<AttackVectorCategory> getAll() {
        LOGGER.info("Retrieving all Attack Vector Categories");
        return attackVectorCategoryRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<AttackVectorCategory> getById(Long id) {
        LOGGER.info("Retrieving Attack Vector Category with ID: {}", id);
        return attackVectorCategoryRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public AttackVectorCategory update(Long id, AttackVectorCategory entity) {
        LOGGER.info("Updating Attack Vector Category with ID: {}", id);
        return attackVectorCategoryRepository.findById(id)
                .map(existing -> {
                    existing.setCategoryName(entity.getCategoryName());
                    existing.setDescription(entity.getDescription());
                    // Add other field mappings as necessary
                    return attackVectorCategoryRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Attack Vector Category not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Attack Vector Category with ID: {}", id);
        if (attackVectorCategoryRepository.existsById(id)) {
            attackVectorCategoryRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Attack Vector Category with ID: {} not found for deletion", id);
        return false;
    }
}
'

# 15. CrudService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//CrudService.java" '
package orsk.compli.service.;

import java.util.List;
import java.util.Optional;

public interface CrudService<T, ID> {
    T create(T t);

    List<T> getAll();

    Optional<T> getById(ID id);

    T update(ID id, T t);

    boolean delete(ID id);
}
'

# 16. ThreatActorService.java
write_file "/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/CTIMySQLFINAL/src/main/java/orsk/compli/service//ThreatActorService.java" '
package orsk.compli.service.;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.access.prepost.PreAuthorize;
import orsk.compli.entities..ThreatActor;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository..ThreatActorRepository;

import java.util.List;
import java.util.Optional;

@Service("ThreatActorService")
public class ThreatActorService implements CrudService<ThreatActor, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(ThreatActorService.class);

    private final ThreatActorRepository threatActorRepository;

    @Autowired
    public ThreatActorService(ThreatActorRepository threatActorRepository) {
        this.threatActorRepository = threatActorRepository;
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public ThreatActor create(ThreatActor entity) {
        LOGGER.info("Creating Threat Actor: {}", entity);
        return threatActorRepository.save(entity);
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public List<ThreatActor> getAll() {
        LOGGER.info("Retrieving all Threat Actors");
        return threatActorRepository.findAll();
    }

    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'MANAGER', 'USER')")
    public Optional<ThreatActor> getById(Long id) {
        LOGGER.info("Retrieving Threat Actor with ID: {}", id);
        return threatActorRepository.findById(id);
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN') or hasRole('MANAGER')")
    public ThreatActor update(Long id, ThreatActor entity) {
        LOGGER.info("Updating Threat Actor with ID: {}", id);
        return threatActorRepository.findById(id)
                .map(existing -> {
                    existing.setActorName(entity.getActorName());
                    existing.setMotivation(entity.getMotivation());
                    existing.setCapabilities(entity.getCapabilities());
                    // Add other field mappings as necessary
                    return threatActorRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Threat Actor not found with id " + id));
    }

    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Threat Actor with ID: {}", id);
        if (threatActorRepository.existsById(id)) {
            threatActorRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Threat Actor with ID: {} not found for deletion", id);
        return false;
    }
}
'

echo "All service classes have been successfully updated."
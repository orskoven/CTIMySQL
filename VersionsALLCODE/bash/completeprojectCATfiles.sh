#!/bin/bash

# =============================================================================
# Bash Script to Migrate Spring Boot Application from MySQL (JPA) to mysql
# Version: 2.0
# =============================================================================
# This script automates the creation of Java files adjusted for mysql integration.
# It uses `cat` commands with proper mysql annotations to generate the necessary
# DTOs, Models, Repositories, Services, Controllers, and Security configurations.
# =============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# ----------------------------
# Configuration Parameters
# ----------------------------

# Base directory of the Spring Boot project (Change this path as per your project structure)
BASE_DIR="/Users/simonbeckmann/IdeaProjects/CyberDashboar/src/mysql_authmoduleVmysql/src/main/java/orsk/authmodule"

# Define the list of directories to create
DIRECTORIES=(
  "$BASE_DIR/dto"
  "$BASE_DIR/repository"
  "$BASE_DIR/model"
  "$BASE_DIR/security"
  "$BASE_DIR/exceptions"
  "$BASE_DIR/controller"
  "$BASE_DIR/service"
)

# mysql specific configurations
mysql_URI="bolt://localhost:7687"
mysql_USERNAME="mysql"
mysql_PASSWORD="secret" # In production, use environment variables or a secure vault

# ----------------------------
# Utility Functions
# ----------------------------

# Function to create directories
create_directories() {
  echo "Creating directory structure..."
  for DIR in "${DIRECTORIES[@]}"; do
    mkdir -p "$DIR"
    echo "Created directory: $DIR"
  done
}

# Function to create DTOs
create_dtos() {
  echo "Creating DTO files..."

  # MfaVerificationRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/MfaVerificationRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class MfaVerificationRequest {

    @NotBlank(message = "MFA code is required")
    private String mfaCode;
}
EOF

  # RegistrationRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/RegistrationRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
public class RegistrationRequest {

    @NotBlank(message = "Username is required")
    @Size(min = 3, max = 50, message = "Username must be between 3 and 50 characters")
    private String username;

    @NotBlank(message = "Password is required")
    @Size(min = 12, message = "Password must be at least 12 characters")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#^()_+{}|:;<>,.?/~`-]).+$",
            message = "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character")
    private String password;

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;

    private Boolean consentToDataUsage = false;
}
EOF

  # LogoutRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/LogoutRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LogoutRequest {

    @NotBlank(message = "Refresh token is required")
    private String refreshToken;
}
EOF

  # TokenRefreshRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/TokenRefreshRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TokenRefreshRequest {

    @NotBlank(message = "Refresh token is required")
    private String refreshToken;
}
EOF

  # LoginRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/LoginRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class LoginRequest {
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Password is required")
    private String password;
}
EOF

  # PasswordResetRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/PasswordResetRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PasswordResetRequest {

    @NotBlank(message = "Email is required")
    @Email(message = "Email should be valid")
    private String email;
}
EOF

  # UserDTO.java
  cat << 'EOF' > "$BASE_DIR/dto/UserDTO.java"
package orsk.authmodule.dto;

public class UserDTO {
    private Long id;
    private String username;
    private String email;
    private boolean enabled;

    // Getters and Setters
}
EOF

  # JwtAuthenticationResponse.java
  cat << 'EOF' > "$BASE_DIR/dto/JwtAuthenticationResponse.java"
package orsk.authmodule.dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class JwtAuthenticationResponse {

    private String accessToken;
    private String refreshToken;
    private String tokenType = "Bearer";

    public JwtAuthenticationResponse(String accessToken, String refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }
}
EOF

  # PasswordChangeRequest.java
  cat << 'EOF' > "$BASE_DIR/dto/PasswordChangeRequest.java"
package orsk.authmodule.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class PasswordChangeRequest {

    @NotBlank(message = "Reset token is required")
    private String token;

    @NotBlank(message = "New password is required")
    @Pattern(regexp = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&#^()_+{}|:;<>,.?/~`-]).+$",
            message = "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character")
    private String newPassword;
}
EOF

  # SearchOptionsResponse.java
  cat << 'EOF' > "$BASE_DIR/dto/SearchOptionsResponse.java"
package orsk.authmodule.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
public class SearchOptionsResponse {
    private List<String> products;
    private List<String> countries;
    private List<String> threats;
    // Add more fields as needed
}
EOF
}

# Function to create Repositories
create_repositories() {
  echo "Creating Repository interfaces..."

  # RefreshTokenRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/RefreshTokenRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.RefreshToken;
import orsk.authmodule.model.User;

import java.util.Optional;

@Repository
public interface RefreshTokenRepository extends mysqlRepository<RefreshToken, Long> {
    Optional<RefreshToken> findByToken(String token);
    void deleteByUser(User user);
}
EOF

  # RoleRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/RoleRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.Role;

import java.util.Optional;

@Repository
public interface RoleRepository extends mysqlRepository<Role, Long> {
    Optional<Role> findByName(String name);
}
EOF

  # MfaTokenRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/MfaTokenRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.MfaToken;

import java.util.Optional;

@Repository
public interface MfaTokenRepository extends mysqlRepository<MfaToken, Long> {
    Optional<MfaToken> findByMfaCode(String mfaCode);
}
EOF

  # UserRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/UserRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.User;

import java.util.Optional;

@Repository
public interface UserRepository extends mysqlRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsernameOrEmail(String username, String email);
    Optional<User> findByPasswordResetTokens_Token(String token);
}
EOF

  # PasswordResetTokenRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/PasswordResetTokenRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.PasswordResetToken;

import java.util.Optional;

@Repository
public interface PasswordResetTokenRepository extends mysqlRepository<PasswordResetToken, Long> {
    Optional<PasswordResetToken> findByToken(String token);
}
EOF

  # VerificationTokenRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/VerificationTokenRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.VerificationToken;
import orsk.authmodule.model.User;

import java.util.Optional;

@Repository
public interface VerificationTokenRepository extends mysqlRepository<VerificationToken, Long> {
    Optional<VerificationToken> findByToken(String token);
    Optional<VerificationToken> findByUser(User user);
}
EOF

  # AuditLogRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/AuditLogRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.AuditLog;

@Repository
public interface AuditLogRepository extends mysqlRepository<AuditLog, Long> {
}
EOF

  # PrivilegeRepository.java
  cat << 'EOF' > "$BASE_DIR/repository/PrivilegeRepository.java"
package orsk.authmodule.repository;

import org.springframework.data.mysql.repository.mysqlRepository;
import org.springframework.stereotype.Repository;
import orsk.authmodule.model.Privilege;

import java.util.Optional;

@Repository
public interface PrivilegeRepository extends mysqlRepository<Privilege, Long> {
    Optional<Privilege> findByName(String name);
}
EOF
}

# Function to create Models
create_models() {
  echo "Creating Model classes..."

  # RefreshToken.java
  cat << 'EOF' > "$BASE_DIR/model/RefreshToken.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("RefreshToken")
public class RefreshToken {

    @Id @GeneratedValue
    private Long id;

   
    private String token;

    private Instant expiryDate;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF

  # Role.java
  cat << 'EOF' > "$BASE_DIR/model/Role.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Getter
@Setter
@Node("Role")
public class Role {

    @Id @GeneratedValue
    private Long id;

    
    private String name;

    @Relationship(type = "HAS_PRIVILEGE", direction = Relationship.Direction.OUTGOING)
    private Set<Privilege> privileges = new HashSet<>();

    // Override equals and hashCode based on 'name'
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Role role = (Role) o;
        return Objects.equals(name, role.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }
}
EOF

  # MfaToken.java
  cat << 'EOF' > "$BASE_DIR/model/MfaToken.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("MfaToken")
public class MfaToken {

    @Id @GeneratedValue
    private Long id;

    
    private String mfaCode;

    private Instant expiryDate;

    private Boolean used = false;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;

    // Constructors
    public MfaToken() {}

    public MfaToken(String mfaCode, Instant expiryDate, User user) {
        this.mfaCode = mfaCode;
        this.expiryDate = expiryDate;
        this.user = user;
        this.used = false;
    }
}
EOF

  # Privilege.java
  cat << 'EOF' > "$BASE_DIR/model/Privilege.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;

@Getter
@Setter
@Node("Privilege")
public class Privilege {

    @Id @GeneratedValue
    private Long id;

    
    private String name;

    @Relationship(type = "HAS_ROLE", direction = Relationship.Direction.INCOMING)
    private Set<Role> roles = new HashSet<>();

    // Override equals and hashCode based on 'name'
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Privilege privilege = (Privilege) o;
        return Objects.equals(name, privilege.name);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name);
    }
}
EOF

  # User.java
  cat << 'EOF' > "$BASE_DIR/model/User.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Node("User")
public class User {

    @Id @GeneratedValue
    private Long id;

    
    private String username;

    private String password;

    
    private String email;

    private Boolean enabled = false;

    private Boolean consentToDataUsage = false;

    @Relationship(type = "HAS_ROLE", direction = Relationship.Direction.OUTGOING)
    private Set<Role> roles = new HashSet<>();

    @Relationship(type = "HAS_REFRESH_TOKEN", direction = Relationship.Direction.OUTGOING)
    private Set<RefreshToken> refreshTokens = new HashSet<>();

    @Relationship(type = "HAS_PASSWORD_RESET_TOKEN", direction = Relationship.Direction.OUTGOING)
    private Set<PasswordResetToken> passwordResetTokens = new HashSet<>();

    @Relationship(type = "HAS_VERIFICATION_TOKEN", direction = Relationship.Direction.OUTGOING)
    private Set<VerificationToken> verificationTokens = new HashSet<>();

    @Relationship(type = "HAS_MFA_TOKEN", direction = Relationship.Direction.OUTGOING)
    private Set<MfaToken> mfaTokens = new HashSet<>();

    @Relationship(type = "HAS_AUDIT_LOG", direction = Relationship.Direction.OUTGOING)
    private Set<AuditLog> auditLogs = new HashSet<>();
}
EOF

  # PasswordResetToken.java
  cat << 'EOF' > "$BASE_DIR/model/PasswordResetToken.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("PasswordResetToken")
public class PasswordResetToken {

    @Id @GeneratedValue
    private Long id;

    
    private String token;

    private Instant expiryDate;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF

  # AuditLog.java
  cat << 'EOF' > "$BASE_DIR/model/AuditLog.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("AuditLog")
public class AuditLog {

    @Id @GeneratedValue
    private Long id;

    private String action; // e.g., LOGIN_SUCCESS, LOGIN_FAILURE
    private String ipAddress;
    private Instant timestamp;
    private String details;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF

  # Session.java
  cat << 'EOF' > "$BASE_DIR/model/Session.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("Session")
public class Session {

    @Id @GeneratedValue
    private Long id;

    private String sessionId;
    private Instant createdAt;
    private Instant lastAccessedAt;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF

  # VerificationToken.java
  cat << 'EOF' > "$BASE_DIR/model/VerificationToken.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("VerificationToken")
public class VerificationToken {

    @Id @GeneratedValue
    private Long id;

    
    private String token;

    private Instant expiryDate;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF

  # Device.java
  cat << 'EOF' > "$BASE_DIR/model/Device.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;

import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Node("Device")
public class Device {

    @Id @GeneratedValue
    private Long id;

    private String deviceId;
    private String deviceType; // e.g., MOBILE, DESKTOP
    private Instant registeredAt;

    @Relationship(type = "BELONGS_TO", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF
}

# Function to create Security Configurations
create_security_configurations() {
  echo "Creating Security configuration files..."

  # SecurityConfig.java
  cat << 'EOF' > "$BASE_DIR/security/SecurityConfig.java"
package orsk.authmodule.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import java.util.Arrays;
import java.util.List;

import static org.springframework.security.config.Customizer.withDefaults;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthenticationEntryPoint unauthorizedHandler;

    public SecurityConfig(JwtAuthenticationEntryPoint unauthorizedHandler) {
        this.unauthorizedHandler = unauthorizedHandler;
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(withDefaults()) // Enable CORS with default configuration
                .csrf(AbstractHttpConfigurer::disable) // Disable CSRF for stateless APIs
                .exceptionHandling(exception -> exception.authenticationEntryPoint(unauthorizedHandler))
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll() // Allow OPTIONS requests
                        .requestMatchers("/api/auth/**").permitAll() // Public endpoints
                        .anyRequest().authenticated() // Secure other endpoints
                );

        http.addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration authenticationConfiguration) throws Exception {
        return authenticationConfiguration.getAuthenticationManager();
    }

    @Bean
    public CorsFilter corsFilter() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:5173")); // Update with your allowed origins
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);

        return new CorsFilter(source);
    }
}
EOF

  # JwtAuthenticationEntryPoint.java
  cat << 'EOF' > "$BASE_DIR/security/JwtAuthenticationEntryPoint.java"
package orsk.authmodule.security;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.stereotype.Component;

import java.io.IOException;

@Component
public class JwtAuthenticationEntryPoint implements AuthenticationEntryPoint {

    @Override
    public void commence(HttpServletRequest request,
                         HttpServletResponse response,
                         AuthenticationException authException) throws IOException, ServletException {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, authException.getMessage());
    }
}
EOF

  # JwtAuthenticationFilter.java
  cat << 'EOF' > "$BASE_DIR/security/JwtAuthenticationFilter.java"
package orsk.authmodule.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;
import orsk.authmodule.service.CustomUserDetailsService;

import java.io.IOException;

@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private CustomUserDetailsService customUserDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        try {
            String jwt = getJwtFromRequest(request);

            if (jwt != null && tokenProvider.validateToken(jwt)) {
                String username = tokenProvider.getUsernameFromJWT(jwt);

                UserDetails userDetails = customUserDetailsService.loadUserByUsername(username);

                var authentication = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());

                authentication.setDetails(new WebAuthenticationDetailsSource()
                        .buildDetails(request));

                SecurityContextHolder.getContext().setAuthentication(authentication);
            }
        } catch (Exception ex) {
            logger.error("Could not set user authentication in security context", ex);
        }

        filterChain.doFilter(request, response);
    }

    private String getJwtFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
EOF

  # JwtTokenProvider.java
  cat << 'EOF' > "$BASE_DIR/security/JwtTokenProvider.java"
package orsk.authmodule.security;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.util.Date;

@Component
public class JwtTokenProvider {

    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.expiration.ms}")
    private int jwtExpirationInMs;

    private Key key;

    @PostConstruct
    public void init() {
        // Generate a secure key for HS512 using the configured jwtSecret
        if (jwtSecret != null && jwtSecret.length() >= 64) { // Ensure sufficient length for HS512
            key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
        } else {
            throw new IllegalArgumentException("JWT secret key must be at least 64 characters long");
        }
    }

    public String generateToken(Authentication authentication) {
        String username = authentication.getName();
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpirationInMs);

        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public String generateTokenFromUsername(String username) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpirationInMs);

        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(key, SignatureAlgorithm.HS512)
                .compact();
    }

    public String getUsernameFromJWT(String token) {
        Claims claims = Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token)
                .getBody();

        return claims.getSubject();
    }

    public boolean validateToken(String authToken) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(authToken);
            return true;
        } catch (Exception ex) {
            // Log the exception or handle it as needed
        }
        return false;
    }
}
EOF
}

# Function to create Exceptions
create_exceptions() {
  echo "Creating Exception classes..."

  # ResourceNotFoundException.java
  cat << 'EOF' > "$BASE_DIR/exceptions/ResourceNotFoundException.java"
package orsk.authmodule.exceptions;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
EOF

  # EmailNotFoundException.java
  cat << 'EOF' > "$BASE_DIR/exceptions/EmailNotFoundException.java"
package orsk.authmodule.exceptions;

public class EmailNotFoundException extends RuntimeException {
    public EmailNotFoundException(String message) {
        super(message);
    }
}
EOF

  # MfaRequiredException.java
  cat << 'EOF' > "$BASE_DIR/exceptions/MfaRequiredException.java"
package orsk.authmodule.exceptions;

public class MfaRequiredException extends RuntimeException {
    public MfaRequiredException(String message) {
        super(message);
    }
}
EOF

  # GlobalExceptionHandler.java
  cat << 'EOF' > "$BASE_DIR/exceptions/GlobalExceptionHandler.java"
package orsk.authmodule.exceptions;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import java.time.Instant;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.NOT_FOUND.value(),
                "Not Found",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(BadRequestException.class)
    public ResponseEntity<ErrorResponse> handleBadRequest(BadRequestException ex) {
        ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.BAD_REQUEST.value(),
                "Bad Request",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(MfaRequiredException.class)
    public ResponseEntity<ErrorResponse> handleMfaRequired(MfaRequiredException ex) {
        ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.UNAUTHORIZED.value(),
                "MFA Required",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(InvalidTokenException.class)
    public ResponseEntity<ErrorResponse> handleInvalidToken(InvalidTokenException ex) {
        ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.UNAUTHORIZED.value(),
                "Invalid Token",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.UNAUTHORIZED);
    }

    @ExceptionHandler(UserAlreadyExistsException.class)
    public ResponseEntity<ErrorResponse> handleUserAlreadyExists(UserAlreadyExistsException ex) {
        ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.CONFLICT.value(),
                "Conflict",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.CONFLICT);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGlobalException(Exception ex) {
        ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Internal Server Error",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
EOF

  # BadRequestException.java
  cat << 'EOF' > "$BASE_DIR/exceptions/BadRequestException.java"
package orsk.authmodule.exceptions;

public class BadRequestException extends RuntimeException {
    public BadRequestException(String message) {
        super(message);
    }
}
EOF

  # UserAlreadyExistsException.java
  cat << 'EOF' > "$BASE_DIR/exceptions/UserAlreadyExistsException.java"
package orsk.authmodule.exceptions;

public class UserAlreadyExistsException extends RuntimeException {
    public UserAlreadyExistsException(String message) {
        super(message);
    }
}
EOF

  # InvalidTokenException.java
  cat << 'EOF' > "$BASE_DIR/exceptions/InvalidTokenException.java"
package orsk.authmodule.exceptions;

public class InvalidTokenException extends RuntimeException {
    public InvalidTokenException(String message) {
        super(message);
    }
}
EOF

  # ErrorResponse.java
  cat << 'EOF' > "$BASE_DIR/exceptions/ErrorResponse.java"
package orsk.authmodule.exceptions;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@AllArgsConstructor
public class ErrorResponse {
    private Instant timestamp;
    private int status;
    private String error;
    private String message;
}
EOF
}

# Function to create Controllers
create_controllers() {
  echo "Creating Controller classes..."

  # AuthController.java
  cat << 'EOF' > "$BASE_DIR/controller/AuthController.java"
package orsk.authmodule.controller;

import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.web.bind.annotation.*;
import orsk.authmodule.dto.*;
import orsk.authmodule.exceptions.InvalidTokenException;
import orsk.authmodule.exceptions.MfaRequiredException;
import orsk.authmodule.service.AuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@Valid @RequestBody RegistrationRequest registrationRequest) {
        authService.registerUser(registrationRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body("User registered successfully. Please check your email for verification instructions.");
    }

    @PostMapping("/login")
    public ResponseEntity<JwtAuthenticationResponse> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            JwtAuthenticationResponse response = authService.authenticateUser(loginRequest);
            return ResponseEntity.ok(response);
        } catch (MfaRequiredException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(null); // Indicate that MFA is required
        }
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<JwtAuthenticationResponse> refreshToken(@Valid @RequestBody TokenRefreshRequest request) {
        JwtAuthenticationResponse response = authService.refreshToken(request);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logoutUser(@Valid @RequestBody LogoutRequest logoutRequest) {
        authService.logoutUser(logoutRequest);
        return ResponseEntity.ok("User logged out successfully.");
    }

    @PostMapping("/password-reset")
    public ResponseEntity<String> initiatePasswordReset(@Valid @RequestBody PasswordResetRequest passwordResetRequest) {
        authService.initiatePasswordReset(passwordResetRequest);
        return ResponseEntity.ok("Password reset instructions have been sent to your email.");
    }

    @PostMapping("/verify-email")
    public ResponseEntity<String> verifyEmail(@RequestParam("token") String token) {
        authService.verifyEmail(token);
        return ResponseEntity.ok("Email verified successfully.");
    }

    @PostMapping("/change-password")
    public ResponseEntity<String> changePassword(@Valid @RequestBody PasswordChangeRequest passwordChangeRequest) {
        authService.changePassword(passwordChangeRequest);
        return ResponseEntity.ok("Password changed successfully.");
    }

    @PostMapping("/verify-mfa")
    public ResponseEntity<String> verifyMfa(@Valid @RequestBody MfaVerificationRequest mfaVerificationRequest) {
        authService.verifyMfa(mfaVerificationRequest);
        return ResponseEntity.ok("MFA verification successful.");
    }
}
EOF
}

# Function to create Application Entry Point
create_application_entry_point() {
  echo "Creating Application entry point..."

  # AuthmoduleApplication.java
  cat << 'EOF' > "$BASE_DIR/AuthmoduleApplication.java"
package orsk.authmodule;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AuthmoduleApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuthmoduleApplication.class, args);
    }

}
EOF
}

# Function to create Remaining Models (UserRole.java)
create_additional_models() {
  echo "Creating additional Model classes..."

  # UserRole.java
  cat << 'EOF' > "$BASE_DIR/model/UserRole.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Node("UserRole")
public class UserRole {

    @Id @GeneratedValue
    private Long id;

    private String role;

    private Long roleId;

    @Relationship(type = "ASSOCIATED_WITH", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF
}

# Function to create Services
create_services() {
  echo "Creating Service classes..."

  # UserService.java
  cat << 'EOF' > "$BASE_DIR/service/UserService.java"
package orsk.authmodule.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;

import java.util.Collections;
import java.util.Optional;

@Service
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
        Optional<Role> userRoleOpt = roleRepository.findByName("ROLE_USER");
        Role userRole = userRoleOpt.orElseThrow(() -> new RuntimeException("ROLE_USER not found"));
        user.setRoles(Collections.singleton(userRole));
        return userRepository.save(user);
    }
}
EOF

  # MfaTokenService.java
  cat << 'EOF' > "$BASE_DIR/service/MfaTokenService.java"
package orsk.authmodule.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.authmodule.model.MfaToken;
import orsk.authmodule.repository.MfaTokenRepository;

import java.util.Optional;

@Service
public class MfaTokenService {

    @Autowired
    private MfaTokenRepository mfaTokenRepository;

    public Optional<MfaToken> findByMfaCode(String mfaCode) {
        return mfaTokenRepository.findByMfaCode(mfaCode);
    }

    @Transactional
    public void save(MfaToken mfaToken) {
        mfaTokenRepository.save(mfaToken);
    }
}
EOF

  # AuditLogService.java
  cat << 'EOF' > "$BASE_DIR/service/AuditLogService.java"
package orsk.authmodule.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.authmodule.model.AuditLog;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.AuditLogRepository;

import java.time.Instant;

@Service
public class AuditLogService {

    @Autowired
    private AuditLogRepository auditLogRepository;

    public void logAction(User user, String action, String ipAddress, String details) {
        AuditLog auditLog = new AuditLog();
        auditLog.setUser(user);
        auditLog.setAction(action);
        auditLog.setIpAddress(ipAddress);
        auditLog.setTimestamp(Instant.now());
        auditLog.setDetails(details);
        auditLogRepository.save(auditLog);
    }
}
EOF

  # AuthService.java
  cat << 'EOF' > "$BASE_DIR/service/AuthService.java"
package orsk.authmodule.service;

import jakarta.validation.Valid;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import orsk.authmodule.dto.*;
import orsk.authmodule.exceptions.EmailNotFoundException;
import orsk.authmodule.exceptions.InvalidTokenException;
import orsk.authmodule.exceptions.MfaRequiredException;
import orsk.authmodule.exceptions.UserAlreadyExistsException;
import orsk.authmodule.model.*;
import orsk.authmodule.repository.PasswordResetTokenRepository;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.repository.VerificationTokenRepository;
import orsk.authmodule.security.JwtTokenProvider;

import java.time.Instant;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@Service
@Validated
public class AuthService {

    private static final Logger logger = LoggerFactory.getLogger(AuthService.class);

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

    @Autowired
    private MfaTokenService mfaTokenService;

    @Autowired
    private AuditLogService auditLogService;

    // Token expiry configuration in seconds
    private static final long VERIFICATION_TOKEN_EXPIRY = 86400L; // 24 hours
    private static final long PASSWORD_RESET_TOKEN_EXPIRY = 3600L; // 1 hour
    private static final long MFA_TOKEN_EXPIRY = 300L; // 5 minutes

    @Transactional
    public void registerUser(@Valid RegistrationRequest registrationRequest) {
        if (userRepository.existsByUsernameOrEmail(registrationRequest.getUsername(), registrationRequest.getEmail())) {
            throw new UserAlreadyExistsException("Username or email already exists");
        }

        User user = new User();
        user.setUsername(registrationRequest.getUsername());
        user.setPassword(passwordEncoder.encode(registrationRequest.getPassword()));
        user.setEmail(registrationRequest.getEmail());
        user.setConsentToDataUsage(registrationRequest.getConsentToDataUsage());
        user.setEnabled(false); // User must verify email

        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("ROLE_USER not found"));
        user.setRoles(Set.of(userRole));

        userRepository.save(user);

        String token = generateVerificationToken(user);
        logger.info("Verification token generated for user {}: {}", user.getUsername(), token);

        // Placeholder for email service integration
        // emailService.sendVerificationEmail(user.getEmail(), token);

        auditLogService.logAction(user, "USER_REGISTERED", getClientIp(), "User registered successfully");
    }

    @Transactional
    public JwtAuthenticationResponse authenticateUser(@Valid LoginRequest loginRequest) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginRequest.getEmail(),
                            loginRequest.getPassword()
                    )
            );

            if (authentication == null || !authentication.isAuthenticated()) {
                throw new BadCredentialsException("Invalid email or password");
            }

            User user = userRepository.findByEmail(loginRequest.getEmail())
                    .orElseThrow(() -> new UsernameNotFoundException("User not found"));

            if (!user.getEnabled()) {
                throw new RuntimeException("User account is not enabled");
            }

            // Check if MFA is required
            boolean isMfaRequired = user.getRoles().stream()
                    .flatMap(role -> role.getPrivileges().stream())
                    .anyMatch(privilege -> privilege.getName().equals("MFA_REQUIRED"));

            if (isMfaRequired) {
                initiateMfa(user);
                auditLogService.logAction(user, "MFA_INITIATED", getClientIp(), "MFA initiated for user");
                throw new MfaRequiredException("MFA verification required");
            }

            String jwt = tokenProvider.generateToken(authentication);
            RefreshToken refreshToken = refreshTokenService.createRefreshToken(user.getUsername());

            auditLogService.logAction(user, "LOGIN_SUCCESS", getClientIp(), "User logged in successfully");

            return new JwtAuthenticationResponse(jwt, refreshToken.getToken());
        } catch (BadCredentialsException e) {
            logger.error("Authentication failed for email {}: {}", loginRequest.getEmail(), e.getMessage());
            auditLogService.logAction(null, "LOGIN_FAILURE", getClientIp(), "Invalid credentials for email: " + loginRequest.getEmail());
            throw e;
        } catch (MfaRequiredException e) {
            logger.info("MFA required for email {}: {}", loginRequest.getEmail(), e.getMessage());
            throw e;
        } catch (Exception e) {
            logger.error("Unexpected error during authentication for email {}: {}", loginRequest.getEmail(), e.getMessage());
            throw new RuntimeException("Authentication failed due to an unexpected error", e);
        }
    }

    @Transactional
    public JwtAuthenticationResponse refreshToken(@Valid TokenRefreshRequest request) {
        String requestRefreshToken = request.getRefreshToken();

        Optional<RefreshToken> refreshTokenOpt = refreshTokenService.findByToken(requestRefreshToken);

        if (refreshTokenOpt.isEmpty()) {
            throw new InvalidTokenException("Refresh token not found");
        }

        RefreshToken refreshToken = refreshTokenService.verifyExpiration(refreshTokenOpt.get());

        User user = refreshToken.getUser();

        String token = tokenProvider.generateTokenFromUsername(user.getUsername());
        logger.info("Refresh token used for user {}", user.getUsername());

        auditLogService.logAction(user, "TOKEN_REFRESHED", getClientIp(), "Access token refreshed using refresh token");

        return new JwtAuthenticationResponse(token, requestRefreshToken);
    }

    @Transactional
    public void logoutUser(@Valid LogoutRequest logoutRequest) {
        refreshTokenService.deleteByToken(logoutRequest.getRefreshToken());
        logger.info("User logged out with refresh token {}", logoutRequest.getRefreshToken());
        auditLogService.logAction(null, "USER_LOGOUT", getClientIp(), "User logged out with refresh token");
    }

    @Transactional
    public void initiatePasswordReset(@Valid PasswordResetRequest passwordResetRequest) {
        User user = userRepository.findByEmail(passwordResetRequest.getEmail())
                .orElseThrow(() -> new EmailNotFoundException("Email not found"));

        String token = UUID.randomUUID().toString();
        PasswordResetToken passwordResetToken = new PasswordResetToken();
        passwordResetToken.setToken(token);
        passwordResetToken.setUser(user);
        passwordResetToken.setExpiryDate(Instant.now().plusSeconds(PASSWORD_RESET_TOKEN_EXPIRY));

        passwordResetTokenRepository.save(passwordResetToken);

        logger.info("Password reset token generated for user {}: {}", user.getUsername(), token);

        // Placeholder for email service integration
        // emailService.sendPasswordResetEmail(user.getEmail(), token);

        auditLogService.logAction(user, "PASSWORD_RESET_INITIATED", getClientIp(), "Password reset initiated");
    }

    @Transactional
    public void verifyEmail(String token) {
        VerificationToken verificationToken = verificationTokenRepository.findByToken(token)
                .orElseThrow(() -> new InvalidTokenException("Invalid verification token"));

        if (verificationToken.getExpiryDate().isBefore(Instant.now())) {
            throw new InvalidTokenException("Verification token expired");
        }

        User user = verificationToken.getUser();
        user.setEnabled(true);

        userRepository.save(user);
        verificationTokenRepository.delete(verificationToken);

        logger.info("User {} email verified successfully", user.getUsername());

        auditLogService.logAction(user, "EMAIL_VERIFIED", getClientIp(), "User email verified successfully");
    }

    @Transactional
    public void changePassword(@Valid PasswordChangeRequest passwordChangeRequest) {
        String token = passwordChangeRequest.getToken();

        User user = userRepository.findByPasswordResetTokens_Token(token)
                .orElseThrow(() -> new InvalidTokenException("Invalid password reset token"));

        PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(token)
                .orElseThrow(() -> new InvalidTokenException("Invalid password reset token"));

        // Validate token expiration
        if (resetToken.getExpiryDate().isBefore(Instant.now())) {
            throw new InvalidTokenException("Password reset token expired");
        }

        // Update the password
        user.setPassword(passwordEncoder.encode(passwordChangeRequest.getNewPassword()));
        user.setPasswordResetTokens(Set.of()); // Clear all password reset tokens

        userRepository.save(user);
        passwordResetTokenRepository.delete(resetToken);

        logger.info("Password successfully changed for user {}", user.getUsername());

        auditLogService.logAction(user, "PASSWORD_CHANGED", getClientIp(), "User changed password successfully");
    }

    @Transactional
    public void verifyMfa(@Valid MfaVerificationRequest mfaVerificationRequest) {
        String mfaCode = mfaVerificationRequest.getMfaCode();

        Optional<MfaToken> mfaTokenOpt = mfaTokenService.findByMfaCode(mfaCode);

        if (mfaTokenOpt.isEmpty()) {
            throw new InvalidTokenException("Invalid MFA code");
        }

        MfaToken mfaToken = mfaTokenOpt.get();

        if (mfaToken.getExpiryDate().isBefore(Instant.now())) {
            throw new InvalidTokenException("MFA code expired");
        }

        if (mfaToken.getUsed()) {
            throw new InvalidTokenException("MFA code has already been used");
        }

        User user = mfaToken.getUser();
        mfaToken.setUsed(true); // Mark MFA code as used
        mfaTokenService.save(mfaToken);

        // Generate JWT and Refresh Token
        String jwt = tokenProvider.generateTokenFromUsername(user.getUsername());
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user.getUsername());

        logger.info("MFA verified successfully for user {}", user.getUsername());

        auditLogService.logAction(user, "MFA_VERIFIED", getClientIp(), "User MFA verified successfully");

        // Optionally, return tokens or handle as per your application's flow
    }

    private String generateVerificationToken(User user) {
        String token = UUID.randomUUID().toString();

        VerificationToken verificationToken = new VerificationToken();
        verificationToken.setToken(token);
        verificationToken.setUser(user);
        verificationToken.setExpiryDate(Instant.now().plusSeconds(VERIFICATION_TOKEN_EXPIRY));

        verificationTokenRepository.save(verificationToken);
        return token;
    }

    private void initiateMfa(User user) {
        String mfaCode = generateMfaCode();
        MfaToken mfaToken = new MfaToken();
        mfaToken.setMfaCode(mfaCode);
        mfaToken.setUser(user);
        mfaToken.setExpiryDate(Instant.now().plusSeconds(MFA_TOKEN_EXPIRY));

        mfaTokenService.save(mfaToken);

        logger.info("MFA code generated for user {}: {}", user.getUsername(), mfaCode);

        // Placeholder for MFA code sending logic (e.g., SMS, Email, Authenticator App)
        // mfaService.sendMfaCode(user.getEmail(), mfaCode);
    }

    private String generateMfaCode() {
        // Generate a 6-digit random MFA code
        int code = (int) (Math.random() * 900000) + 100000;
        return String.valueOf(code);
    }

    private String getClientIp() {
        // Implement logic to retrieve client's IP address from the request
        // This typically involves accessing HttpServletRequest, which may require additional configuration
        return "0.0.0.0"; // Placeholder
    }
}
EOF

  # RefreshTokenService.java
  cat << 'EOF' > "$BASE_DIR/service/RefreshTokenService.java"
package orsk.authmodule.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.authmodule.exceptions.InvalidTokenException;
import orsk.authmodule.model.RefreshToken;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RefreshTokenRepository;
import orsk.authmodule.repository.UserRepository;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service
public class RefreshTokenService {

    private static final long REFRESH_TOKEN_EXPIRY = 604800L; // 7 days

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private UserRepository userRepository;

    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }

    @Transactional
    public RefreshToken createRefreshToken(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUser(user);
        refreshToken.setExpiryDate(Instant.now().plusSeconds(REFRESH_TOKEN_EXPIRY));
        refreshToken.setToken(UUID.randomUUID().toString());

        return refreshTokenRepository.save(refreshToken);
    }

    public RefreshToken verifyExpiration(RefreshToken token) {
        if (token.getExpiryDate().isBefore(Instant.now())) {
            refreshTokenRepository.delete(token);
            throw new InvalidTokenException("Refresh token expired");
        }

        return token;
    }

    @Transactional
    public void deleteByUserId(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        refreshTokenRepository.deleteByUser(user);
    }

    @Transactional
    public void deleteByToken(String token) {
        refreshTokenRepository.findByToken(token).ifPresent(refreshTokenRepository::delete);
    }
}
EOF

  # CustomUserDetailsService.java
  cat << 'EOF' > "$BASE_DIR/service/CustomUserDetailsService.java"
package orsk.authmodule.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.*;
import org.springframework.stereotype.Service;
import orsk.authmodule.model.Privilege;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.UserRepository;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository userRepository;

    @Override
    public UserDetails loadUserByUsername(String usernameOrEmail) throws UsernameNotFoundException {
        User user = userRepository.findByUsername(usernameOrEmail)
                .or(() -> userRepository.findByEmail(usernameOrEmail))
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username or email: " + usernameOrEmail));

        List<SimpleGrantedAuthority> authorities = user.getRoles().stream()
                .flatMap(role -> role.getPrivileges().stream())
                .map(Privilege::getName)
                .distinct()
                .map(SimpleGrantedAuthority::new)
                .collect(Collectors.toList());

        return new org.springframework.security.core.userdetails.User(
                user.getUsername(),
                user.getPassword(),
                user.getEnabled(),
                true,
                true,
                true,
                authorities);
    }
}
EOF
}

# Function to create Application Class
create_application_class() {
  echo "Creating Application class..."

  # AuthmoduleApplication.java
  cat << 'EOF' > "$BASE_DIR/AuthmoduleApplication.java"
package orsk.authmodule;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AuthmoduleApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuthmoduleApplication.class, args);
    }

}
EOF
}

# Function to create Additional Models
create_additional_models() {
  echo "Creating additional Model classes..."

  # UserRole.java
  cat << 'EOF' > "$BASE_DIR/model/UserRole.java"
package orsk.authmodule.model;

import org.springframework.data.mysql.core.schema.GeneratedValue;
import org.springframework.data.mysql.core.schema.Id;
import org.springframework.data.mysql.core.schema.Node;
import org.springframework.data.mysql.core.schema.Relationship;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Node("UserRole")
public class UserRole {

    @Id @GeneratedValue
    private Long id;

    private String role;

    private Long roleId;

    @Relationship(type = "ASSOCIATED_WITH", direction = Relationship.Direction.OUTGOING)
    private User user;
}
EOF
}

# ----------------------------
# Script Execution
# ----------------------------

# Check if BASE_DIR exists
if [ ! -d "$BASE_DIR" ]; then
  echo "Error: Base directory '$BASE_DIR' does not exist."
  exit 1
fi

# Create directories
create_directories

# Create DTOs
create_dtos

# Create Repositories
create_repositories

# Create Models
create_models

# Create Security Configurations
create_security_configurations

# Create Exceptions
create_exceptions

# Create Controllers
create_controllers

# Create Services
create_services

# Create Application Entry Point
create_application_class

# Create Additional Models
create_additional_models

# Final message
echo "Migration to mysql completed successfully!"
echo "All necessary Java files for mysql integration have been created."
echo "Please review the generated files, integrate them into your project, and configure your application properties accordingly."
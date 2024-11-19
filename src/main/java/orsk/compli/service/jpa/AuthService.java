package orsk.compli.service.jpa;

import org.hibernate.event.service.spi.EventListenerRegistrationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.dtos.*;
import orsk.compli.entities.jpa.PasswordResetToken;
import orsk.compli.entities.jpa.RefreshToken;
import orsk.compli.entities.jpa.User;
import orsk.compli.entities.jpa.VerificationToken;
import orsk.compli.repository.jpa.PasswordResetTokenJpaRepository;
import orsk.compli.repository.jpa.RoleJpaRepository;
import orsk.compli.repository.jpa.UserJpaRepository;
import orsk.compli.repository.jpa.VerificationTokenJpaRepository;
import orsk.compli.security.JwtTokenProvider;

import javax.management.relation.RoleNotFoundException;
import java.time.Instant;
import java.util.Set;
import java.util.UUID;

@Service("jpaAuthService")
public class AuthService {

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private UserJpaRepository userRepository;

    @Autowired
    private RoleJpaRepository roleRepository;

    @Autowired
    private VerificationTokenJpaRepository verificationTokenRepository;

    @Autowired
    private PasswordResetTokenJpaRepository passwordResetTokenRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider tokenProvider;

    @Autowired
    private RefreshTokenJpaService refreshTokenService;



    @Transactional
    public void registerUser(RegistrationRequest registrationRequest) {
        if (userRepository.findByUsername(registrationRequest.getUsername()).isPresent()) {
            System.out.println("Username taken");
        }
        if (userRepository.findByEmail(registrationRequest.getEmail()).isPresent()) {
            System.out.println("Email already exists");
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

            // Generate verification token
            String token = generateVerificationToken(user);

            // Send verification email
            //emailService.sendVerificationEmail(user.getEmail(), token);

        } catch (Exception e) {
            // Log error and handle exception
            throw new EventListenerRegistrationException("Registration failed due to an unexpected error");
        }
    }

    @Transactional
    public JwtAuthenticationResponse authenticateUser(LoginRequest loginRequest) {
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        loginRequest.getEmail(),
                        loginRequest.getPassword()
                )
        );

        String jwt = tokenProvider.generateToken(authentication);

        RefreshToken refreshToken = refreshTokenService.createRefreshToken(authentication.getName());

        return new JwtAuthenticationResponse(jwt, refreshToken.getToken());
    }

    @Transactional
    public JwtAuthenticationResponse refreshToken(TokenRefreshRequest request) {
        String requestRefreshToken = request.getRefreshToken();

        return refreshTokenService.findByToken(requestRefreshToken)
                .map(refreshTokenService::verifyExpiration)
                .map(RefreshToken::getUser)
                .map(user -> {
                    String token = tokenProvider.generateTokenFromUsername(user.getUsername());
                    return new JwtAuthenticationResponse(token, requestRefreshToken);
                })
                .orElseThrow(() -> new RuntimeException("Refresh token not found"));
    }

    @Transactional
    public void logoutUser(LogoutRequest logoutRequest) {
        refreshTokenService.deleteByToken(logoutRequest.getRefreshToken());
    }

    @Transactional
    public void initiatePasswordReset(PasswordResetRequest passwordResetRequest) {
        User user = userRepository.findByEmail(passwordResetRequest.getEmail())
                .orElseThrow(() -> new RuntimeException("Email not found"));

        String token = UUID.randomUUID().toString();
        PasswordResetToken passwordResetToken = new PasswordResetToken();
        passwordResetToken.setToken(token);
        passwordResetToken.setUser(user);
        passwordResetToken.setExpiryDate(Instant.now().plusSeconds(3600)); // 1 hour expiry

        passwordResetTokenRepository.save(passwordResetToken);

      }

    @Transactional
    public void changePassword(PasswordChangeRequest passwordChangeRequest) {
        PasswordResetToken passwordResetToken = passwordResetTokenRepository.findByToken(passwordChangeRequest.getToken())
                .orElseThrow(() -> new RuntimeException("Invalid password reset token"));

        if (passwordResetToken.getExpiryDate().isBefore(Instant.now())) {
            throw new RuntimeException("Password reset token expired");
        }

        User user = passwordResetToken.getUser();
        user.setPassword(passwordEncoder.encode(passwordChangeRequest.getNewPassword()));

        userRepository.save(user);

        passwordResetTokenRepository.delete(passwordResetToken);
    }

    @Transactional
    public void verifyEmail(String token) {
        VerificationToken verificationToken = verificationTokenRepository.findByToken(token)
                .orElseThrow(() -> new RuntimeException("Invalid verification token"));

        User user = verificationToken.getUser();
        user.setEnabled(true);

        userRepository.save(user);

        verificationTokenRepository.delete(verificationToken);
    }

    private String generateVerificationToken(User user) {
        String token = UUID.randomUUID().toString();

        VerificationToken verificationToken = new VerificationToken();
        verificationToken.setToken(token);
        verificationToken.setUser(user);
        verificationToken.setExpiryDate(Instant.now().plusSeconds(86400)); // 24 hours expiry

        verificationTokenRepository.save(verificationToken);

        return token;
    }
}

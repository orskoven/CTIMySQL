// File: AuthService.java
package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
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

@Service
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
        String email= registrationRequest.getEmail();

        if (userRepository.findByUsername(registrationRequest.getUsername()).isPresent()) {
            throw new RuntimeException("Username already exists");
        }

        if (userRepository.findByEmail(email).isPresent()) {
            throw new RuntimeException("Email already exists");
        }


        try {
            User user = new User();
            user.setUsername(registrationRequest.getUsername());
            user.setPassword(passwordEncoder.encode(registrationRequest.getPassword()));
            user.setEmail(registrationRequest.getEmail());

            user.setConsentToDataUsage(registrationRequest.getConsentToDataUsage());

            // Assign ROLE_USER
            user.setRoles(Set.of(roleRepository.findByName("ROLE_USER")
                    .orElseThrow(() -> new RoleNotFoundException("Default role 'ROLE_USER' not found"))));

            userRepository.save(user);

            // Generate verification token
            String token = generateVerificationToken(user);

            // Send verification email (external implementation)
            // emailService.sendVerificationEmail(registrationRequest.getEmail(), token);
        } catch (Exception e) {
            throw new RuntimeException("Registration failed due to an unexpected error", e);
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

        SecurityContextHolder.getContext().setAuthentication(authentication);

        String jwt = tokenProvider.generateAccessToken(authentication);

        // Generate and save refresh token
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(authentication.getName());

        return new JwtAuthenticationResponse(jwt, refreshToken.getToken(), "Bearer");
    }


    private boolean isValidEmail(String email) {
        return email.contains("@");
    }

    @Transactional
    public JwtAuthenticationResponse refreshToken(TokenRefreshRequest request) {
        String requestRefreshToken = request.getRefreshToken();

        RefreshToken refreshToken = refreshTokenService.findByToken(requestRefreshToken)
                .orElseThrow(() -> new RuntimeException("Refresh token not found"));

        refreshTokenService.verifyExpiration(refreshToken);

        User user = refreshToken.getUser();
        String token = tokenProvider.generateRefreshToken(user.getUsername());

        // Optionally, generate a new refresh token
        RefreshToken newRefreshToken = refreshTokenService.createRefreshToken(user.getUsername());

        // Delete the old refresh token
        refreshTokenService.deleteByToken(requestRefreshToken);

        return new JwtAuthenticationResponse(token, newRefreshToken.getToken(), "Bearer");
    }

    @Transactional
    public void logoutUser(LogoutRequest logoutRequest) {
        refreshTokenService.deleteByToken(logoutRequest.getRefreshToken());
    }

    @Transactional
    public void initiatePasswordReset(PasswordResetRequest passwordResetRequest) {
        String email = passwordResetRequest.getEmail();
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Email not found"));

        String token = UUID.randomUUID().toString();
        PasswordResetToken passwordResetToken = new PasswordResetToken();
        passwordResetToken.setToken(token);
        passwordResetToken.setUser(user);
        passwordResetToken.setExpiryDate(Instant.now().plusSeconds(3600)); // 1 hour expiry

        passwordResetTokenRepository.save(passwordResetToken);

        // Send password reset email (external implementation)
        // emailService.sendPasswordResetEmail(passwordResetRequest.getEmail(), token);
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

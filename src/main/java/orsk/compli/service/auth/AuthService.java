package orsk.compli.service.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import orsk.compli.dtos.auth.*;
import orsk.compli.entities.*;
import orsk.compli.exception.auth.EmailNotFoundException;
import orsk.compli.exception.auth.InvalidTokenException;
import orsk.compli.exception.auth.MfaRequiredException;
import orsk.compli.exception.auth.UserAlreadyExistsException;
import orsk.compli.repository.auth.*;
import orsk.compli.security.JwtTokenProvider;


import java.time.Instant;
import java.time.chrono.ChronoLocalDateTime;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

@Service("AuthService")
@Validated
@RequiredArgsConstructor
@Slf4j
public class AuthService {

    private final PasswordEncoder passwordEncoder;
    private final AuthenticationManager authenticationManager;
    private final UserRepository userRepository;
    private final RoleRepository roleRepository;
    private final VerificationTokenRepository verificationTokenRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final JwtTokenProvider tokenProvider;
    private final RefreshTokenService refreshTokenService;
    private final MfaTokenService mfaTokenService;
    private final AuditLogService auditLogService;
    private final EmailService emailService;
    private final MfaTokenRepository mfaTokenRepository;

    private static final long VERIFICATION_TOKEN_EXPIRY = 86400L; // 24 hours
    private static final long PASSWORD_RESET_TOKEN_EXPIRY = 3600L; // 1 hour

    // User Registration
    @Transactional(rollbackFor = {UserAlreadyExistsException.class})
    public void registerUser(@Valid RegistrationRequest registrationRequest) {
        if (userRepository.existsByUsernameOrEmail(registrationRequest.getUsername(), registrationRequest.getEmail())) {
            throw new UserAlreadyExistsException("Username or email already exists");
        }

        User user = new User();
        user.setUsername(registrationRequest.getUsername());
        user.setPassword(passwordEncoder.encode(registrationRequest.getPassword()));
        user.setEmail(registrationRequest.getEmail());
        user.setConsentToDataUsage(Optional.of(registrationRequest.getConsentToDataUsage()).orElse(false));
        user.setEnabled(false);

        // Fetch the role from the database
        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("ROLE_USER not found"));

        // Add the fetched role to the user
        user.getRoles().add(userRole);

        userRepository.save(user);

        String token = generateVerificationToken(user);
        log.info("Verification token generated for user {}: {}", user.getUsername(), token);

        emailService.sendVerificationEmail(user.getEmail(), token);

        auditLogService.logAction(user, "USER_REGISTERED", getClientIp(), "User registered successfully");
    }

    @Transactional
    public JwtAuthenticationResponse authenticateUser(@Valid LoginRequest loginRequest) {
        Authentication authentication = authenticate(loginRequest);

        User user = findUserByEmail(loginRequest.getEmail());
        validateUserEnabled(user);

        String jwt = tokenProvider.generateToken(authentication);
        RefreshToken refreshToken = refreshTokenService.createRefreshToken(user.getUsername());

        auditLogService.logAction(user, "LOGIN_SUCCESS", getClientIp(), "User logged in successfully");

        return JwtAuthenticationResponse.builder()
                .accessToken(jwt)
                .refreshToken(refreshToken.getToken())
                .build();
    }

    @Transactional
    public void logoutUser(@Valid LogoutRequest logoutRequest) {
        refreshTokenService.deleteByToken(logoutRequest.getRefreshToken());
        log.info("User logged out with refresh token {}", logoutRequest.getRefreshToken());
        auditLogService.logAction(null, "USER_LOGOUT", getClientIp(), "User logged out");
    }

    @Transactional
    public void changePassword(@Valid PasswordChangeRequest passwordChangeRequest) {
        PasswordResetToken resetToken = validatePasswordResetToken(passwordChangeRequest.getToken());
        User user = resetToken.getUser();

        user.setPassword(passwordEncoder.encode(passwordChangeRequest.getNewPassword()));
        userRepository.save(user);

        passwordResetTokenRepository.delete(resetToken);

        log.info("Password successfully changed for user {}", user.getUsername());
        auditLogService.logAction(user, "PASSWORD_CHANGED", getClientIp(), "User changed password successfully");
    }

    @Transactional
    public void verifyEmail(String token) {
        VerificationToken verificationToken = validateVerificationToken(token);

        User user = verificationToken.getUser();
        user.setEnabled(true);
        userRepository.save(user);
        verificationTokenRepository.delete(verificationToken);

        auditLogService.logAction(user, "EMAIL_VERIFIED", getClientIp(), "User verified email successfully");
    }

    @Transactional
    public void initiatePasswordReset(PasswordResetRequest passwordResetRequest) {
        User user = findUserByEmail(passwordResetRequest.getEmail());

        String token = UUID.randomUUID().toString();
        PasswordResetToken resetToken = createPasswordResetToken(user, token);

        emailService.sendPasswordResetEmail(user.getEmail(), token);
        auditLogService.logAction(user, "PASSWORD_RESET_INITIATED", getClientIp(), "User requested password reset");
    }

    @Transactional(readOnly = true)
    public UserProfileResponse getUserProfile(String username) {
        User user = findUserByUsername(username);

        return new UserProfileResponse(
                user.getUsername(),
                user.getEmail(),
                user.getRoles().stream().map(Role::getName).toList(),
                user.getEnabled()
        );
    }

    // Helper Methods

    private void validateUserExistence(String username, String email) {
        if (userRepository.existsByUsernameOrEmail(username, email)) {
            throw new UserAlreadyExistsException("Username or email already exists");
        }
    }

    private User createUser(RegistrationRequest registrationRequest) {
        Role userRole = roleRepository.findByName("ROLE_USER")
                .orElseThrow(() -> new RuntimeException("ROLE_USER not found"));

        User user = new User();
        user.setUsername(registrationRequest.getUsername());
        user.setPassword(passwordEncoder.encode(registrationRequest.getPassword()));
        user.setEmail(registrationRequest.getEmail());
        user.setConsentToDataUsage(Optional.of(registrationRequest.getConsentToDataUsage()).orElse(false));
        user.setEnabled(false);
        user.setRoles(Set.of(userRole));

        return userRepository.save(user);
    }

    private Authentication authenticate(LoginRequest loginRequest) {
        try {
            return authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(
                            loginRequest.getEmail(),
                            loginRequest.getPassword()
                    )
            );
        } catch (BadCredentialsException ex) {
            auditLogService.logAction(null, "LOGIN_FAILURE", getClientIp(), "Invalid credentials");
            throw ex;
        }
    }

    private User findUserByEmail(String email) {
        return userRepository.findByEmail(email)
                .orElseThrow(() -> new EmailNotFoundException("User not found with email: " + email));
    }

    private User findUserByUsername(String username) {
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found with username: " + username));
    }

    private void validateUserEnabled(User user) {
        if (!Boolean.TRUE.equals(user.getEnabled())) {
            throw new RuntimeException("User account is not enabled");
        }
    }

    private PasswordResetToken createPasswordResetToken(User user, String token) {
        PasswordResetToken resetToken = new PasswordResetToken();
        resetToken.setUser(user);
        resetToken.setToken(token);
        resetToken.setExpiryDate(Instant.now().plusSeconds(PASSWORD_RESET_TOKEN_EXPIRY));
        return passwordResetTokenRepository.save(resetToken);
    }

    private VerificationToken validateVerificationToken(String token) {
        return verificationTokenRepository.findByToken(token)
                .orElseThrow(() -> new InvalidTokenException("Invalid verification token"));
    }

    private PasswordResetToken validatePasswordResetToken(String token) {
        PasswordResetToken resetToken = passwordResetTokenRepository.findByToken(token)
                .orElseThrow(() -> new InvalidTokenException("Invalid password reset token"));
        if (resetToken.getExpiryDate().isBefore(Instant.now())) {
            throw new InvalidTokenException("Password reset token expired");
        }
        return resetToken;
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

    private String getClientIp() {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attrs == null) return "UNKNOWN_IP";
        HttpServletRequest request = attrs.getRequest();
        String ipAddress = request.getHeader("X-Forwarded-For");
        if (ipAddress == null || ipAddress.isBlank() || "unknown".equalsIgnoreCase(ipAddress)) {
            ipAddress = request.getRemoteAddr();
        }
        return ipAddress;
    }

    @Transactional
    public JwtAuthenticationResponse refreshToken(String refreshToken) {
        RefreshToken token = refreshTokenService.findByToken(refreshToken)
                .orElseThrow(() -> new InvalidTokenException("Invalid refresh token"));

        refreshTokenService.verifyExpiration(token);

        User user = token.getUser();
        String newAccessToken = tokenProvider.generateTokenFromUsername(user.getUsername());

        return JwtAuthenticationResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(refreshToken)
                .build();
    }
    @Transactional
    public void verifyMfa(MfaVerificationRequest mfaVerificationRequest) {
        MfaToken mfaToken = mfaTokenRepository.findByMfaCode(mfaVerificationRequest.getMfaCode())
                .orElseThrow(() -> new MfaRequiredException("Invalid MFA code"));

        if (mfaToken.getExpiryDate().isBefore(ChronoLocalDateTime.from(Instant.now())) || Boolean.TRUE.equals(mfaToken.getUsed())) {
            throw new MfaRequiredException("MFA code expired or already used");
        }

        mfaToken.setUsed(true);
        mfaTokenRepository.save(mfaToken);
        auditLogService.logAction(mfaToken.getUser(), "MFA_VERIFIED", getClientIp(), "User verified MFA successfully");
    }
/*
    private void sendMfaCode(String email, String mfaCode) {
        // Check if the user prefers SMS or email for MFA
        if (userPrefersSms) {
            // Use Twilio to send the MFA code via SMS
            Twilio.init(accountSid, authToken);
            Message message = Message.creator(new PhoneNumber("+1234567890"), "+0987654321", "Your MFA code is: " + mfaCode).create();
            log.info("MFA code sent via SMS: {}", message.getSid());
        } else {
            // Use Spring Boot's EmailSender to send the MFA code via email
            SimpleMailMessage mailMessage = new SimpleMailMessage();
            mailMessage.setFrom("noreply@example.com");
            mailMessage.setTo(email);
            mailMessage.setSubject("Your MFA Code");
            mailMessage.setText("Your MFA code is: " + mfaCode);
            emailSender.send(mailMessage);
            log.info("MFA code sent via email: {}", mailMessage.getSubject());
        }
    }

 */
}
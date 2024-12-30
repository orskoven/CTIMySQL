package orsk.compli.controller.auth;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import orsk.compli.dtos.auth.*;
import orsk.compli.entities.User;
import orsk.compli.exception.auth.InvalidTokenException;
import orsk.compli.exception.auth.MfaRequiredException;
import orsk.compli.repository.auth.UserRepository;
import orsk.compli.service.auth.AuditLogService;
import orsk.compli.service.auth.AuthService;
import orsk.compli.service.auth.MfaTokenService;

@RestController
@RequestMapping("/api/auth")
@RequiredArgsConstructor
@Slf4j
public class AuthController {

    private final AuthService authService;
    private final UserRepository userRepository;
    private final MfaTokenService mfaTokenService;
    private final AuditLogService auditLogService;

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@Valid @RequestBody RegistrationRequest registrationRequest) {
        if (userRepository.existsByUsernameOrEmail(registrationRequest.getEmail(), registrationRequest.getUsername())) {
            log.warn("Attempt to register with existing email/username: email={}, username={}",
                     registrationRequest.getEmail(), registrationRequest.getUsername());
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body("Email or Username already exists.");
        }
        authService.registerUser(registrationRequest);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body("User registered successfully. Please check your email for verification instructions.");
    }

    @PostMapping("/login")
    public ResponseEntity<JwtAuthenticationResponse> authenticateUser(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            JwtAuthenticationResponse response = authService.authenticateUser(loginRequest);
            return ResponseEntity.ok(response);
        } catch (MfaRequiredException e) {
            log.info("MFA required for email: {}", loginRequest.getEmail());
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body(JwtAuthenticationResponse.ofMessage("MFA required"));
        } catch (BadCredentialsException e) {
            log.info("Invalid credentials for email: {}", loginRequest.getEmail());
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                    .body(JwtAuthenticationResponse.ofMessage("Invalid credentials"));
        }
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<JwtAuthenticationResponse> refreshToken(@Valid @RequestBody TokenRefreshRequest request) {
        // Use the refresh token service to refresh the token
        JwtAuthenticationResponse response = authService.refreshToken(request.getRefreshToken());
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
        try {
            authService.verifyEmail(token);
            return ResponseEntity.ok("Email verified successfully.");
        } catch (InvalidTokenException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token.");
        }
    }

    @PostMapping("/change-password")
    public ResponseEntity<String> changePassword(@Valid @RequestBody PasswordChangeRequest passwordChangeRequest) {
        authService.changePassword(passwordChangeRequest);
        return ResponseEntity.ok("Password changed successfully.");
    }

    @PostMapping("/verify-mfa")
    public ResponseEntity<String> verifyMfa(@Valid @RequestBody MfaVerificationRequest mfaRequest) {
        User user = userRepository.findByEmail(mfaRequest.getEmail())
                .orElseThrow(() -> new UsernameNotFoundException("User not found with email: " + mfaRequest.getEmail()));

        boolean isVerified = mfaTokenService.verifyMfaCode(mfaRequest.getMfaCode(), user);
        if (!isVerified) {
            throw new BadCredentialsException("Invalid or expired MFA code");
        }

        // Log the action with the correct IP address retrieval
        auditLogService.logAction(user, "MFA_VERIFIED", getClientIp(), "MFA code verified successfully");

        return ResponseEntity.ok("MFA verified successfully");
    }

    // Helper method to get client IP address
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

    @GetMapping("/user-profile")
    public ResponseEntity<UserProfileResponse> getUserProfile(@RequestParam String username) {
        UserProfileResponse profile = authService.getUserProfile(username);
        return ResponseEntity.ok(profile);
    }
}
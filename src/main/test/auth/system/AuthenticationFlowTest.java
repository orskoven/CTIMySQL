package auth.system;/*
package orsk.authmodule.system;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import orsk.authmodule.dto.LoginRequest;
import orsk.authmodule.dto.MfaVerificationRequest;
import orsk.authmodule.dto.RegistrationRequest;
import orsk.authmodule.repository.MfaTokenRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.repository.VerificationTokenRepository;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class AuthenticationFlowTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private VerificationTokenRepository verificationTokenRepository;

    @Autowired
    private MfaTokenRepository mfaTokenRepository;

    @Autowired
    private UserRepository userRepository;

    /**
     * Full end-to-end test for user registration, email verification, MFA, and login.
     
    @Test
    @DisplayName("System Test: Complete Authentication Flow with MFA")
    public void testCompleteAuthenticationFlow() throws Exception {
        // Step 1: Register User
        String username = "flowUser";
        String email = "flowuser@example.com";
        String password = "StrongPassword@123";

        registerUser(username, email, password);

        // Step 2: Simulate Email Verification
        String verificationToken = fetchVerificationToken(email);
        verifyEmail(verificationToken);

        // Step 3: Attempt Login (Expect MFA Required)
        attemptLoginWithMfa(email, password);

        // Step 4: Verify MFA
        String mfaCode = fetchMfaCode(username);
        verifyMfa(mfaCode);

        // Step 5: Confirm Successful Post-MFA Login
        confirmProtectedAccess();
    }

    /**
     * Parameterized test to validate registration inputs.
     
    @ParameterizedTest
    @CsvSource({
            "validUser, valid@example.com, StrongPassword@123, true",
            "invalidUser, invalid-email, weak, false"
    })
    @DisplayName("Parameterized Test: Registration with Varying Input")
    public void testRegistrationWithVaryingInput(String username, String email, String password, boolean isValid) throws Exception {
        RegistrationRequest request = RegistrationRequest.builder()
                .username(username)
                .email(email)
                .password(password)
                .consentToDataUsage(true)
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(isValid ? status().isCreated() : status().isBadRequest());
    }

    /**
     * Validates behavior when attempting to register a duplicate user.
     
    @Test
    @DisplayName("Edge Case: Duplicate User Registration")
    public void testDuplicateUserRegistration() throws Exception {
        String username = "duplicateUser";
        String email = "duplicate@example.com";
        String password = "StrongPassword@123";

        registerUser(username, email, password);

        RegistrationRequest duplicateUser = RegistrationRequest.builder()
                .username(username)
                .email(email)
                .password(password)
                .consentToDataUsage(true)
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(duplicateUser)))
                .andExpect(status().isConflict())
                .andExpect(content().string("Username or email already exists."));
    }

    // --- Helper Methods ---

    private void registerUser(String username, String email, String password) throws Exception {
        RegistrationRequest registrationRequest = RegistrationRequest.builder()
                .username(username)
                .email(email)
                .password(password)
                .consentToDataUsage(true)
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(registrationRequest)))
                .andExpect(status().isCreated())
                .andExpect(content().string("User registered successfully. Please check your email for verification instructions."));

        assertThat(userRepository.findByUsername(username)).isNotNull();
    }

    private void verifyEmail(String token) throws Exception {
        mockMvc.perform(post("/api/auth/verify-email")
                        .param("token", token))
                .andExpect(status().isOk())
                .andExpect(content().string("Email verified successfully."));
    }

    private void attemptLoginWithMfa(String email, String password) throws Exception {
        LoginRequest loginRequest = LoginRequest.builder()
                .email(email)
                .password(password)
                .build();

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isForbidden())
                .andExpect(content().string("MFA verification required"));
    }

    private void verifyMfa(String mfaCode) throws Exception {
        MfaVerificationRequest mfaRequest = MfaVerificationRequest.builder()
                .mfaCode(mfaCode)
                .build();

        mockMvc.perform(post("/api/auth/verify-mfa")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(mfaRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("MFA verification successful."));
    }

    private void confirmProtectedAccess() throws Exception {
        // Mock JWT token; replace with actual implementation for token retrieval
        String jwtToken = "mockedJwtToken";

        mockMvc.perform(post("/api/protected-endpoint")
                        .header("Authorization", "Bearer " + jwtToken))
                .andExpect(status().isOk());
    }

    private String fetchVerificationToken(String email) {
        return verificationTokenRepository.findByUserEmail(email)
                .orElseThrow(() -> new IllegalStateException("Verification token not found for email: " + email))
                .getToken();
    }

    private String fetchMfaCode(String username) {
        return mfaTokenRepository.findByUserUsername(username)
                .orElseThrow(() -> new IllegalStateException("MFA code not found for username: " + username))
                .getMfaCode();
    }
}
*/
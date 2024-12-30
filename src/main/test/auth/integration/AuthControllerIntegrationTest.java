package auth.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import orsk.authmodule.dto.LoginRequest;
import orsk.authmodule.dto.RegistrationRequest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class AuthControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    // Helper Methods
    private String registerUser(String username, String email) throws Exception {
        RegistrationRequest registrationRequest = RegistrationRequest.builder()
                .username(username)
                .email(email)
                .password("StrongPassword@123")
                .consentToDataUsage(true)
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(registrationRequest)))
                .andExpect(status().isCreated())
                .andExpect(content().string("User registered successfully. Please check your email for verification instructions."));

        // Simulate email verification (fetch token from a mock service or database)
        return "mockVerificationToken";
    }

    private void verifyEmail(String token) throws Exception {
        mockMvc.perform(post("/api/auth/verify-email")
                        .param("token", token))
                .andExpect(status().isOk())
                .andExpect(content().string("Email verified successfully."));
    }

    private void loginUserWithMfa(String email, String password) throws Exception {
        LoginRequest loginRequest = LoginRequest.builder()
                .email(email)
                .password(password)
                .build();

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isForbidden())
                .andExpect(content().string("MFA verification required"));

        // Verify MFA
        String mfaRequest = """
                {
                    "mfaCode": "123456"
                }
                """;

        mockMvc.perform(post("/api/auth/verify-mfa")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(mfaRequest))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("MFA verification successful."));
    }

    @Test
    @DisplayName("Integration Test: Register and Login User with MFA")
    public void testRegisterLoginWithMFA() throws Exception {
        String token = registerUser("testUser", "testuser@example.com");
        verifyEmail(token);
        loginUserWithMfa("testuser@example.com", "StrongPassword@123");
    }

    @Test
    @DisplayName("Negative Test: Register with Invalid Email")
    public void testRegisterInvalidEmail() throws Exception {
        RegistrationRequest invalidRequest = RegistrationRequest.builder()
                .username("testUser2")
                .email("invalid-email")
                .password("StrongPassword@123")
                .consentToDataUsage(true)
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.email").value("Invalid email format"));
    }

    @Test
    @DisplayName("Negative Test: Login with Invalid Password")
    public void testLoginInvalidPassword() throws Exception {
        String token = registerUser("testUser3", "testuser3@example.com");
        verifyEmail(token);

        LoginRequest loginRequest = LoginRequest.builder()
                .email("testuser3@example.com")
                .password("WrongPassword@123")
                .build();

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(loginRequest)))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("Invalid email or password"));
    }
}
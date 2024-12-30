// src/test/java/orsk/authmodule/tests/BoundaryValueTest.java
package auth.boundaryValueTest;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class BoundaryValueTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Register User with Username Length Boundary")
    public void testRegisterUser_UsernameBoundary() throws Exception {
        // Minimum boundary
        String minUsername = "usr";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"" + minUsername + "\",\"email\":\"minboundary@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated());

        // Maximum boundary
        String maxUsername = "u".repeat(50);

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"" + maxUsername + "\",\"email\":\"maxboundary@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated());
    }

    @Test
    @DisplayName("Register User with Password Length Boundary")
    public void testRegisterUser_PasswordBoundary() throws Exception {
        // Minimum boundary (12 characters)
        String minPassword = "A1a!A1a!A1a!";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"boundaryUser1\",\"email\":\"boundary1@example.com\",\"password\":\"" + minPassword + "\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated());

        // Below minimum boundary
        String shortPassword = "A1a!A1a!A1";

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"boundaryUser2\",\"email\":\"boundary2@example.com\",\"password\":\"" + shortPassword + "\",\"consentToDataUsage\":true}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors").exists());
    }

    @Test
    @DisplayName("Boundary Test: Username Length")
    public void testUsernameLengthBoundary() throws Exception {
        String minUsername = "usr";
        String maxUsername = "u".repeat(50);

        // Minimum boundary test
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"" + minUsername + "\",\"email\":\"min@example.com\",\"password\":\"Password@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.message").value("User registered successfully"));

        // Maximum boundary test
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"" + maxUsername + "\",\"email\":\"max@example.com\",\"password\":\"Password@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.message").value("User registered successfully"));

        // Above maximum boundary
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"" + maxUsername + "x\",\"email\":\"over@example.com\",\"password\":\"Password@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.username").value("Username must not exceed 50 characters"));
    }

    @Test
    @DisplayName("Boundary Test: Password Strength")
    public void testPasswordStrengthBoundary() throws Exception {
        String minPassword = "Abc@1234";
        String weakPassword = "123";

        // Minimum acceptable password
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"user1\",\"email\":\"valid@example.com\",\"password\":\"" + minPassword + "\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.message").value("User registered successfully"));

        // Weak password
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"user2\",\"email\":\"weak@example.com\",\"password\":\"" + weakPassword + "\",\"consentToDataUsage\":true}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.password").value("Password is too weak"));
    }
    @Test
    @DisplayName("Boundary Test: MFA Code Length")
    public void testMfaCodeLengthBoundary() throws Exception {
        // Minimum length (e.g., 6 digits)
        String minMfaCode = "123456";

        mockMvc.perform(post("/api/auth/verify-mfa")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"mfaCode\":\"" + minMfaCode + "\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("MFA verification successful."));

        // Exceeding maximum length
        String longMfaCode = "1234567890";

        mockMvc.perform(post("/api/auth/verify-mfa")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"mfaCode\":\"" + longMfaCode + "\"}"))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.mfaCode").value("Invalid MFA code format"));
    }
}
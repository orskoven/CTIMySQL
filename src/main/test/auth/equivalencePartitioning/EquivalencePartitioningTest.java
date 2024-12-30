package auth.equivalencePartitioning;

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

/**
 * Equivalence Partitioning Test Suite
 * Ensures input validation for user registration API.
 */
@SpringBootTest
@AutoConfigureMockMvc
public class EquivalencePartitioningTest {

    @Autowired
    private MockMvc mockMvc;

    // VALID PARTITION TESTS

    @Test
    @DisplayName("Partition: Register User with Valid Data")
    public void testRegisterUser_ValidData() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "validUser",
                            "email": "valid@example.com",
                            "password": "StrongPassword@123",
                            "consentToDataUsage": true
                        }
                        """))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.message").value("User registered successfully"));
    }

    // INVALID PARTITION TESTS

    @Test
    @DisplayName("Partition: Register User with Invalid Email")
    public void testRegisterUser_InvalidEmail() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "invalidEmailUser",
                            "email": "invalid-email",
                            "password": "StrongPassword@123",
                            "consentToDataUsage": true
                        }
                        """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.email").value("Invalid email format"));
    }

    @Test
    @DisplayName("Partition: Register User with Weak Password")
    public void testRegisterUser_WeakPassword() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "weakPasswordUser",
                            "email": "user@example.com",
                            "password": "123",
                            "consentToDataUsage": true
                        }
                        """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.password").value("Password is too weak"));
    }

    @Test
    @DisplayName("Partition: Register User without Consent")
    public void testRegisterUser_NoConsent() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "noConsentUser",
                            "email": "noconsent@example.com",
                            "password": "StrongPassword@123",
                            "consentToDataUsage": false
                        }
                        """))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.error").value("Consent to data usage is required"));
    }

    @Test
    @DisplayName("Partition: Register User with Missing Fields")
    public void testRegisterUser_MissingFields() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "",
                            "email": "",
                            "password": "",
                            "consentToDataUsage": null
                        }
                        """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.username").value("Username is required"))
                .andExpect(jsonPath("$.validationErrors.email").value("Email is required"))
                .andExpect(jsonPath("$.validationErrors.password").value("Password is required"))
                .andExpect(jsonPath("$.validationErrors.consentToDataUsage").value("Consent is required"));
    }

    @Test
    @DisplayName("Partition: Register User with Invalid Username")
    public void testRegisterUser_InvalidUsername() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "!",
                            "email": "user@example.com",
                            "password": "StrongPassword@123",
                            "consentToDataUsage": true
                        }
                        """))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors.username").value("Username must contain only alphanumeric characters"));
    }

    // EDGE CASE TESTS

    @Test
    @DisplayName("Partition: Register User with Maximum Allowed Fields")
    public void testRegisterUser_MaxAllowedFields() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "a".repeat(50),
                            "email": "max.user@example.com",
                            "password": "StrongPassword@123",
                            "consentToDataUsage": true
                        }
                        """))
                .andExpect(status().isCreated());
    }

    @Test
    @DisplayName("Partition: Register User with Minimum Allowed Fields")
    public void testRegisterUser_MinAllowedFields() throws Exception {
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                        {
                            "username": "a",
                            "email": "a@b.co",
                            "password": "Abc@1234",
                            "consentToDataUsage": true
                        }
                        """))
                .andExpect(status().isCreated());
    }
}
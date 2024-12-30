package auth.integration;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.ResultActions;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
public class AuthIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Test Successful Authentication")
    public void testSuccessfulAuthentication() throws Exception {
        // Arrange: Prepare valid user credentials
        String validCredentials = """
        {
            "email": "testuser@example.com",
            "password": "password123"
        }
        """;

        // Act: Perform the sign-in request
        ResultActions response = mockMvc.perform(
                post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(validCredentials)
        );

        // Assert: Verify the response
        response.andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").exists())
                .andExpect(jsonPath("$.accessToken").isNotEmpty())
                .andExpect(jsonPath("$.refreshToken").exists())
                .andExpect(jsonPath("$.refreshToken").isNotEmpty())
                .andExpect(jsonPath("$.tokenType").value("Bearer"));
    }

    @Test
    @DisplayName("Test Authentication with Invalid Credentials")
    public void testAuthenticationInvalidCredentials() throws Exception {
        String invalidCredentials = """
            {
                "email": "testuser@example.com",
                "password": "wrongpassword"
            }
        """;

        ResultActions response = mockMvc.perform(
                post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(invalidCredentials)
        );

        response.andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("Invalid email or password"));
    }

    @Test
    @DisplayName("Test Authentication with Missing Fields")
    public void testAuthenticationMissingFields() throws Exception {
        String incompleteCredentials = """
            {
                "email": "testuser@example.com"
            }
        """;

        ResultActions response = mockMvc.perform(
                post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(incompleteCredentials)
        );

        response.andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.validationErrors").exists());
    }
}
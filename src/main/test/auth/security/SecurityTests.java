package auth.security;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@DisplayName("Security Tests for Endpoint Access")
public class SecurityTests {

    @Autowired
    private MockMvc mockMvc;

    // Generate a valid token mock for testing
    private String generateValidJwt() {
        return "mockedValidJwtToken"; // Replace with actual token generation logic if needed
    }

    @Test
    @DisplayName("Access Protected Endpoint Without JWT")
    public void testAccessProtectedEndpointWithoutJWT() throws Exception {
        mockMvc.perform(get("/api/protected/resource"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("Unauthorized"));
    }

    @Test
    @DisplayName("Access Protected Endpoint With Invalid JWT")
    public void testAccessProtectedEndpointWithInvalidJWT() throws Exception {
        mockMvc.perform(get("/api/protected/resource")
                        .header("Authorization", "Bearer invalidtoken"))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("Unauthorized"));
    }

    @Test
    @DisplayName("Access Protected Endpoint With Expired JWT")
    public void testAccessProtectedEndpointWithExpiredJWT() throws Exception {
        String expiredJwt = "mockedExpiredJwtToken"; // Replace with expired token
        mockMvc.perform(get("/api/protected/resource")
                        .header("Authorization", "Bearer " + expiredJwt))
                .andExpect(status().isUnauthorized())
                .andExpect(jsonPath("$.error").value("JWT Token Expired"));
    }

    @Test
    @DisplayName("Access Protected Endpoint With Valid JWT")
    public void testAccessProtectedEndpointWithValidJWT() throws Exception {
        String validJwt = generateValidJwt();

        mockMvc.perform(get("/api/protected/resource")
                        .header("Authorization", "Bearer " + validJwt))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.message").value("Access granted"));
    }

    @Test
    @DisplayName("Access Public Endpoint Without JWT")
    public void testAccessPublicEndpointWithoutJWT() throws Exception {
        mockMvc.perform(get("/api/auth/public"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("Public endpoint accessible"));
    }


}
// src/test/java/orsk/authmodule/tests/ApiEndpointTest.java
package auth.api;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


@SpringBootTest
@AutoConfigureMockMvc
public class ApiEndpointTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("API Test: Access Protected Endpoint without JWT")
    public void testAccessProtectedEndpointWithoutJWT() throws Exception {
        mockMvc.perform(get("/api/protected/resource"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("API Test: Access Protected Endpoint with Invalid JWT")
    public void testAccessProtectedEndpointWithInvalidJWT() throws Exception {
        mockMvc.perform(get("/api/protected/resource")
                        .header("Authorization", "Bearer invalidtoken"))
                .andExpect(status().isUnauthorized());
    }

    @Test
    @DisplayName("API Test: Access Protected Endpoint with Valid JWT")
    public void testAccessProtectedEndpointWithValidJWT() throws Exception {
        String validJwt = "mockedValidJwtToken"; // Replace with actual token generation

        mockMvc.perform(get("/api/protected/resource")
                        .header("Authorization", "Bearer " + validJwt))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.key").value("value"));
    }

    // Additional API endpoint tests...
}
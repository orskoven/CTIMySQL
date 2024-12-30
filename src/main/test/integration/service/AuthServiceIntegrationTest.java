package integration.service;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import orsk.compli.service.jpa.AuthClientService;

import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class AuthServiceIntegrationTest {

    @Autowired
    private AuthClientService authService;

    @Test
    public void testLoginIntegration() {
        // Arrange
        LoginRequest request = new LoginRequest("user@example.com", "password");

        // Act
        JwtAuthenticationResponse response = authService.login(request);

        // Assert
        assertNotNull(response);
    }
}
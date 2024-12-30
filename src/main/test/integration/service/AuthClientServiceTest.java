package orsk.compli.service;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.InjectMocks;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.ResponseEntity;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.web.client.RestTemplate;
import orsk.compli.service.jpa.AuthClientService;

import static org.junit.Assert.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ActiveProfiles("test")
@SpringBootTest
public class AuthClientServiceTest {

    @MockBean
    private RestTemplate restTemplate;

    @InjectMocks
    private AuthClientService authClientService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
    }

    @Test
    public void testLogin() {
        // Arrange
        String loginUrl = "http://localhost:8087/api/auth/login";
        LoginRequest request = new LoginRequest();
        request.setEmail("john.doe@example.com");
        request.setPassword("@Password123");

        JwtAuthenticationResponse mockResponse = new JwtAuthenticationResponse();
        mockResponse.setAccessToken("mock-access-token");
        mockResponse.setRefreshToken("mock-refresh-token");
        mockResponse.setMessage("Login successful");
        mockResponse.setSuccess(true);

        ResponseEntity<JwtAuthenticationResponse> responseEntity = ResponseEntity.ok(mockResponse);

        // Ensure the exact URL and argument types match
        when(restTemplate.postForEntity(eq(loginUrl), eq(request), eq(JwtAuthenticationResponse.class)))
                .thenReturn(responseEntity);

        // Act
        JwtAuthenticationResponse response = authClientService.login(request);

        // Assert
        assertNotNull(response);
        assertEquals("mock-access-token", response.getAccessToken());
    }
}
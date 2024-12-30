/*package orsk.compli.service.jpa;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import orsk.compli.dtos.auth.JwtAuthenticationResponse;
import orsk.compli.dtos.auth.LoginRequest;
import orsk.compli.service.jpa.RefreshTokenRequest;

@Service
@Slf4j
public class AuthClientService {

    private final RestTemplate restTemplate;

    @Value("${auth.service.url:http://localhost:8087/api/auth}")
    private String authServiceUrl;

    public AuthClientService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public JwtAuthenticationResponse login(LoginRequest loginRequest) {
        String url = authServiceUrl + "/login";
        try {
            log.info("Sending login request to {}", url);
            ResponseEntity<JwtAuthenticationResponse> response =
                    restTemplate.postForEntity(url, loginRequest, JwtAuthenticationResponse.class);
            if (response == null || response.getBody() == null) {
                throw new RuntimeException("Authentication service returned null response for login");
            }
            return response.getBody();
        } catch (Exception ex) {
            log.error("Error during login: {}", ex.getMessage());
            throw new RuntimeException("Failed to login: " + ex.getMessage(), ex);
        }
    }

    public JwtAuthenticationResponse refreshToken(String refreshToken) {
        String url = authServiceUrl + "/refresh-token";
        try {
            log.info("Sending refresh token request to {}", url);
            RefreshTokenRequest request = new RefreshTokenRequest(refreshToken);
            ResponseEntity<JwtAuthenticationResponse> response =
                    restTemplate.postForEntity(url, request, JwtAuthenticationResponse.class);
            if (response == null || response.getBody() == null) {
                throw new RuntimeException("Authentication service returned null response for refresh token");
            }
            return response.getBody();
        } catch (Exception ex) {
            log.error("Error during refresh token: {}", ex.getMessage());
            throw new RuntimeException("Failed to refresh token: " + ex.getMessage(), ex);
        }
    }

    public void logout(String token) {
        String url = authServiceUrl + "/logout";
        try {
            log.info("Sending logout request to {}", url);
            LogoutRequest request = new LogoutRequest(token);
            restTemplate.postForEntity(url, request, Void.class);
            log.info("User successfully logged out");
        } catch (Exception ex) {
            log.error("Error during logout: {}", ex.getMessage());
            throw new RuntimeException("Failed to logout: " + ex.getMessage(), ex);
        }
    }
}

 */
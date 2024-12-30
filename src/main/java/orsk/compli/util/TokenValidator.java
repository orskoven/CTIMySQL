/*package orsk.compli.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import orsk.compli.config.AuthServiceConfig;

import java.util.Map;

@Component
public class TokenValidator {

    @Autowired
    private AuthServiceConfig authServiceConfig;

    @Autowired
    private RestTemplate restTemplate;

    public boolean isValidToken(String token) {
        String url = authServiceConfig.getAuthServiceUrl() + "/validate";
        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(
                    url, 
                    Map.of("token", token), 
                    Map.class
            );
            return response.getBody() != null && Boolean.TRUE.equals(response.getBody().get("valid"));
        } catch (Exception ex) {
            return false;
        }
    }
}

 */
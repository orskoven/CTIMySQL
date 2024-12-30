/*package orsk.compli.controller.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.util.TokenValidator;

@RestController
public class ProtectedResourceController {

    @Autowired
    private TokenValidator tokenValidator;

    @GetMapping("/protected-resource")
    public ResponseEntity<String> accessProtectedResource(@RequestHeader("Authorization") String token) {
        // Strip "Bearer " prefix if present
        if (token.startsWith("Bearer ")) {
            token = token.substring(7);
        }

        boolean isValid = tokenValidator.isValidToken(token);

        if (isValid) {
            return ResponseEntity.ok("Access granted to protected resource");
        } else {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid or expired token");
        }
    }
}

 */
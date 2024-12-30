/*package orsk.compli.controller.jpa;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import orsk.compli.dtos.JwtAuthenticationResponse;
import orsk.compli.dtos.LoginRequest;
import orsk.compli.service.jpa.AuthClientService;

@RestController
@RequestMapping("/api/consumer")
@RequiredArgsConstructor
public class ConsumerController {

    private final AuthClientService authClientService;

    @PostMapping("/login")
    public ResponseEntity<JwtAuthenticationResponse> login(@RequestBody LoginRequest loginRequest) {
        JwtAuthenticationResponse response = authClientService.login(loginRequest);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/refresh-token")
    public ResponseEntity<JwtAuthenticationResponse> refreshToken(@RequestBody String refreshToken) {
        JwtAuthenticationResponse response = authClientService.refreshToken(refreshToken);
        return ResponseEntity.ok(response);
    }

    @PostMapping("/logout")
    public ResponseEntity<String> logout(@RequestBody String token) {
        authClientService.logout(token);
        return ResponseEntity.ok("Logged out successfully");
    }
}

 */
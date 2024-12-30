package orsk.compli.dtos.auth;

import lombok.Builder;
import lombok.Value;

/**
 * Response containing tokens and optional message after authentication.
 */
@Value
@Builder
public class JwtAuthenticationResponse {
    String accessToken;
    String refreshToken;
    @Builder.Default
    String tokenType = "Bearer";
    String message;
    
    // Example static factory methods for clarity
    public static JwtAuthenticationResponse ofTokens(String accessToken, String refreshToken) {
        return JwtAuthenticationResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .message(null)
                .build();
    }

    public static JwtAuthenticationResponse ofMessage(String message) {
        return JwtAuthenticationResponse.builder()
                .accessToken(null)
                .refreshToken(null)
                .message(message)
                .build();
    }
}
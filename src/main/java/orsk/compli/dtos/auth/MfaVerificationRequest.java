package orsk.compli.dtos.auth;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class MfaVerificationRequest {
    @NotBlank(message = "MFA code is required")
    private String mfaCode;

    @Email(message = "Invalid email address")
    @NotBlank(message = "Email address is required")
    private String email;
}
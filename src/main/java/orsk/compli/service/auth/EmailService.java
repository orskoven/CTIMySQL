// src/main/java/orsk/authmodule/service/EmailService.java
package orsk.compli.service.auth;

import org.springframework.stereotype.Service;

@Service
public class EmailService {
    public void sendVerificationEmail(String to, String token) {
        // Implement email sending logic here
    }

    public void sendPasswordResetEmail(String to, String token) {
        // Implement email sending logic here
    }

    public void sendMfaCode(String to, String mfaCode) {
        // Implement email/SMS sending logic here
    }
}
// src/test/java/orsk/authmodule/tests/EmailVerificationTest.java
package auth.services;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class EmailVerificationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Email Verification Successfully")
    public void testVerifyEmail_Success() throws Exception {
        // Assume a valid token is generated and available
        String token = "validVerificationToken";

        mockMvc.perform(post("/api/auth/verify-email")
                        .param("token", token))
                .andExpect(status().isOk())
                .andExpect(content().string("Email verified successfully."));
    }

    @Test
    @DisplayName("Email Verification with Invalid Token")
    public void testVerifyEmail_InvalidToken() throws Exception {
        String token = "invalidToken";

        mockMvc.perform(post("/api/auth/verify-email")
                        .param("token", token))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("Invalid verification token"));
    }

    // Additional email verification tests...
}
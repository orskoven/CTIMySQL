// src/test/java/orsk/authmodule/tests/PasswordResetFlowTest.java
package auth.system;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import orsk.authmodule.dto.PasswordResetRequest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class PasswordResetFlowTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Password Reset Flow: Initiate and Change Password")
    public void testPasswordResetFlow() throws Exception {
        // Initiate Password Reset
        PasswordResetRequest resetRequest = new PasswordResetRequest();
        resetRequest.setEmail("testuser@example.com");

        mockMvc.perform(post("/api/auth/password-reset")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"testuser@example.com\"}"))
                .andExpect(status().isOk())
                .andExpect(content().string("Password reset instructions have been sent to your email."));

        // Assume token is retrieved from email
        String resetToken = "validPasswordResetToken";

        // Change Password
        mockMvc.perform(post("/api/auth/change-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"token\":\"validPasswordResetToken\",\"newPassword\":\"NewStrongPassword@123\"}"))
                .andExpect(status().isOk())
                .andExpect(content().string("Password changed successfully."));
    }

    // Additional password reset flow tests...
}
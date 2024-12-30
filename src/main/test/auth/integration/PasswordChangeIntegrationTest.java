// src/test/java/orsk/authmodule/tests/PasswordChangeIntegrationTest.java
package auth.integration;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import orsk.authmodule.dto.PasswordChangeRequest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class PasswordChangeIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Integration Test: Change Password Successfully")
    public void testChangePassword_Success() throws Exception {
        PasswordChangeRequest request = new PasswordChangeRequest();
        request.setToken("validChangePasswordToken");
        request.setNewPassword("NewStrongPassword@123");

        mockMvc.perform(post("/api/auth/change-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"token\":\"validChangePasswordToken\",\"newPassword\":\"NewStrongPassword@123\"}"))
                .andExpect(status().isOk())
                .andExpect(content().string("Password changed successfully."));
    }

    @Test
    @DisplayName("Integration Test: Change Password with Invalid Token")
    public void testChangePassword_InvalidToken() throws Exception {
        mockMvc.perform(post("/api/auth/change-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"token\":\"invalidToken\",\"newPassword\":\"NewStrongPassword@123\"}"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("Invalid password reset token"));
    }

    // Additional integration tests...
}
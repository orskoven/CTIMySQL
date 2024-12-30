// src/test/java/orsk/authmodule/tests/PasswordChangeTest.java
package auth.services;

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
public class PasswordChangeTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Password Change Successfully")
    public void testChangePassword_Success() throws Exception {
        PasswordChangeRequest request = new PasswordChangeRequest();
        request.setToken("validResetToken");
        request.setNewPassword("NewStrongPassword@123");

        mockMvc.perform(post("/api/auth/change-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"token\":\"validResetToken\",\"newPassword\":\"NewStrongPassword@123\"}"))
                .andExpect(status().isOk())
                .andExpect(content().string("Password changed successfully."));
    }

    @Test
    @DisplayName("Password Change with Invalid Token")
    public void testChangePassword_InvalidToken() throws Exception {
        mockMvc.perform(post("/api/auth/change-password")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"token\":\"invalidToken\",\"newPassword\":\"NewStrongPassword@123\"}"))
                .andExpect(status().isInternalServerError())
                .andExpect(jsonPath("$.message").value("Invalid password reset token"));
    }

    // Additional password change tests...
}
// src/test/java/orsk/authmodule/tests/StateTransitionTest.java
package auth.stateTransistions;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
public class StateTransitionTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("State Transition Test: Register -> Verify Email -> Login")
    public void testStateTransition_RegisterVerifyLogin() throws Exception {
        // Register User
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"stateUser\",\"email\":\"state@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated());

        // Verify Email
        mockMvc.perform(post("/api/auth/verify-email")
                        .param("token", "validStateToken"))
                .andExpect(status().isOk())
                .andExpect(content().string("Email verified successfully."));

        // Login User
        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"state@example.com\",\"password\":\"StrongPassword@123\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.accessToken").exists());
    }

    // Additional state transition tests...
}
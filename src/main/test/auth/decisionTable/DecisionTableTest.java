// src/test/java/orsk/authmodule/tests/DecisionTableTest.java
package auth.decisionTable;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@SpringBootTest
@AutoConfigureMockMvc
public class DecisionTableTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    @DisplayName("Decision Table Test: Consent to Data Usage")
    public void testConsentDecision() throws Exception {
        // Consent Given
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"consentUser\",\"email\":\"consent@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":true}"))
                .andExpect(status().isCreated());

        // Consent Not Given
        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"username\":\"noConsentUser\",\"email\":\"noconsent@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":false}"))
                .andExpect(status().isOk())
                .andExpect(content().string("User registered successfully. Please check your email for verification instructions."));
    }

    // Additional decision table tests...
}
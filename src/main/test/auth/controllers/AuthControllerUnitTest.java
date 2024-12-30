package auth.controllers;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import orsk.authmodule.controller.AuthController;
import orsk.authmodule.dto.RegistrationRequest;
import orsk.authmodule.exceptions.*;
import orsk.authmodule.service.AuthService;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(AuthController.class)
public class AuthControllerUnitTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AuthService authService;

    @Autowired
    private ObjectMapper objectMapper;

    @Test
    @DisplayName("Successful User Registration")
    public void testRegisterUser_Success() throws Exception {
        RegistrationRequest request = new RegistrationRequest("unitUser", "unit@example.com", "StrongPassword@123", true);

        doNothing().when(authService).registerUser(any(RegistrationRequest.class));

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.message").value("User registered successfully. Please check your email for verification instructions."));
    }

    @Test
    @DisplayName("User Registration with Existing Email")
    public void testRegisterUser_Conflict() throws Exception {
        RegistrationRequest request = new RegistrationRequest("unitUser", "existing@example.com", "StrongPassword@123", true);

        doThrow(new UserAlreadyExistsException("Username or email already exists"))
                .when(authService).registerUser(any(RegistrationRequest.class));

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.error").value("Username or email already exists"));
    }

    @Test
    @DisplayName("Invalid User Registration Data")
    public void testRegisterUser_BadRequest() throws Exception {
        RegistrationRequest request = new RegistrationRequest("", "", "weak", false);

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.errors").exists());
    }

    @Test
    @DisplayName("Rate Limiting on Registration Endpoint")
    public void testRegisterUser_RateLimiting() throws Exception {
        RegistrationRequest request = new RegistrationRequest("unitUser", "unit@example.com", "StrongPassword@123", true);

        for (int i = 0; i < 10; i++) {
            mockMvc.perform(post("/api/auth/register")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(objectMapper.writeValueAsString(request)));
        }

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isTooManyRequests());
    }
}
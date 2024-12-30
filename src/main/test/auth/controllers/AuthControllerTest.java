// src/test/java/orsk/authmodule/controllers/AuthControllerTest.java
package auth.controllers;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import orsk.authmodule.controller.AuthController;
import orsk.authmodule.dto.*;
import orsk.authmodule.dto.LoginRequest;
import orsk.authmodule.exceptions.*;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.RoleRepository;
import orsk.authmodule.repository.UserRepository;
import orsk.authmodule.service.AuditLogService;
import orsk.authmodule.service.AuthService;
import orsk.authmodule.service.MfaTokenService;

import java.util.Optional;

import static org.hamcrest.Matchers.containsString;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doNothing;
import static org.mockito.Mockito.when;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.csrf;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(AuthController.class)
public class AuthControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AuthService authService;

    @MockitoBean
    private MfaTokenService mfaTokenService;

    @MockitoBean
    private LoginRequest loginRequest;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private AuditLogService auditLogService;

    @MockitoBean
    private UserRepository userRepository; // Add this mock

    @MockitoBean
    private RoleRepository roleRepository; // Mock other dependencies if needed


    @Test
    @DisplayName("Unit Test: Successful User Registration")
    public void testRegisterUser_Success() throws Exception {
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("unitUser");
        request.setEmail("unit@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        doNothing().when(authService).registerUser(any(RegistrationRequest.class));

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(content().string("User registered successfully. Please check your email for verification instructions."));
    }

    @Test
    @DisplayName("Unit Test: User Registration with Existing Email")
    public void testRegisterUser_Conflict() throws Exception {
        RegistrationRequest request = new RegistrationRequest();
        request.setUsername("unitUser");
        request.setEmail("existing@example.com");
        request.setPassword("StrongPassword@123");
        request.setConsentToDataUsage(true);

        doThrow(new UserAlreadyExistsException("Username or email already exists"))
                .when(authService).registerUser(any(RegistrationRequest.class));

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(content().string("Username or email already exists"));
    }

    @Test
    void registerUser_ShouldReturnConflict_WhenUserExists() throws Exception {
        RegistrationRequest request = RegistrationRequest.builder()
                .email("existing@example.com")
                .username("existingUser")
                .password("StrongP@ssw0rd!")
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(new ObjectMapper().writeValueAsString(request)))
                .andExpect(status().isConflict())
                .andExpect(content().string(containsString("Email or Username already exists.")));
    }
    @Test
    @DisplayName("Login with MFA")
    public void testLoginWithMfa() throws Exception {
        // Assume user is registered and MFA enabled
        LoginRequest request = new LoginRequest("testuser@example.com", "StrongPassword@123");

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("MFA_REQUIRED"));
    }

    @Test
    @DisplayName("Verify MFA Code Successfully")
    public void testVerifyMfaCode() throws Exception {
        String mfaCode = "123456"; // Example, should match the mocked token in DB
        mockMvc.perform(post("/api/auth/verify-mfa")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"mfaCode\":\"" + mfaCode + "\",\"email\":\"testuser@example.com\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.message").value("MFA verification successful"));
    }

    @Test
    void testVerifyMfaSuccess() throws Exception {
        String mfaCode = "123456";
        String email = "testuser@example.com";

        User user = new User();
        user.setEmail(email);
        user.setUsername("testuser");

        when(userRepository.findByEmail(email)).thenReturn(Optional.of(user));
        when(mfaTokenService.verifyMfaCode(mfaCode, user)).thenReturn(true);

        mockMvc.perform(post("/api/auth/verify-mfa")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"email\":\"" + email + "\", \"mfaCode\":\"" + mfaCode + "\"}")
                        .with(csrf())) // Add CSRF support if needed
                .andExpect(status().isOk())
                .andExpect(content().string("MFA verified successfully"));
    }
}
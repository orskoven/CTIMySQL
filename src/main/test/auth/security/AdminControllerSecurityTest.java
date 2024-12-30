package auth.security;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import org.springframework.security.test.context.support.WithMockUser;
import orsk.authmodule.controller.AdminController;

import static org.junit.Assert.assertEquals;

@SpringBootTest
public class AdminControllerSecurityTest {

    @Autowired
    private AdminController adminController;

    @Before
    public void setUp() {
        // Initialize security test data if required
    }

    @Test
    @WithMockUser(roles = "ADMIN")
    public void testRoleBasedAccessControls() {
        Long userId = 1L;
        ResponseEntity<?> response = adminController.enableUser(userId);

        assertEquals("User enabled successfully", response.getBody());
    }

    @Test(expected = org.springframework.security.access.AccessDeniedException.class)
    @WithMockUser(roles = "USER")
    public void testUnauthorizedAccessAttempt() {
        Long userId = 1L;
        adminController.enableUser(userId);
    }
}
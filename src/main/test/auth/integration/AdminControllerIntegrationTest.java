package auth.integration;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.ResponseEntity;
import orsk.authmodule.controller.AdminController;

import java.util.List;

import static org.junit.Assert.*;

@SpringBootTest
public class AdminControllerIntegrationTest {

    @InjectMocks
    private AdminController adminController;

    @Before
    public void setUp() {
        // Initialize integration test data if required
    }

    @Test
    public void testEnableUserIntegration() {
        Long userId = 1L; // Example user ID
        ResponseEntity<?> response = adminController.enableUser(userId);

        assertNotNull(response);
        assertEquals("User enabled successfully", response.getBody());
    }

    @Test
    public void testDisableUserIntegration() {
        Long userId = 1L;
        ResponseEntity<?> response = adminController.disableUser(userId);

        assertNotNull(response);
        assertEquals("User disabled successfully", response.getBody());
    }

    @Test
    public void testGetAllUsersIntegration() {
        ResponseEntity<?> response = adminController.getAllUsers();

        assertNotNull(response);
        assertTrue(response.getBody() instanceof List);
    }
}
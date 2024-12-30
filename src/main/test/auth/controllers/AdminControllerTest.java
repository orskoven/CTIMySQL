package auth.controllers;

import org.junit.Before;
import org.junit.Test;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.http.ResponseEntity;
import orsk.authmodule.controller.AdminController;
import orsk.authmodule.model.User;
import orsk.authmodule.service.AdminService;

import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.Mockito.*;

public class AdminControllerTest {

    @Mock
    private AdminService adminService;

    @InjectMocks
    private AdminController adminController;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
    }

    @Test
    public void testEnableUser() {
        Long userId = 1L;

        // Simulate service behavior
        doNothing().when(adminService).enableUser(userId);

        // Call the controller method
        ResponseEntity<?> response = adminController.enableUser(userId);

        // Verify interactions and assertions
        verify(adminService, times(1)).enableUser(userId);
        assertNotNull(response);
        assertEquals("User enabled successfully", response.getBody());
    }

    @Test
    public void testDisableUser() {
        Long userId = 1L;

        // Simulate service behavior
        doNothing().when(adminService).disableUser(userId);

        // Call the controller method
        ResponseEntity<?> response = adminController.disableUser(userId);

        // Verify interactions and assertions
        verify(adminService, times(1)).disableUser(userId);
        assertNotNull(response);
        assertEquals("User disabled successfully", response.getBody());
    }

    @Test
    public void testUpdateUserRoles() {
        Long userId = 1L;
        List<String> roles = List.of("ADMIN", "USER");

        // Simulate service behavior
        doNothing().when(adminService).updateUserRoles(userId, roles);

        // Call the controller method (assume it exists)
        adminController.updateUserRoles(userId, roles);

        // Verify interactions
        verify(adminService, times(1)).updateUserRoles(userId, roles);
    }

    @Test
    public void testGetAllUsers() {
        // Simulate service behavior
        List<User> mockUsers = List.of(new User(), new User());
        when(adminService.getAllUsers()).thenReturn(mockUsers);

        // Call the controller method
        ResponseEntity<?> response = adminController.getAllUsers();

        // Verify interactions and assertions
        verify(adminService, times(1)).getAllUsers();
        assertNotNull(response);
        assertEquals(mockUsers.size(), ((List<?>) response.getBody()).size());
    }

    @Test
    public void testDeleteUser() {
        Long userId = 1L;

        // Simulate service behavior
        doNothing().when(adminService).deleteUser(userId);

        // Call the controller method
        ResponseEntity<?> response = adminController.deleteUser(userId);

        // Verify interactions and assertions
        verify(adminService, times(1)).deleteUser(userId);
        assertNotNull(response);
        assertEquals("User deleted successfully", response.getBody());
    }
}
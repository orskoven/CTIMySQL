package orsk.compli.controller.auth;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import orsk.compli.service.auth.AdminService;

import java.util.List;

@RestController
@RequestMapping("/api/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    @PutMapping("/enable-user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> enableUser(@PathVariable Long userId) {
        adminService.enableUser(userId);
        return ResponseEntity.ok().body("User enabled successfully");
    }

    @PutMapping("/disable-user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> disableUser(@PathVariable Long userId) {
        adminService.disableUser(userId);
        return ResponseEntity.ok().body("User disabled successfully");
    }

    @PutMapping("/update-roles/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> updateUserRoles(@PathVariable Long userId, @RequestBody List<String> roles) {
        adminService.updateUserRoles(userId, roles);
        return ResponseEntity.ok().body("User roles updated successfully");
    }

    @GetMapping("/users")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> getAllUsers() {
        return ResponseEntity.ok().body(adminService.getAllUsers());
    }

    @DeleteMapping("/delete-user/{userId}")
    @PreAuthorize("hasRole('ADMIN')")
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        adminService.deleteUser(userId);
        return ResponseEntity.ok().body("User deleted successfully");
    }
}
package orsk.compli.dtos.auth;

import java.util.List;

public class UserProfileResponse {
    private String username;
    private String email;
    private List<String> roles;
    private boolean enabled;

    public UserProfileResponse(String username, String email, List<String> roles, boolean enabled) {
        this.username = username;
        this.email = email;
        this.roles = roles;
        this.enabled = enabled;
    }

    // Getters and Setters
}
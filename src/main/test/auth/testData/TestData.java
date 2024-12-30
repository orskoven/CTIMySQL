package auth.testData;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.Getter;
import lombok.Setter;
import orsk.authmodule.model.Privilege;
import orsk.authmodule.model.Role;
import orsk.authmodule.model.User;

import java.util.List;

@JsonIgnoreProperties(ignoreUnknown = true)
@Getter
@Setter
public class TestData {
    private List<User> users;
    private List<Role> roles;
    private List<Privilege> privileges;

    // Getters and setters
}

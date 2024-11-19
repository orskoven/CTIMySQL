package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.User;
import orsk.compli.service.jpa.CrudService;
import orsk.compli.service.jpa.UserService;

@RestController
@RequestMapping("/api/mysql/users") // Base URL for user-related endpoints
public class UserController extends AbstractCrudControllerJpa<User, Long> {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @Override
    protected CrudService<User, Long> getService() {
        return (CrudService<User, Long>) userService;
    }
}
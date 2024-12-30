package orsk.compli.exception;

/**
 * Custom exception to handle cases where a role is not found.
 */
public class RoleNotFoundException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String roleName;

    /**
     * Constructs a new RoleNotFoundException with the specified role name.
     *
     * @param roleName the name of the role that was not found
     */
    public RoleNotFoundException(String roleName) {
        super(String.format("Role not found: %s", roleName));
        this.roleName = roleName;
    }

    /**
     * Gets the name of the role that was not found.
     *
     * @return the role name
     */
    public String getRoleName() {
        return roleName;
    }
}
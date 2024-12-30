package orsk.compli.exception;

/**
 * Custom exception to handle cases where a user is not found.
 */
public class UserNotFoundException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final Object userIdOrEmail;

    /**
     * Constructs a new UserNotFoundException with the specified identifier.
     *
     * @param userIdOrEmail the user ID or email that was not found
     */
    public UserNotFoundException(Object userIdOrEmail) {
        super(String.format("User not found with identifier: %s", userIdOrEmail));
        this.userIdOrEmail = userIdOrEmail;
    }

    /**
     * Gets the identifier of the user that was not found.
     *
     * @return the user identifier
     */
    public Object getUserIdOrEmail() {
        return userIdOrEmail;
    }
}
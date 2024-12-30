package orsk.compli.exception;

import lombok.Getter;

/**
 * Custom exception to handle cases where a username or email is not found.
 * This exception extends RuntimeException, making it an unchecked exception.
 */
@Getter
public class UsernameOrEmailNotFoundException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    /**
     * -- GETTER --
     *  Gets the input (username or email) that caused the exception.
     *
     * @return the input that was not found
     */
    private final String input;

    /**
     * Constructs a new UsernameOrEmailNotFoundException with the specified input.
     *
     * @param input the username or email that was not found
     */
    public UsernameOrEmailNotFoundException(String input) {
        super(String.format("User not found with username or email: %s", input));
        this.input = input;
    }

}
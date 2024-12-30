package orsk.compli.exception;

/**
 * Custom exception to handle invalid token scenarios.
 */
public class InvalidTokenException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String token;

    /**
     * Constructs a new InvalidTokenException with the specified token.
     *
     * @param token the invalid token
     */
    public InvalidTokenException(String token) {
        super(String.format("Invalid token: %s", token));
        this.token = token;
    }

    /**
     * Gets the invalid token.
     *
     * @return the invalid token
     */
    public String getToken() {
        return token;
    }
}
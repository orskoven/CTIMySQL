package orsk.compli.exception;

/**
 * Custom exception to handle database operation failures.
 */
public class DatabaseOperationException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String operation;
    private final String details;

    /**
     * Constructs a new DatabaseOperationException with the specified details.
     *
     * @param operation the database operation that failed
     * @param details   additional details about the failure
     */
    public DatabaseOperationException(String operation, String details) {
        super(String.format("Database operation '%s' failed: %s", operation, details));
        this.operation = operation;
        this.details = details;
    }

    /**
     * Gets the failed database operation.
     *
     * @return the operation name
     */
    public String getOperation() {
        return operation;
    }

    /**
     * Gets additional details about the failure.
     *
     * @return the details
     */
    public String getDetails() {
        return details;
    }
}
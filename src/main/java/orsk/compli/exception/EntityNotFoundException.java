package orsk.compli.exception;

/**
 * Custom exception to handle cases where a requested entity is not found.
 * This exception extends RuntimeException, making it an unchecked exception.
 */
public class EntityNotFoundException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String entityName;
    private final Object identifier;

    /**
     * Constructs a new EntityNotFoundException with the specified details.
     *
     * @param entityName the name of the entity that was not found
     * @param identifier the identifier of the entity that was not found
     */
    public EntityNotFoundException(String entityName, Object identifier) {
        super(String.format("%s not found with identifier: %s", entityName, identifier));
        this.entityName = entityName;
        this.identifier = identifier;
    }

    /**
     * Constructs a new EntityNotFoundException with a custom message.
     *
     * @param message the custom message
     */
    public EntityNotFoundException(String message) {
        super(message);
        this.entityName = null;
        this.identifier = null;
    }

    /**
     * Gets the name of the entity that was not found.
     *
     * @return the name of the entity
     */
    public String getEntityName() {
        return entityName;
    }

    /**
     * Gets the identifier of the entity that was not found.
     *
     * @return the identifier of the entity
     */
    public Object getIdentifier() {
        return identifier;
    }
}
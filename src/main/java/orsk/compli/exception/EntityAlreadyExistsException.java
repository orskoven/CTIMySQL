package orsk.compli.exception;

/**
 * Custom exception to handle cases where an entity already exists.
 */
public class EntityAlreadyExistsException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String entityName;
    private final Object identifier;

    /**
     * Constructs a new EntityAlreadyExistsException with the specified details.
     *
     * @param entityName the name of the entity
     * @param identifier the identifier of the existing entity
     */
    public EntityAlreadyExistsException(String entityName, Object identifier) {
        super(String.format("%s already exists with identifier: %s", entityName, identifier));
        this.entityName = entityName;
        this.identifier = identifier;
    }

    /**
     * Gets the name of the entity that already exists.
     *
     * @return the entity name
     */
    public String getEntityName() {
        return entityName;
    }

    /**
     * Gets the identifier of the entity that already exists.
     *
     * @return the identifier
     */
    public Object getIdentifier() {
        return identifier;
    }
}
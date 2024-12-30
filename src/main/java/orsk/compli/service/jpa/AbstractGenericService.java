package orsk.compli.service.jpa;

import jakarta.transaction.Transactional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.security.access.prepost.PreAuthorize;

import orsk.compli.exception.DatabaseOperationException;

import java.util.List;
import java.util.Optional;

/**
 * An abstract generic service providing CRUD operations.
 *
 * @param <T>  Entity type
 * @param <ID> Identifier type
 */
public abstract class AbstractGenericService<T, ID> implements CrudService<T, ID> {

    protected final Logger LOGGER = LoggerFactory.getLogger(getClass());

    /**
     * Provides the specific repository for the entity.
     *
     * @return JpaRepository for the entity
     */
    protected abstract JpaRepository<T, ID> getRepository();

    /**
     * Batch creation of entities.
     *
     * @param entities List of entities to be created
     * @return List of saved entities
     */
    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public List<T> createAll(List<T> entities) {
        if (entities == null || entities.isEmpty()) {
            LOGGER.warn("Attempted to create an empty or null list of entities.");
            throw new IllegalArgumentException("Entity list must not be null or empty.");
        }

        try {
            LOGGER.info("Batch creating entities of type: {}", entities.get(0).getClass().getSimpleName());
            return getRepository().saveAll(entities);
        } catch (DataAccessException e) {
            LOGGER.error("Error creating entities: {}", e.getMessage());
            throw new DatabaseOperationException("Error creating entities", entities.toString());
        }
    }

    /**
     * Creates a single entity.
     *
     * @param entity The entity to create
     * @return The created entity
     */
    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public T create(T entity) {
        if (entity == null) {
            LOGGER.warn("Attempted to create a null entity.");
            throw new IllegalArgumentException("Entity must not be null.");
        }

        try {
            LOGGER.info("Creating entity of type: {}", entity.getClass().getSimpleName());
            return getRepository().save(entity);
        } catch (DataAccessException e) {
            LOGGER.error("Error creating entity: {}", e.getMessage());
            throw new DatabaseOperationException("Error creating entity", entity.toString());
        }
    }

    /**
     * Retrieves all entities.
     *
     * @return List of all entities
     */
    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'USER')")
    public List<T> getAll() {
        try {
            LOGGER.info("Retrieving all entities of type: {}", getEntityClassName());
            return getRepository().findAll();
        } catch (DataAccessException e) {
            LOGGER.error("Error retrieving all entities: {}", e.getMessage());
            throw new DatabaseOperationException("Error retrieving all entities", e.getMessage());
        }
    }

    /**
     * Retrieves an entity by its ID.
     *
     * @param id The ID of the entity
     * @return Optional containing the entity if found, or empty if not found
     */
    @Override
    @PreAuthorize("hasAnyRole('ADMIN', 'USER')")
    public Optional<T> getById(ID id) {
        try {
            LOGGER.info("Retrieving entity of type: {} with ID: {}", getEntityClassName(), id);
            return getRepository().findById(id);
        } catch (DataAccessException e) {
            LOGGER.error("Error retrieving entity by ID: {}", e.getMessage());
            throw new DatabaseOperationException("Error retrieving entity by ID", id.toString());
        }
    }

    /**
     * Updates an existing entity by its ID.
     *
     * @param id     The ID of the entity to update
     * @param entity The updated entity data
     * @return The updated entity
     */
    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public T update(ID id, T entity) {
        if (entity == null) {
            LOGGER.warn("Attempted to update a null entity.");
            throw new IllegalArgumentException("Entity must not be null.");
        }

        try {
            LOGGER.info("Updating entity of type: {} with ID: {}", getEntityClassName(), id);
            return getRepository().findById(id)
                    .map(existing -> updateEntity(existing, entity))
                    .map(getRepository()::save)
                    .orElseThrow(() -> new orsk.compli.exception.EntityNotFoundException(
                            String.format("Entity not found with id %s", id)));
        } catch (DataAccessException e) {
            LOGGER.error("Error updating entity: {}", e.getMessage());
            throw new DatabaseOperationException("Error updating entity", entity.toString());
        }
    }

    /**
     * Deletes an entity by its ID.
     *
     * @param id The ID of the entity to delete
     * @return True if the entity was deleted, false if not found
     */
    @Override
    @Transactional
    @PreAuthorize("hasRole('ADMIN')")
    public boolean delete(ID id) {
        try {
            LOGGER.info("Deleting entity of type: {} with ID: {}", getEntityClassName(), id);
            if (getRepository().existsById(id)) {
                getRepository().deleteById(id);
                LOGGER.info("Entity with ID: {} deleted successfully.", id);
                return true;
            }
            LOGGER.warn("Entity with ID: {} not found for deletion.", id);
            return false;
        } catch (DataAccessException e) {
            LOGGER.error("Error deleting entity: {}", e.getMessage());
            throw new DatabaseOperationException("Error deleting entity", id.toString());
        }
    }

    /**
     * Provides the simple name of the entity class.
     *
     * @return The simple class name of the entity
     */
    private String getEntityClassName() {
        return getRepository().getDomainClass().getSimpleName();
    }

    /**
     * Defines how to update an existing entity with new values.
     * This method should be overridden by subclasses to handle specific field mappings.
     *
     * @param existing The existing entity fetched from the database
     * @param updated  The new entity data
     * @return The updated entity
     */
    protected abstract T updateEntity(T existing, T updated);
}
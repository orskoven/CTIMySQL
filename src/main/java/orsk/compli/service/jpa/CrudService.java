package orsk.compli.service.jpa;

import java.util.List;
import java.util.Optional;

/**
 * A generic interface for CRUD operations.
 *
 * @param <T>  Entity type
 * @param <ID> Identifier type
 */
public interface CrudService<T, ID> {

    /**
     * Creates a single entity.
     *
     * @param entity The entity to create
     * @return The created entity
     */
    T create(T entity);

    /**
     * Creates multiple entities in a batch.
     *
     * @param entities The list of entities to create
     * @return The list of created entities
     */
    List<T> createAll(List<T> entities);

    /**
     * Retrieves all entities.
     *
     * @return List of all entities
     */
    List<T> getAll();

    /**
     * Retrieves an entity by its ID.
     *
     * @param id The ID of the entity
     * @return Optional containing the entity if found, or empty if not found
     */
    Optional<T> getById(ID id);

    /**
     * Updates an existing entity by its ID.
     *
     * @param id     The ID of the entity to update
     * @param entity The updated entity data
     * @return The updated entity
     */
    T update(ID id, T entity);

    /**
     * Deletes an entity by its ID.
     *
     * @param id The ID of the entity to delete
     * @return True if the entity was deleted, false if not found
     */
    boolean delete(ID id);
}
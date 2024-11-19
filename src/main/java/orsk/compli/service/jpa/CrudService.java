package orsk.compli.service.jpa;

import java.util.List;
import java.util.Optional;

public interface CrudService<T, ID> {
    T create(T t);

    List<T> getAll();

    Optional<T> getById(ID id);

    T update(ID id, T t);

    boolean delete(ID id);
}


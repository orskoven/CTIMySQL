package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.entities.jpa.JpaGeolocation;
import orsk.compli.repository.jpa.GeolocationJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaGeolocationService")
public class GeolocationJpaService implements CrudService<JpaGeolocation, Long> {

    private final GeolocationJpaRepository geolocationServiceRepository;

    @Autowired
    public GeolocationJpaService(GeolocationJpaRepository geolocationServiceRepository) {
        this.geolocationServiceRepository = geolocationServiceRepository;
    }

    @Override
    public JpaGeolocation create(JpaGeolocation entity) {
        return geolocationServiceRepository.save(entity);
    }

    @Override
    public List<JpaGeolocation> getAll() {
        return geolocationServiceRepository.findAll();
    }

    @Override
    public Optional<JpaGeolocation> getById(Long id) {
        return geolocationServiceRepository.findById(Long.valueOf(String.valueOf(id)));
    }

    @Override
    public JpaGeolocation update(Long id, JpaGeolocation entity) {
        Optional<JpaGeolocation> optionalEntity = geolocationServiceRepository.findById(Long.valueOf(String.valueOf(id)));
        if (optionalEntity.isPresent()) {
            JpaGeolocation existingEntity = optionalEntity.get();
            // TODO: Update fields of existingEntity with values from entity
            return geolocationServiceRepository.save(existingEntity);
        } else {
            throw new RuntimeException("Entity not found with id " + id);
        }
    }

    @Override
    public boolean delete(Long id) {
        if (geolocationServiceRepository.existsById(Long.valueOf(String.valueOf(id)))) {
            geolocationServiceRepository.deleteById(Long.valueOf(String.valueOf(id)));
            return true;
        }
        return false;
    }
}

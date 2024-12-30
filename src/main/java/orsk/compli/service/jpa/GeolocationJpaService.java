
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.Geolocation;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.GeolocationJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaGeolocationService")
public class GeolocationJpaService implements CrudService<Geolocation, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(GeolocationJpaService.class);

    private final GeolocationJpaRepository geolocationRepository;

    @Autowired
    public GeolocationJpaService(GeolocationJpaRepository geolocationRepository) {
        this.geolocationRepository = geolocationRepository;
    }

    @Override
    @Transactional
    public Geolocation create(Geolocation entity) {
        LOGGER.info("Creating Geolocation: {}", entity);
        return geolocationRepository.save(entity);
    }

    @Override
    public List<Geolocation> createBatch(List<Geolocation> entities) {
        return List.of();
    }

    @Override
    public List<Geolocation> getAll() {
        LOGGER.info("Retrieving all Geolocations");
        return geolocationRepository.findAll();
    }

    @Override
    public Optional<Geolocation> getById(Long id) {
        LOGGER.info("Retrieving Geolocation with ID: {}", id);
        return geolocationRepository.findById(id);
    }

    @Override
    @Transactional
    public Geolocation update(Long id, Geolocation entity) {
        LOGGER.info("Updating Geolocation with ID: {}", id);
        return geolocationRepository.findById(id)
                .map(existing -> {
                    existing.setLatitude(entity.getLatitude());
                    existing.setLongitude(entity.getLongitude());
                    existing.setCountry(entity.getCountry());
                    // Add other field mappings as necessary
                    return geolocationRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Geolocation not found with id " + id));
    }

    @Override
    @Transactional
    public boolean delete(Long id) {
        LOGGER.info("Deleting Geolocation with ID: {}", id);
        if (geolocationRepository.existsById(id)) {
            geolocationRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Geolocation with ID: {} not found for deletion", id);
        return false;
    }
}


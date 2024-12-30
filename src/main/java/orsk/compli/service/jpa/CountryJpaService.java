
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.Country;
import orsk.compli.exception.DatabaseOperationException;
import orsk.compli.exception.EntityNotFoundException;
import orsk.compli.repository.jpa.CountryJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaCountryService")
public class CountryJpaService implements CrudService<Country, Long> {

    private static final Logger LOGGER = LoggerFactory.getLogger(CountryJpaService.class);

    private final CountryJpaRepository countryRepository;

    @Autowired
    public CountryJpaService(CountryJpaRepository countryRepository) {
        this.countryRepository = countryRepository;
    }

    @Override
    @Transactional
    public Country create(Country entity) {
        LOGGER.info("Creating Country: {}", entity);
        return countryRepository.save(entity);
    }

    @Override
    public List<Country> createBatch(List<Country> entities) {
        return List.of();
    }

    @Override
    public List<Country> getAll() {
        LOGGER.info("Retrieving all Countries");
        return countryRepository.findAll();
    }

    @Override
    public Optional<Country> getById(Long id) {
        LOGGER.info("Retrieving Country with ID: {}", id);
        return countryRepository.findById(id);
    }

    @Override
    @Transactional
    public Country update(Long id, Country entity) {
        LOGGER.info("Updating Country with ID: {}", id);
        return countryRepository.findById(id)
                .map(existing -> {
                    existing.setCountryCode(entity.getCountryCode());
                    existing.setName(entity.getName());
                    // Add other field mappings as necessary
                    return countryRepository.save(existing);
                })
                .orElseThrow(() -> new EntityNotFoundException("Country not found with id " + id));
    }

    @Override
    @Transactional
    //@PreAuthorize("hasRole(ADMIN)")
    public boolean delete(Long id) {
        LOGGER.info("Deleting Country with ID: {}", id);
        if (countryRepository.existsById(id)) {
            countryRepository.deleteById(id);
            return true;
        }
        LOGGER.warn("Country with ID: {} not found for deletion", id);
        return false;
    }

    // Batch creation of countries
    @Transactional
    //@PreAuthorize("hasRole(ADMIN)")
    public List<Country> createAll(List<Country> countries) {
        try {
            LOGGER.info("Batch creating Countries");
            return countryRepository.saveAll(countries);
        } catch (DataAccessException e) {
            LOGGER.error("Error creating countries: {}", e.getMessage());
            throw new DatabaseOperationException("Error creating countries", countries.toString());
        }
    }
}


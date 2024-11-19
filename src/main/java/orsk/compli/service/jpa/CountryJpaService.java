package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.jpa.JpaCountry;
import orsk.compli.repository.jpa.CountryJpaRepository;

import java.util.List;
import java.util.Optional;

@Service("jpaCountryService")

public class CountryJpaService implements CrudService<JpaCountry, Long> {

    private final CountryJpaRepository countryRepository;

    @Autowired
    public CountryJpaService(CountryJpaRepository countryRepository) {
        this.countryRepository = countryRepository;
    }

    @Override
    public JpaCountry create(JpaCountry entity) {
        return countryRepository.save(entity);
    }

    @Override
    public List<JpaCountry> getAll() {
        return countryRepository.findAll();
    }

    @Override
    public Optional<JpaCountry> getById(Long id) {
        return countryRepository.findById(id);
    }

    @Override
    public JpaCountry update(Long id, JpaCountry entity) {
        return countryRepository.findById(id).map(existingEntity -> {
            // Copy fields from the input entity to the existing entity
            existingEntity.setCountryCode(entity.getCountryCode());
            existingEntity.setCountryCode(entity.getCountryCode());
            //     existingEntity.setThreatActors(entity.getThreatActors());
            //     existingEntity.setGeolocations(entity.getGeolocations());
            return countryRepository.save(existingEntity);
        }).orElseThrow(() -> new RuntimeException("Entity not found with id " + id));
    }

    @Override
    public boolean delete(Long id) {
        if (countryRepository.existsById(id)) {
            countryRepository.deleteById(id);
            return true;
        }
        return false;
    }

    // Batch creation of countries
    @Transactional
    public List<JpaCountry> createAll(List<JpaCountry> countries) {
        try {
            return countryRepository.saveAll(countries);
        } catch (DataAccessException e) {
            throw new RuntimeException("Error creating countries", e);
        }
    }
}
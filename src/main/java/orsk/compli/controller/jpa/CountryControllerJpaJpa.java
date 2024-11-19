package orsk.compli.controller.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;
import orsk.compli.entities.jpa.JpaCountry;
import orsk.compli.service.jpa.CountryJpaService;

import java.util.List;

@RestController("jpaCountryController")
@RequestMapping("/api/mysql/countries")


public class CountryControllerJpaJpa extends AbstractCrudControllerJpa<JpaCountry, Long> {

    private static final Logger logger = LoggerFactory.getLogger(CountryControllerJpaJpa.class);
    private final CountryJpaService countryService;

    public CountryControllerJpaJpa(CountryJpaService countryService) {
        this.countryService = countryService;
    }

    @Override
    protected CountryJpaService getService() {
        return countryService;
    }

    // Batch create endpoint
    @PostMapping("/batch")
    public ResponseEntity<List<JpaCountry>> createBatch(@RequestBody List<JpaCountry> countries) {
        try {
            List<JpaCountry> createdCountries = countryService.createAll(countries);
            return ResponseEntity.status(HttpStatus.CREATED).body(createdCountries);
        } catch (DataAccessException e) {
            logger.error("Error creating countries: {}", e.getMessage());
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Error creating countries");
        }
    }


}
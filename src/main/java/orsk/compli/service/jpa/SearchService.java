
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import orsk.compli.repository.jpa.AffectedProductJpaRepository;
import orsk.compli.repository.jpa.CountryJpaRepository;
import orsk.compli.repository.jpa.GlobalThreatJpaRepository;

import java.util.List;

@Service("jpaSearchService")
public class SearchService {

    private static final Logger LOGGER = LoggerFactory.getLogger(SearchService.class);

    private final AffectedProductJpaRepository affectedProductRepository;
    private final CountryJpaRepository countryRepository;
    private final GlobalThreatJpaRepository globalThreatRepository;

    @Autowired
    public SearchService(AffectedProductJpaRepository affectedProductRepository,
                         CountryJpaRepository countryRepository,
                         GlobalThreatJpaRepository globalThreatRepository) {
        this.affectedProductRepository = affectedProductRepository;
        this.countryRepository = countryRepository;
        this.globalThreatRepository = globalThreatRepository;
    }

    public List<String> getAffectedProductNames() {
        LOGGER.info("Fetching Affected Product Names");
        return affectedProductRepository.findAllProductNames();
    }

    public List<String> getCountryNames() {
        LOGGER.info("Fetching Country Names");
        return countryRepository.findAllCountryNames();
    }

    public List<String> getGlobalThreatNames() {
        LOGGER.info("Fetching Global Threat Names");
        return globalThreatRepository.findAllThreatNames();
    }

    // Add more search methods as needed with appropriate logging and security
}


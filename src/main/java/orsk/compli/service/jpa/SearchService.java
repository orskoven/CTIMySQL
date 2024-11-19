// File: src/main/java/orsk/compli/service/SearchService.java

package orsk.compli.service.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import orsk.compli.repository.jpa.AffectedProductJpaRepository;
import orsk.compli.repository.jpa.CountryJpaRepository;
import orsk.compli.repository.jpa.GlobalThreatJpaRepository;

import java.util.List;

@Service("jpaSearchService")
public class SearchService {

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
        return affectedProductRepository.findAllProductNames();
    }

    public List<String> getCountryNames() {
        return countryRepository.findAllCountryNames();
    }

    public List<String> getGlobalThreatNames() {
        return globalThreatRepository.findAllThreatNames();
    }

    // Add more methods as needed
}
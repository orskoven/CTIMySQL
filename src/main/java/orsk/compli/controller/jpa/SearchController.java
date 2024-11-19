// File: src/main/java/orsk/compli/controller/SearchController.java

package orsk.compli.controller.jpa;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.dtos.SearchOptionsResponse;
import orsk.compli.service.jpa.SearchService;

import java.util.List;

@RestController("jpaSearchController")
@RequestMapping("/api/mysql")
@CrossOrigin(origins = {"http://localhost:5173"}) // Ensure this matches your frontend origin
public class SearchController {

    private final SearchService searchService;

    @Autowired
    public SearchController(SearchService searchService) {
        this.searchService = searchService;
    }

    @GetMapping("/search-options")
    public SearchOptionsResponse getSearchOptions() {
        List<String> products = searchService.getAffectedProductNames();
        List<String> countries = searchService.getCountryNames();
        List<String> threats = searchService.getGlobalThreatNames();
        // Add more categories as needed

        return new SearchOptionsResponse(products, countries, threats);
    }
}
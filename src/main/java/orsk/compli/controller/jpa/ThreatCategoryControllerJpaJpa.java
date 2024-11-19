package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.JpaThreatCategory;
import orsk.compli.service.jpa.ThreatCategoryJpaService;

@RestController("jpaThreatCategoryController")
@RequestMapping("/api/mysql/threat-categorys")
@CrossOrigin(origins = {"http://localhost:5173"})

public class ThreatCategoryControllerJpaJpa extends AbstractCrudControllerJpa<JpaThreatCategory, Long> {

    private final ThreatCategoryJpaService threatCategoryService;

    public ThreatCategoryControllerJpaJpa(ThreatCategoryJpaService threatCategoryService) {
        this.threatCategoryService = threatCategoryService;
    }

    @Override
    protected ThreatCategoryJpaService getService() {
        return threatCategoryService;
    }


}

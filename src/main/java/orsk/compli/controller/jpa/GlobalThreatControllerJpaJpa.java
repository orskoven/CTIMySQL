package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.JpaGlobalThreat;
import orsk.compli.service.jpa.CrudService;
import orsk.compli.service.jpa.GlobalThreatJpaService;

@RestController("jpaGlobalThreatController")
@RequestMapping("/api/mysql/global-threats")
@CrossOrigin(origins = "https://blue-river-05c43af0f.5.azurestaticapps.net")


public class GlobalThreatControllerJpaJpa extends AbstractCrudControllerJpa<JpaGlobalThreat, Long> {

    private final GlobalThreatJpaService globalThreatService;

    public GlobalThreatControllerJpaJpa(GlobalThreatJpaService globalThreatService) {
        this.globalThreatService = globalThreatService;
    }

    @Override
    protected CrudService<JpaGlobalThreat, Long> getService() {
        return globalThreatService;
    }


}

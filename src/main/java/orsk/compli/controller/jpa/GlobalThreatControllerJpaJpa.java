package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.GlobalThreat;
import orsk.compli.service.jpa.CrudService;
import orsk.compli.service.jpa.GlobalThreatJpaService;

@RestController("jpaGlobalThreatController")
@RequestMapping("/api/mysql/global-threats")


public class GlobalThreatControllerJpaJpa extends AbstractCrudControllerJpa<GlobalThreat, Long> {

    private final GlobalThreatJpaService globalThreatService;

    public GlobalThreatControllerJpaJpa(GlobalThreatJpaService globalThreatService) {
        this.globalThreatService = globalThreatService;
    }

    @Override
    protected CrudService<GlobalThreat, Long> getService() {
        return globalThreatService;
    }


}

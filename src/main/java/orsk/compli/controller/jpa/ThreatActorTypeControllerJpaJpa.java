package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.JpaThreatActorType;
import orsk.compli.service.jpa.ThreatActorTypeJpaService;

@RestController("jpaThreatActorTypeController")
@RequestMapping("/api/mysql/threat-actor-types")
@CrossOrigin(origins = {"http://localhost:5173"})

public class ThreatActorTypeControllerJpaJpa extends AbstractCrudControllerJpa<JpaThreatActorType, Long> {

    private final ThreatActorTypeJpaService threatActorTypeService;

    public ThreatActorTypeControllerJpaJpa(ThreatActorTypeJpaService threatActorTypeService) {
        this.threatActorTypeService = threatActorTypeService;
    }

    @Override
    protected ThreatActorTypeJpaService getService() {
        return threatActorTypeService;
    }


}

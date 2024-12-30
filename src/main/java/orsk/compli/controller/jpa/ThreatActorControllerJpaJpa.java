package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.ThreatActor;
import orsk.compli.service.jpa.ThreatActorJpaService;

@RestController("jpaThreatActorController")
@RequestMapping("/api/mysql/threat-actors")

public class ThreatActorControllerJpaJpa extends AbstractCrudControllerJpa<ThreatActor, Long> {

    private final ThreatActorJpaService threatActorService;

    public ThreatActorControllerJpaJpa(ThreatActorJpaService threatActorService) {
        this.threatActorService = threatActorService;
    }

    @Override
    protected ThreatActorJpaService getService() {
        return threatActorService;
    }


}

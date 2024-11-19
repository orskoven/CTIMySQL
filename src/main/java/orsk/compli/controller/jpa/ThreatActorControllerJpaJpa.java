package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.JpaThreatActor;
import orsk.compli.service.jpa.ThreatActorJpaService;

@RestController("jpaThreatActorController")
@RequestMapping("/api/mysql/threat-actors")
@CrossOrigin(origins = {"http://localhost:5173"})

public class ThreatActorControllerJpaJpa extends AbstractCrudControllerJpa<JpaThreatActor, Long> {

    private final ThreatActorJpaService threatActorService;

    public ThreatActorControllerJpaJpa(ThreatActorJpaService threatActorService) {
        this.threatActorService = threatActorService;
    }

    @Override
    protected ThreatActorJpaService getService() {
        return threatActorService;
    }


}

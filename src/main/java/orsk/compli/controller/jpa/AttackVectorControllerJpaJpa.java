package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.JpaAttackVector;
import orsk.compli.service.jpa.AttackVectorJpaService;

@RestController("jpaAttackVectorController")
@RequestMapping("/api/mysql/attack-vectors")
@CrossOrigin(origins = {"http://localhost:5173"})


public class AttackVectorControllerJpaJpa extends AbstractCrudControllerJpa<JpaAttackVector, Long> {

    private final AttackVectorJpaService attackVectorService;

    public AttackVectorControllerJpaJpa(AttackVectorJpaService attackVectorService) {
        this.attackVectorService = attackVectorService;
    }

    @Override
    protected AttackVectorJpaService getService() {
        return attackVectorService;
    }


}

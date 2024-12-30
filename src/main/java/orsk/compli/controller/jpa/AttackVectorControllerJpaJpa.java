package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.AttackVector;
import orsk.compli.service.jpa.AttackVectorJpaService;

@RestController("jpaAttackVectorController")
@RequestMapping("/api/mysql/attack-vectors")


public class AttackVectorControllerJpaJpa extends AbstractCrudControllerJpa<AttackVector, Long> {

    private final AttackVectorJpaService attackVectorService;

    public AttackVectorControllerJpaJpa(AttackVectorJpaService attackVectorService) {
        this.attackVectorService = attackVectorService;
    }

    @Override
    protected AttackVectorJpaService getService() {
        return attackVectorService;
    }


}

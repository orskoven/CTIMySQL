package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.AttackVectorCategory;
import orsk.compli.service.jpa.AttackVectorCategoryJpaService;

@RestController("jpaAttackVectorCategoryController")
@RequestMapping("/api/mysql/attack-vector-categorys")

public class AttackVectorCategoryControllerJpaJpa extends AbstractCrudControllerJpa<AttackVectorCategory, Long> {

    private final AttackVectorCategoryJpaService attackVectorCategoryService;

    public AttackVectorCategoryControllerJpaJpa(AttackVectorCategoryJpaService attackVectorCategoryService) {
        this.attackVectorCategoryService = attackVectorCategoryService;
    }

    @Override
    protected AttackVectorCategoryJpaService getService() {
        return attackVectorCategoryService;
    }


}

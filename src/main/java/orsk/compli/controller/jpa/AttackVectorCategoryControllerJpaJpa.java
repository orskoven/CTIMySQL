package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.jpa.JpaAttackVectorCategory;
import orsk.compli.service.jpa.AttackVectorCategoryJpaService;

@RestController("jpaAttackVectorCategoryController")
@RequestMapping("/api/mysql/attack-vector-categorys")
@CrossOrigin(origins = {"http://localhost:5173"})

public class AttackVectorCategoryControllerJpaJpa extends AbstractCrudControllerJpa<JpaAttackVectorCategory, Long> {

    private final AttackVectorCategoryJpaService attackVectorCategoryService;

    public AttackVectorCategoryControllerJpaJpa(AttackVectorCategoryJpaService attackVectorCategoryService) {
        this.attackVectorCategoryService = attackVectorCategoryService;
    }

    @Override
    protected AttackVectorCategoryJpaService getService() {
        return attackVectorCategoryService;
    }


}

// src/main/java/orsk/compli/controller/AffectedProductController.java

package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.AffectedProduct;
import orsk.compli.service.jpa.AffectedProductJpaService;
import orsk.compli.service.jpa.CrudService;

@RestController("jpaAffectedProductController")
@RequestMapping("/api/mysql/affected-products")
public class AffectedProductControllerJpaJpa extends AbstractCrudControllerJpa<AffectedProduct, Long> { // Changed ID type to Integer

    private final AffectedProductJpaService affectedProductService;

    public AffectedProductControllerJpaJpa(AffectedProductJpaService affectedProductService) {
        this.affectedProductService = affectedProductService;
    }

    @Override
    protected CrudService<AffectedProduct, Long> getService() {
        return affectedProductService;
    }
}
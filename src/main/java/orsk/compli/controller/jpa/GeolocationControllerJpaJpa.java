package orsk.compli.controller.jpa;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import orsk.compli.entities.Geolocation;
import orsk.compli.service.jpa.GeolocationJpaService;

@RestController("jpaGeolocationController")
@RequestMapping("/api/mysql/geolocations")


public class GeolocationControllerJpaJpa extends AbstractCrudControllerJpa<Geolocation, Long> {

    private final GeolocationJpaService geolocationService;

    public GeolocationControllerJpaJpa(GeolocationJpaService geolocationService) {
        this.geolocationService = geolocationService;
    }

    @Override
    protected GeolocationJpaService getService() {
        return geolocationService;
    }


}

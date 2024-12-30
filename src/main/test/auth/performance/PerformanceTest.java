// src/test/java/orsk/authmodule/tests/PerformanceTest.java
package auth.performance;

import io.gatling.javaapi.core.*;
import io.gatling.javaapi.http.*;

import static io.gatling.javaapi.core.CoreDsl.*;
import static io.gatling.javaapi.http.HttpDsl.*;

public class PerformanceTest extends Simulation {

    HttpProtocolBuilder httpProtocol = http
        .baseUrl("http://localhost:8080")
        .acceptHeader("application/json");

    ScenarioBuilder scn = scenario("AuthModule Load Test")
        .exec(
            http("Login Request")
                .post("/api/auth/login")
                .header("Content-Type", "application/json")
                .body(StringBody("{\"email\":\"testuser@example.com\",\"password\":\"StrongPassword@123\"}")).asJson()
                .check(status().is(200))
        );

    {
        setUp(
            scn.injectOpen(rampUsers(1000).during(60))
        ).protocols(httpProtocol);
    }
}
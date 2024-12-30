// src/test/java/orsk/authmodule/tests/StressTest.java
package auth.stress;

import io.gatling.javaapi.core.*;
import io.gatling.javaapi.http.*;

import static io.gatling.javaapi.core.CoreDsl.*;
import static io.gatling.javaapi.http.HttpDsl.*;

public class StressTest extends Simulation {

    HttpProtocolBuilder httpProtocol = http
        .baseUrl("http://localhost:8080")
        .acceptHeader("application/json");

    ScenarioBuilder scn = scenario("Stress Test - Login Endpoint")
        .exec(
            http("Login")
                .post("/api/auth/login")
                .header("Content-Type", "application/json")
                .body(StringBody("{\"email\":\"stressuser@example.com\",\"password\":\"StrongPassword@123\"}")).asJson()
                .check(status().is(200))
        );

    {
        setUp(
            scn.injectOpen(rampUsers(5000).during(300))
        ).protocols(httpProtocol);
    }
}
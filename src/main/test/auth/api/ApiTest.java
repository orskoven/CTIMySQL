// src/test/java/orsk/authmodule/tests/ApiTest.java
package auth.api;

import io.restassured.RestAssured;
import io.restassured.http.ContentType;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.*;
import static org.hamcrest.Matchers.equalTo;

public class ApiTest {

    @BeforeAll
    public static void setup() {
        RestAssured.baseURI = "http://localhost";
        RestAssured.port = 8085;
    }

    @Test
    @DisplayName("API Test: Successful Registration")
    public void testRegisterUser_Success() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"username\":\"apiUser\",\"email\":\"apiuser@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":true}")
        .when()
            .post("/api/auth/register")
        .then()
            .statusCode(201)
            .body(equalTo("User registered successfully. Please check your email for verification instructions."));
    }

    @Test
    @DisplayName("API Test: Registration with Existing Email")
    public void testRegisterUser_Conflict() {
        given()
            .contentType(ContentType.JSON)
            .body("{\"username\":\"apiUser2\",\"email\":\"apiuser@example.com\",\"password\":\"StrongPassword@123\",\"consentToDataUsage\":true}")
        .when()
            .post("/api/auth/register")
        .then()
            .statusCode(409)
            .body(equalTo("Username or email already exists"));
    }

    // Additional API tests for login, password reset, etc.
}
package auth.endToEnd;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

import static org.hibernate.validator.internal.util.Contracts.assertTrue;
import static org.junit.Assert.assertEquals;

public class AuthControllerE2ETest {

    private WebDriver driver;

    @BeforeEach
    public void setUp() {
        // Update the path to your ChromeDriver executable
        System.setProperty("webdriver.chrome.driver", "/opt/homebrew/bin/chromedriver");
        driver = new ChromeDriver();
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    @DisplayName("End-to-End Test: User Registration")
    public void testUserRegistration() {
        driver.get("http://localhost:5173/register");

        // Fill out the registration form
        WebElement username = driver.findElement(By.id("username"));
        WebElement email = driver.findElement(By.id("email"));
        WebElement password = driver.findElement(By.id("password"));
        WebElement consent = driver.findElement(By.id("consent"));
        WebElement submit = driver.findElement(By.id("submit"));

        username.sendKeys("e2eUser");
        email.sendKeys("e2euser@example.com");
        password.sendKeys("StrongPassword@123");
        consent.click();
        submit.click();

        // Verify the success message
        WebElement successMessage = driver.findElement(By.id("success-message"));
        assertEquals("Registration successful. Please verify your email.", successMessage.getText());
    }

    @Test
    @DisplayName("End-to-End Test: User Login")
    public void testUserLogin() {
        driver.get("http://localhost:5173/login");

        // Fill out the login form
        WebElement email = driver.findElement(By.id("email"));
        WebElement password = driver.findElement(By.id("password"));
        WebElement loginSubmit = driver.findElement(By.id("login-submit"));

        email.sendKeys("e2euser@example.com");
        password.sendKeys("StrongPassword@123");
        loginSubmit.click();

        // Verify the user is redirected to the dashboard
        WebElement dashboard = driver.findElement(By.id("dashboard"));
        assertTrue(dashboard.isDisplayed(), "Dashboard should be displayed after a successful login.");
    }
}
package auth.seleniumTests;// src/test/java/orsk/authmodule/tests/SeleniumTests.java
/*package orsk.authmodule.seleniumTests;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class SeleniumTests {

    private WebDriver driver;

    @Autowired
    private UserRepository userRepository;

    @BeforeAll
    public static void setupClass() {
        WebDriverManager.chromedriver().setup();
    }

    @BeforeEach
    public void setupTest() {
        driver = new ChromeDriver();
    }

    @AfterEach
    public void teardown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
    @DisplayName("Selenium Test: User Registration")
    public void testUserRegistration() {
        driver.get("http://localhost:5173/register");

        WebElement username = driver.findElement(By.id("username"));
        WebElement email = driver.findElement(By.id("email"));
        WebElement password = driver.findElement(By.id("password"));
        WebElement consent = driver.findElement(By.id("consent"));
        WebElement submit = driver.findElement(By.id("submit"));

        username.sendKeys("seleniumUser");
        email.sendKeys("seleniumuser@example.com");
        password.sendKeys("StrongPassword@123");
        consent.click();
        submit.click();

        WebElement successMessage = driver.findElement(By.id("success-message"));
        assertEquals("Registration successful. Please verify your email.", successMessage.getText());

        User user = userRepository.findByEmail("seleniumuser@example.com").orElse(null);
        assertNotNull(user);
        assertEquals("seleniumUser", user.getUsername());
    }

    // Additional Selenium tests...
}*/
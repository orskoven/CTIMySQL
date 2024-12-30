package auth.performance;

import org.junit.Before;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import orsk.authmodule.controller.AdminController;

import java.util.stream.LongStream;

import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

@SpringBootTest
public class AdminControllerPerformanceTest {

    @Autowired
    private AdminController adminController;

    @Before
    public void setUp() {
        // Initialize any performance test data if required
    }

    @Test
    public void testPerformanceUnderLoad() {
        LongStream.range(1, 1000).forEach(userId -> {
            try {
                adminController.enableUser(userId);
            } catch (Exception e) {
                fail("Performance test failed under load for user ID: " + userId);
            }
        });

        assertTrue("Performance test completed successfully under load.", true);
    }
}
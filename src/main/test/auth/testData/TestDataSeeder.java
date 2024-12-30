package auth.testData;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;

import java.io.File;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.mockito.Mockito.when;

public class TestDataSeeder {

    private static TestData testData; // Class-level variable to hold the parsed data

    public static void main(String[] args) throws Exception {
        ObjectMapper mapper = new ObjectMapper();
        testData = mapper.readValue(new File("src/test/resources/test-data.json"), TestData.class);

        System.out.println("Users: " + testData.toString());
    }

    @Mock
    private UserRepository userRepository;

    @Test
    public void testGetUsers() {
        // Use the testData initialized in the main method
        when(userRepository.findAll()).thenReturn(testData.getUsers());
        List<User> users = userRepository.findAll();

        assertEquals(3, users.size()); // Adjust this based on your actual test data
        assertEquals("admin", users.get(0).getUsername()); // Adjust based on test-data.json
    }
}
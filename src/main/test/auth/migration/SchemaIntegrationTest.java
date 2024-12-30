package auth.migration;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import orsk.authmodule.model.User;
import orsk.authmodule.repository.UserRepository;

@DataJpaTest
public class SchemaIntegrationTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    public void testSchemaMigration() {
        User user = new User();
        user.setUsername("testuser");
        user.setEmail("test@example.com");

        User savedUser = userRepository.save(user);

        assertThat(savedUser.getId()).isNotNull();
        assertThat(savedUser.getUsername()).isEqualTo("testuser");
    }
}
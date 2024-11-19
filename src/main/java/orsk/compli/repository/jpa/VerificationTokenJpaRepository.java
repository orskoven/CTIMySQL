package orsk.compli.repository.jpa;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.jpa.User;
import orsk.compli.entities.jpa.VerificationToken;

import java.util.Optional;

@Repository("VerificationTokenJpaRepository")
public interface VerificationTokenJpaRepository extends JpaRepository<VerificationToken, Long> {
    Optional<VerificationToken> findByToken(String token);

    Optional<VerificationToken> findByUser(User user);
}

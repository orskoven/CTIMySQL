package orsk.compli.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.VerificationToken;
import orsk.compli.entities.User;

import java.util.Optional;

@Repository("VerificationTokenJpaRepository")
public interface VerificationTokenRepository extends JpaRepository<VerificationToken, Long> {
    Optional<VerificationToken> findByToken(String token);

    Optional<VerificationToken> findByUser(User user);

    Optional<VerificationToken> findByUserEmail(String email);
}

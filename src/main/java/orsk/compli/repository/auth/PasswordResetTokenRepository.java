package orsk.compli.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.PasswordResetToken;

import java.util.Optional;

@Repository("PasswordResetTokenJpaRepository")
public interface PasswordResetTokenRepository extends JpaRepository<PasswordResetToken, Long> {
    Optional<PasswordResetToken> findByToken(String token);
}

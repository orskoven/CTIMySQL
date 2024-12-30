package orsk.compli.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.RefreshToken;
import orsk.compli.entities.User;


import java.util.Optional;

@Repository("RefreshTokenJpaRepository")
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {
    Optional<RefreshToken> findByToken(String token);

    int deleteByUser(User user);
}
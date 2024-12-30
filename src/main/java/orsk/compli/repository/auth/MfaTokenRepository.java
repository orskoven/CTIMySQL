package orsk.compli.repository.auth;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import orsk.compli.entities.MfaToken;
import orsk.compli.entities.User;


import java.util.Optional;

@Repository("MfaTokenJpaRepository")
public interface MfaTokenRepository extends JpaRepository<MfaToken, Long> {
    Optional<MfaToken> findByMfaCode(String mfaCode);
    Optional<MfaToken> findByMfaCodeAndUser(String mfaCode, User user);

    Optional<MfaToken> findByUserUsername(String username);
}
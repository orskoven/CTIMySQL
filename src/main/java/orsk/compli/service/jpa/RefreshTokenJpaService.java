
package orsk.compli.service.jpa;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.RefreshToken;
import orsk.compli.entities.User;
import orsk.compli.exception.InvalidTokenException;
import orsk.compli.exception.UserNotFoundException;
import orsk.compli.repository.auth.RefreshTokenRepository;
import orsk.compli.repository.auth.UserRepository;

import java.time.Instant;
import java.util.Optional;
import java.util.UUID;

@Service("jpaRefreshTokenService")
public class RefreshTokenJpaService {

    private static final Logger LOGGER = LoggerFactory.getLogger(RefreshTokenJpaService.class);

    @Autowired
    private RefreshTokenRepository refreshTokenRepository;

    @Autowired
    private UserRepository userRepository;

    public Optional<RefreshToken> findByToken(String token) {
        LOGGER.info("Finding Refresh Token: {}", token);
        return refreshTokenRepository.findByToken(token);
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public RefreshToken createRefreshToken(String username) {
        LOGGER.info("Creating Refresh Token for user: {}", username);
        RefreshToken refreshToken = new RefreshToken();

        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new UserNotFoundException("User not found"));

        refreshToken.setUser(user);
        refreshToken.setExpiryDate(Instant.now().plusSeconds(604800)); // 7 days
        refreshToken.setToken(UUID.randomUUID().toString());

        RefreshToken savedToken = refreshTokenRepository.save(refreshToken);
        LOGGER.info("Refresh Token created: {}", savedToken.getToken());
        return savedToken;
    }

    public RefreshToken verifyExpiration(RefreshToken token) {
        LOGGER.info("Verifying expiration for Refresh Token: {}", token.getToken());
        if (token.getExpiryDate().isBefore(Instant.now())) {
            LOGGER.warn("Refresh Token expired: {}", token.getToken());
            refreshTokenRepository.delete(token);
            throw new InvalidTokenException("Refresh token expired");
        }
        return token;
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public int deleteByUserId(Long userId) {
        LOGGER.info("Deleting Refresh Tokens for User ID: {}", userId);
        return refreshTokenRepository.deleteByUser(userRepository.findById(userId)
                .orElseThrow(() -> new UserNotFoundException("User not found")));
    }

    @Transactional
    @PreAuthorize("isAuthenticated()")
    public void deleteByToken(String token) {
        LOGGER.info("Deleting Refresh Token: {}", token);
        refreshTokenRepository.findByToken(token).ifPresent(rt -> {
            refreshTokenRepository.delete(rt);
            LOGGER.info("Refresh Token deleted: {}", token);
        });
    }
}


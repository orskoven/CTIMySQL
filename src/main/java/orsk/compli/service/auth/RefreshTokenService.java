package orsk.compli.service.auth;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import orsk.compli.entities.RefreshToken;
import orsk.compli.entities.User;
import orsk.compli.exception.auth.InvalidTokenException;
import orsk.compli.repository.auth.RefreshTokenRepository;
import orsk.compli.repository.auth.UserRepository;


import java.time.Instant;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

@Service("RefreshTokenService")
@RequiredArgsConstructor
@Slf4j
public class RefreshTokenService {

    private static final long REFRESH_TOKEN_EXPIRY = 604800L; // 7 days

    private final RefreshTokenRepository refreshTokenRepository;
    private final UserRepository userRepository;

    @Transactional
    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }

    @Transactional
    public RefreshToken createRefreshToken(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found for username: " + username));

        RefreshToken refreshToken = new RefreshToken();
        refreshToken.setUser(user);
        refreshToken.setExpiryDate(Instant.now().plusSeconds(REFRESH_TOKEN_EXPIRY));
        refreshToken.setToken(UUID.randomUUID().toString());

        log.debug("Created new refresh token for user: {}", username);
        return refreshTokenRepository.save(refreshToken);
    }

    @Transactional
    public RefreshToken verifyExpiration(RefreshToken token) {
        if (token.getExpiryDate().isBefore(Instant.now())) {
            refreshTokenRepository.delete(token);
            throw new InvalidTokenException("Refresh token expired");
        }
        return token;
    }

    @Transactional
    public void deleteByToken(String token) {
        findByToken(token).ifPresent(refreshToken -> {
            refreshTokenRepository.delete(refreshToken);
            log.debug("Deleted refresh token: {}", token);
        });
    }

    @Transactional
    public void revokeTokensForUser(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));
        int deletedCount = refreshTokenRepository.deleteByUser(user);
        log.debug("Revoked {} refresh tokens for user with id {}", deletedCount, userId);
    }

    @Service
    public static class TokenBlacklistService {
        private final Set<String> blacklist = ConcurrentHashMap.newKeySet();

        public void blacklistToken(String token) {
            blacklist.add(token);
        }

        public boolean isTokenBlacklisted(String token) {
            return blacklist.contains(token);
        }
    }
}
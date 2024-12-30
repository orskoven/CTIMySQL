package orsk.compli.service.auth;

import org.springframework.stereotype.Service;
import orsk.compli.entities.MfaToken;
import orsk.compli.repository.auth.MfaTokenRepository;
import orsk.compli.entities.User;


import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service("MfaTokenService")
public class MfaTokenService {

    private final MfaTokenRepository mfaTokenRepository;

    public MfaTokenService(MfaTokenRepository mfaTokenRepository) {
        this.mfaTokenRepository = mfaTokenRepository;
    }

    public MfaToken generateMfaToken(User user) {
        // Reuse existing valid token if present
        Optional<MfaToken> existingToken = mfaTokenRepository.findByUserUsername(user.getUsername())
                .filter(token -> token.getExpiryDate().isAfter(LocalDateTime.now()) && !token.getUsed());

        if (existingToken.isPresent()) {
            return existingToken.get();
        }

        MfaToken mfaToken = new MfaToken();
        mfaToken.setMfaCode(generateRandomMfaCode());
        mfaToken.setExpiryDate(LocalDateTime.now().plusMinutes(5)); // Configurable expiration
        mfaToken.setUser(user);
        return mfaTokenRepository.save(mfaToken);
    }

    public boolean verifyMfaCode(String code, User user) {
        return mfaTokenRepository.findByMfaCodeAndUser(code, user)
                .filter(token -> token.getExpiryDate().isAfter(LocalDateTime.now()) && !token.getUsed())
                .map(token -> {
                    token.setUsed(true); // Mark token as used
                    mfaTokenRepository.save(token);
                    return true;
                }).orElse(false);
    }

    private String generateRandomMfaCode() {
        return String.valueOf(100000 + new Random().nextInt(900000)); // 6-digit random code
    }
}
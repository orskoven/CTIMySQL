package auth.security;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;

import javax.crypto.SecretKey;
import java.util.Date;
import java.util.Map;

public class JwtTestHelper {

    private static final SecretKey SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);

    public static String generateValidJwt(String subject, Map<String, Object> claims, long expirationTimeMs) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + expirationTimeMs);

        return Jwts.builder()
                .setSubject(subject)
                .addClaims(claims)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SECRET_KEY)
                .compact();
    }

    public static String generateValidJwt(String subject) {
        return generateValidJwt(subject, Map.of(), 3600000);
    }

    public static String generateExpiredJwt(String subject) {
        return generateValidJwt(subject, Map.of(), -3600000);
    }

    public static SecretKey getSecretKey() {
        return SECRET_KEY;
    }
}
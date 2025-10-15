package com.example.docflow.security;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.interfaces.DecodedJWT;

import java.util.Date;

public class JwtUtil {
    // Đặt bằng JVM system property/ENV khi chạy prod
    private static final String SECRET = System.getProperty("jwt.secret", "dev-secret-change-me");
    private static final String ISS    = "docflow-zk";
    private static final long   EXP_MS = Long.getLong("jwt.expire.ms", 7L*24*60*60*1000L); // 7 ngày

    private static Algorithm alg() { return Algorithm.HMAC256(SECRET); }

    public static String generateToken(Long userId, String username, String role) {
        long now = System.currentTimeMillis();
        return JWT.create()
                .withIssuer(ISS)
                .withIssuedAt(new Date(now))
                .withExpiresAt(new Date(now + EXP_MS))
                .withClaim("uid", userId)
                .withClaim("uname", username)
                .withClaim("role", role)
                .sign(alg());
    }

    public static DecodedJWT verify(String token) {
        return JWT.require(alg()).withIssuer(ISS).build().verify(token);
    }

    public static Long   uid(DecodedJWT jwt)  { return jwt.getClaim("uid").asLong(); }
    public static String uname(DecodedJWT jwt){ return jwt.getClaim("uname").asString(); }
    public static String role(DecodedJWT jwt) { return jwt.getClaim("role").asString(); }
}

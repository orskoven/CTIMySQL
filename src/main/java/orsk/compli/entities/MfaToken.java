package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "mfa_tokens", indexes = @Index(columnList = "mfaCode", unique = true))
public class MfaToken {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String mfaCode;

    @Column(nullable = false)
    private LocalDateTime expiryDate;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(nullable = false)
    private Boolean used = false; // Default to false

    // Constructors, if needed
    public MfaToken() {}

    public MfaToken(String mfaCode, LocalDateTime expiryDate, User user) {
        this.mfaCode = mfaCode;
        this.expiryDate = expiryDate;
        this.user = user;
        this.used = false;
    }
}
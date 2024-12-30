package orsk.compli.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "failed_logins", schema = "auth")
public class FailedLogin {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Long id;

    @Size(max = 255)
    @NotNull
    @Column(name = "username", nullable = false)
    private String username;

    @Size(max = 255)
    @NotNull
    @Column(name = "ip_address", nullable = false)
    private String ipAddress;

    @NotNull
    @Column(name = "attempt_time", nullable = false)
    private Instant attemptTime;

    @Size(max = 500)
    @Column(name = "reason", length = 500)
    private String reason;

}
package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "audit_logs")
public class AuditLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String action; // e.g., LOGIN_SUCCESS, LOGIN_FAILURE

    @Column(nullable = false)
    private String ipAddress;

    @Column(nullable = false)
    private Instant timestamp;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Column(length = 500)
    private String details;
}
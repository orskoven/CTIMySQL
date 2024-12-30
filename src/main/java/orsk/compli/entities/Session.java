package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "sessions", indexes = @Index(columnList = "sessionId", unique = true))
public class Session {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String sessionId;

    @Column(nullable = false)
    private Instant createdAt;

    @Column(nullable = false)
    private Instant lastAccessedAt;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}
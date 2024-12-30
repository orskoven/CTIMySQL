package orsk.compli.entities;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.Instant;

@Getter
@Setter
@Entity
@Table(name = "devices")
public class Device {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String deviceId;

    @Column(nullable = false)
    private String deviceType; // e.g., MOBILE, DESKTOP

    @Column(nullable = false)
    private Instant registeredAt;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
}
package orsk.compli.entities.jpa;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "user_roles")

public class JpaUserRole {
    @Id
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Column(name = "role")
    private String role;

    @Column(name = "role_id", nullable = false)
    private Long roleId;

    @Id
    @Column(name = "id", nullable = false)
    private Long id;


}
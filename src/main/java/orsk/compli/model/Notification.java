package orsk.compli.model;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter

public class Notification {

    private String message;

    public Notification() {
    }

    public Notification(String message) {
        this.message = message;
    }

}

package orsk.compli.exception.auth;

public class MfaRequiredException extends RuntimeException {
    public MfaRequiredException(String message) {
        super(message);
    }
}
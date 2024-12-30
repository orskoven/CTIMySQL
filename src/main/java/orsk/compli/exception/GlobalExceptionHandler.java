package orsk.compli.exception;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.orm.jpa.JpaSystemException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import orsk.compli.exception.auth.BadRequestException;
import orsk.compli.exception.auth.ErrorResponse;
import orsk.compli.exception.auth.ResourceNotFoundException;
import orsk.compli.exception.auth.UserAlreadyExistsException;

import java.time.Instant;
import java.util.HashMap;
import java.util.Map;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(orsk.compli.exception.auth.ResourceNotFoundException.class)
    public ResponseEntity<orsk.compli.exception.auth.ErrorResponse> handleResourceNotFound(ResourceNotFoundException ex) {
        orsk.compli.exception.auth.ErrorResponse error = new orsk.compli.exception.auth.ErrorResponse(
                Instant.now(),
                HttpStatus.NOT_FOUND.value(),
                "Not Found",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler(orsk.compli.exception.auth.BadRequestException.class)
    public ResponseEntity<orsk.compli.exception.auth.ErrorResponse> handleBadRequest(BadRequestException ex) {
        orsk.compli.exception.auth.ErrorResponse error = new orsk.compli.exception.auth.ErrorResponse(
                Instant.now(),
                HttpStatus.BAD_REQUEST.value(),
                "Bad Request",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<orsk.compli.exception.auth.ErrorResponse> handleGlobalException(Exception ex) {
        orsk.compli.exception.auth.ErrorResponse error = new ErrorResponse(
                Instant.now(),
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Internal Server Error",
                ex.getMessage()
        );
        return new ResponseEntity<>(error, HttpStatus.INTERNAL_SERVER_ERROR);
    }
    @ExceptionHandler({DataIntegrityViolationException.class})
    public ResponseEntity<?> handleDatabaseExceptions(DataIntegrityViolationException ex) {
        return ResponseEntity.badRequest().body("A database error occurred: " + ex.getMostSpecificCause().getMessage());
    }

    @ExceptionHandler({JpaSystemException.class})
    public ResponseEntity<?> handleJpaExceptions(JpaSystemException ex) {
        return ResponseEntity.internalServerError().body("A system error occurred: " + ex.getMostSpecificCause().getMessage());
    }

    @ExceptionHandler(UserAlreadyExistsException.class)
    public ResponseEntity<Map<String, String>> handleUserAlreadyExistsException(UserAlreadyExistsException ex) {
        Map<String, String> response = new HashMap<>();
        response.put("message", ex.getMessage());
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<Map<String, String>> handleValidationException(MethodArgumentNotValidException ex) {
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error -> errors.put(error.getField(), error.getDefaultMessage()));
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errors);
    }

}
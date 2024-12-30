# Use a secure and minimal base image with JDK
FROM eclipse-temurin:17-jdk-alpine

# Set a non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set the working directory
WORKDIR /app

# Copy JAR file to container
COPY target/merged-project-0.0.1-SNAPSHOT.jar /app/app.jar

# Adjust permissions for non-root user
RUN chown -R appuser:appgroup /app && chmod 500 /app/app.jar

# Switch to non-root user
USER appuser

# Expose the application port
EXPOSE 8080

# Set environment variables for security and optimization
ENV JAVA_OPTS="-Djava.security.egd=file:/dev/./urandom -Xms512m -Xmx1024m"

# Run the application
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar /app/app.jar"]
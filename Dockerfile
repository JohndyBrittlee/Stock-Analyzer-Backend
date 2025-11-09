# ============================
# 1️⃣ Build Stage
# ============================
FROM maven:3.9.9-eclipse-temurin-21 AS builder

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies (for caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Package the application
RUN mvn clean package -DskipTests

# ============================
# 2️⃣ Runtime Stage
# ============================
FROM eclipse-temurin:21-jdk-jammy

# Set working directory
WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/target/*.jar app.jar

# Expose the port (Render automatically maps this)
EXPOSE 8080

# Set environment variable for dynamic port binding (Render uses $PORT)
ENV PORT=8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]

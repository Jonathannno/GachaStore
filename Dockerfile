# Step 1: Use Java 11
FROM amazoncorretto:11-al2-jdk

# Step 2: Create the app folder
WORKDIR /app

# Step 3: Copy your project files
COPY . .

# Step 4: Download the 'Webapp Runner' (This acts as your Tomcat)
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

# Step 5: Tell Railway which port to use
EXPOSE 8080

# Step 6: Run the app using the 'web' folder
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "web/"]

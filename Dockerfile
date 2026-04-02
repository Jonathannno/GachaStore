# Step 1: Use Java 11 with Ant installed
FROM amazoncorretto:11-al2-jdk

# Step 2: Install Ant and find the correct path
RUN yum install -y ant

WORKDIR /app
COPY . .

# Step 3: Create the standard web folder structure
RUN mkdir -p web/WEB-INF/classes

# Step 4: Compile all your Java files from 'src' into the 'classes' folder
# (This replaces the 'ant compile' that was failing earlier)
RUN javac -d web/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" src/*.java

# Step 5: Download Webapp Runner
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080

# Step 6: Start the server pointing to the 'web' folder
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "web/"]

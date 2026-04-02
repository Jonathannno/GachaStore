# BUILD_VERSION_FINAL_100
FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app
COPY . .

# 1. Create the deployment folder
RUN rm -rf FINAL_APP && mkdir -p FINAL_APP/WEB-INF/classes

# 2. Copy web assets
RUN cp -r web/* FINAL_APP/

# 3. COMPILE THE JAVA CODE (The missing piece!)
RUN find src -name "*.java" > sources.txt && \
    javac -d FINAL_APP/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" @sources.txt

# 4. Get the runner
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "FINAL_APP/"]

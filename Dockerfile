FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app
COPY . .

# 1. Manually create the package folder structure
RUN mkdir -p web/WEB-INF/classes/controller

# 2. Compile specifically into that folder
# We use -d web/WEB-INF/classes so javac handles the 'controller' subfolder automatically
RUN find src -name "*.java" > sources.txt && \
    javac -d web/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" @sources.txt

# 3. Verify the file exists (This will show in your Railway logs)
RUN ls -R web/WEB-INF/classes

# 4. Get the runner
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "web/"]

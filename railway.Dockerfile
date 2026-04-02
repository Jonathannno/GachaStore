# FORCE_REBUILD_TIMESTAMP: 2026-04-02-23-00
FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app
COPY . .

# 1. This folder MUST be created for the 404 to go away
RUN mkdir -p ROOT/WEB-INF/classes

# 2. This copies your JSP/HTML files
RUN cp -r web/* ROOT/

# 3. THIS STEP MUST APPEAR IN YOUR LOGS
RUN find src -name "*.java" > sources.txt && \
    javac -d ROOT/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" @sources.txt

# 4. Final verification - this will print to your logs
RUN echo "CHECKING FOR CLASS FILE:" && ls -R ROOT/WEB-INF/classes

RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "ROOT/"]

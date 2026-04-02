FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app

# This line 'breaks' the cache so Railway is forced to rebuild
ARG CACHE_BUST=2026-04-02-16-00
COPY . .

# 1. Create the ROOT structure
RUN rm -rf ROOT && mkdir -p ROOT/WEB-INF/classes

# 2. Copy UI files (Using a wild card to ensure it sees the folder)
RUN cp -r web/* ROOT/

# 3. COMPILE - This is the most important part
RUN find src -name "*.java" > sources.txt && \
    javac -v -d ROOT/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" @sources.txt

# 4. PROOF - This will print the files in your build logs
RUN echo "--- VERIFYING COMPILED FILES ---" && ls -R ROOT/WEB-INF/classes

RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "ROOT/"]

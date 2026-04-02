# BUILD_VERSION_LIBS_FIX_01
FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app
COPY . .

# 1. Prepare the folders
RUN rm -rf ROOT && mkdir -p ROOT/WEB-INF/classes

# 2. Get the runner BEFORE compiling so we can use it as a library
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

# 3. COMPILE - We added 'webapp-runner.jar' to the classpath (-cp)
# This fixes the "package javax.servlet does not exist" errors!
RUN find src -name "*.java" > sources.txt && \
    javac -d ROOT/WEB-INF/classes -cp "webapp-runner.jar:web/WEB-INF/lib/*:lib/*" @sources.txt

# 4. Copy the rest of the website files
RUN cp -r web/* ROOT/

EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "ROOT/"]

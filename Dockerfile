FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app
COPY . .

# 1. Clean out the old classes folder and start fresh
RUN rm -rf web/WEB-INF/classes && mkdir -p web/WEB-INF/classes

# 2. Compile everything. The '-d' flag automatically creates 
# the 'controller' folder inside 'classes' for you!
RUN find src -name "*.java" > sources.txt && \
    javac -d web/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" @sources.txt

# 3. Get the web engine
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080

# 4. Start the app
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "web/"]

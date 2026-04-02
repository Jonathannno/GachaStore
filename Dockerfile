FROM amazoncorretto:11-al2-jdk
RUN yum install -y findutils

WORKDIR /app
COPY . .

# 1. Create a folder named ROOT (Tomcat's favorite name)
RUN mkdir -p ROOT/WEB-INF/classes

# 2. Copy your UI files into ROOT
RUN cp -r web/* ROOT/

# 3. Compile your Java into the ROOT classes folder
RUN find src -name "*.java" > sources.txt && \
    javac -d ROOT/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*" @sources.txt

# 4. List the files to be 100% sure they exist (Check logs for this!)
RUN ls -R ROOT/WEB-INF/classes

# 5. Download the runner
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080

# 6. Run the ROOT folder
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "ROOT/"]

FROM amazoncorretto:11-al2-jdk

# Install tools
RUN yum install -y findutils

WORKDIR /app
COPY . .

# Create the folder where Tomcat looks for compiled Java
RUN mkdir -p web/WEB-INF/classes

# This compiles EVERYTHING in your src folder, including packages
RUN find src -name "*.java" > sources.txt && \
    javac -d web/WEB-INF/classes -cp "web/WEB-INF/lib/*:lib/*:web/WEB-INF/lib/*" @sources.txt

# Get the Web Server engine
RUN curl -L https://repo1.maven.org/maven2/com/heroku/webapp-runner/9.0.52.1/webapp-runner-9.0.52.1.jar -o webapp-runner.jar

EXPOSE 8080

# Start the app using the 'web' folder as the root
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "web/"]

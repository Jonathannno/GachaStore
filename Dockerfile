# Step 1: Use a reliable Java 11 environment (Amazon Corretto)
FROM amazoncorretto:11-al2-jdk

# Step 2: Set the working directory
WORKDIR /app

# Step 3: Copy your project files
COPY . .

# Step 4: Install Ant (this version uses 'yum' instead of 'apt-get')
RUN yum install -y ant

# Step 5: Compile the Java files
RUN ant compile

# Step 6: Start the app
# IMPORTANT: If you don't have a "Main.java", we will fix this next.
CMD ["java", "-cp", "build/classes:lib/*", "Main"]

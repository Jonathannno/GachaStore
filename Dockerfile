# Step 1: Use a Java 11 environment
FROM openjdk:11-jdk-slim

# Step 2: Set the folder where our app lives
WORKDIR /app

# Step 3: Copy all your files (src, web, build.xml, etc.) into the container
COPY . .

# Step 4: Install Ant to build the project
RUN apt-get update && apt-get install -y ant

# Step 5: Run the Ant build (the same command you used in NetBeans)
RUN ant compile

# Step 6: Start the app (adjust 'Main' if your class name is different)
CMD ["java", "-cp", "build/classes:lib/*", "Main"]

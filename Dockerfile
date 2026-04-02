# Step 1: Use Node.js to run a simple web server
FROM node:18-slim

# Step 2: Create app directory
WORKDIR /app

# Step 3: Copy only the 'web' folder (where your UI is)
COPY web/ ./public

# Step 4: Install a tiny web server
RUN npm install -g servor

# Step 5: Expose the port Railway uses
EXPOSE 8080

# Step 6: Start the server and point it to your login/index page
CMD ["servor", "public", "index.jsp", "8080"]

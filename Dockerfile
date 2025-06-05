# Start from a compatible base image
FROM ubuntu:22.04

# Install necessary dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    libgcc-s1 \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy necessary files into the /app directory
COPY config.yaml /app/config.yaml
COPY start.sh /app/start.sh
COPY verifier /app/verifier
COPY libdarwin_verifier.so /app/libdarwin_verifier.so
COPY librsp.so /app/librsp.so

# Ensure the verifier and start.sh are executable
RUN chmod +x /app/start.sh /app/verifier

# Set environment variables for library paths and other parameters
ENV LD_LIBRARY_PATH=/app
ENV CHAIN_ID=534352

# Use start.sh as the entry point
ENTRYPOINT ["/app/start.sh"]


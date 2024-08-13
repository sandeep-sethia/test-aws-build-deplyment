# Use a base image with .NET installed
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

# Intermediate stage for copying the certificate
FROM base AS cert-stage

# Define build arguments
ARG CERTIFICATE_CONTENT
ARG PFX_PASSWORD

# Create a directory for the certificate
RUN mkdir -p /app/certificates

# Write the certificate content to a file
RUN echo "$CERTIFICATE_CONTENT" | base64 -d > /app/certificates/certificate.pfx

# Set the password as an environment variable
ENV PFX_PASSWORD=$PFX_PASSWORD

# Final stage
FROM base AS final
WORKDIR /app

# Copy from the cert-stage, ensuring the certificate is available
COPY --from=cert-stage /app/certificates/certificate.pfx /app/certificates/certificate.pfx

# Your application setup and entry point
COPY . .
ENTRYPOINT ["dotnet", "MyApp.dll"]

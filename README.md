# Docker Semaphore UI

## Semaphore UI with PostgreSQL Backend using Docker

This project sets up `semaphore-ui` with a PostgreSQL backend using Docker containers, making deployment and management efficient. This project is intended to be expanded upon to be an ideal boilerplate for setting up a secured Semaphore UI instance quickly and efficiently. Because automation is hard. The tools we use shouldn't be.

## Table of Contents

- [Description](#description)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [License](#license)

## Description

This repository aims to simplify deploying and managing Semaphore UI and PostgreSQL using Docker and Docker Compose. All configurations are managed via environment variables, streamlining setup and updates. The project includes a self-signed SSL setup for secure connections.

## Requirements

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Installation

1. **Clone the Repository:**

   ```sh
   git clone <repository-url>
   cd docker-semaphore-ui
   ```

2. **Set Up Environment Variables:**

   Copy the sample environment file to `.env` and adjust values according to your setup:

   ```sh
   cp .env.example .env
   ```

3. **Build and Start the Services:**

   Use the following command to build the Docker images and start the services:

   ```sh
   docker-compose up -d
   ```

   This command launches PostgreSQL, Semaphore UI, and Nginx containers in detached mode.

4. **Access the Semaphore UI:**

   You can now access the Semaphore UI at `https://localhost`.

## Configuration

Configure all necessary information in the `.env` file. Key variables include:

- **PostgreSQL Configuration:**

  - `POSTGRES_USER` The database user. Default is `admin`.
  - `POSTGRES_PASSWORD` The database password. Default is `changeMe`.
  - `POSTGRES_DB` The database name. Default is `semaphore`.

- **Semaphore Admin Credentials:**
  - `SEMAPHORE_ADMIN_NAME` The admin username. Default is `Admin`.
  - `SEMAPHORE_ADMIN_EMAIL` The admin email. Default is `admin@example.com`.
  - `SEMAPHORE_ADMIN_PASSWORD` The admin password. Default is `changeMe`.
  - `SEMAPHORE_ACCESS_KEY_ENCRYPTION` The encryption key for access keys. Generate using `openssl rand -base64 32`.

## Usage

- **Start Services:** Use `docker-compose up -d` to start.
- **Stop Services:** Use `docker-compose down` to stop.
- **View Logs:** You can view logs using `docker-compose logs <service_name>`.

## Troubleshooting

- **Database Connection Issues:** Verify your `.env` configurations for correct credentials.
- **Service Unavailability:** Ensure no other service is running on ports 3000 or 5432.

## Contributing

Contributions are encouraged! Please read the [Contributing Guide](CONTRIBUTING.md) for more details.

## Code of Conduct

This project adheres to a [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## About

This repository contains the full code for the article published in the [Devcolumn](https://www.devcolumn.com/), guiding you through the process of containerizing a Django application with PostgreSQL using Docker and docker-compose.

**Article Title:** Containerize Your First Django Application with PostgreSQL: A Comprehensive Docker Guide

**Article Overview:**
Explore the complete code and step-by-step guide on setting up a Django application, creating Dockerfiles, using docker-compose for service orchestration, running the services, and understanding container initialization with an entrypoint script.

### Getting Started

Before you begin, ensure you have the following installed on your machine:
- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/gettingstarted/)
- [Python](https://www.python.org/downloads/)

### Steps

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/your-username/dockerized-django-postgresql.git
    cd dockerized-django-postgresql
    ```

2. **Build and Run Docker Containers:**

    ```bash
    docker-compose up --build
    ```

    This command will build the Dockerfile and run the Django and PostgreSQL services defined in the docker-compose file.

3. **Access the Application:**

    Open your web browser and navigate to [http://localhost:8000](http://localhost:8000). You should see a "Happy Dockerizing!!" message, indicating that the Django application is running successfully.
   

### Understanding Container Initialization with Entrypoint

The initialization process of the container is handled by the entrypoint script (`entrypoint.sh`) included in the repository. This script is responsible for essential tasks such as waiting for the database server to be available, running database migrations, and starting the Django development server.

The `entrypoint.sh` script offers flexibility in managing the startup sequence of services within the container. Feel free to explore the script to understand its functionalities and adapt it according to your application's requirements.

Happy coding!

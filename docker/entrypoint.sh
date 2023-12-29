#!/bin/sh

set -e

HELP_TEXT="

Arguments:
    run_devcolumn: Default. Run the Devcolumn server
    run_migrations: Run database migrations
    help|-h: Display help text
"

# Function to display help text
display_help() {
    echo "Devcolumn Management Script"
    echo "${HELP_TEXT}"
}


# Function to wait for the database server to be available
wait_for_db() {
    echo "Checking the availability of the database server..."
    until ncat -z -w 1 "${PGHOST}" "${PGPORT}"; do
        sleep 1
    done
    echo "Database server is up and running"
}

# Function to run database migrations
run_migrations() {
    echo "----- RUNNING DATABASE MIGRATIONS -----"
    cd /app/devcolumn
    python manage.py migrate
    echo "Database migrations completed successfully"
}


# Function to run the Django development server
run_django_server() {
    echo "----- *** RUNNING DJANGO DEVELOPMENT SERVER *** -----"
    exec python manage.py runserver 0.0.0.0:8000
}

# Function to run the Devcolumn application
run_devcolumn() {
    wait_for_db

    if [ "${DJANGO_MODE}" = "DEV" ]; then
        # Create the database
        python manage.py migrate
        echo "Running Devcolumn in development mode..."
        run_django_server
    elif [ "${DJANGO_MODE}" = "PROD" ]; then
        echo "Running Devcolumn in production mode..."
        collect_static
    fi
}

# If no arguments are supplied, assume the server needs to be run
if [ "$#" -eq 0 ]; then
    run_devcolumn
fi


# Process arguments
while [ "$#" -gt 0 ]; do
    key="$1"

    case ${key} in
        run_devcolumn)
            wait_for_db
            run_devcolumn
            ;;
        run_migrations)
            wait_for_db
            run_migrations
            ;;
        help|-h)
            display_help
            ;;
        *)
            echo "Invalid command: ${key}"
            display_help
            exit 1
            ;;
    esac
    shift # next argument or value
done
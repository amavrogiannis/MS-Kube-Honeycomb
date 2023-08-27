# Use a base image with Python and SQLite
FROM python:3.8

# Set the working directory inside the container
WORKDIR /db

# Copy the SQLite database file into the container
COPY database.db /db/

# Start a shell session when the container starts
CMD ["bash"]
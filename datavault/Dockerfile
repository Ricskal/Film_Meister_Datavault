FROM alpine:3.14
# Install SQLite
RUN apk --no-cache add sqlite
# Create a directory to store the database
WORKDIR /db
# Copy your SQLite database file into the container
COPY filmmeister.db filmavonden.xlsx data/
# COPY  data/filmavonden.xlsx
# Command to create a sqlite3 database
# CMD ["sqlite3", "FilmMeister.db", ]
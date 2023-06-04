# Clash of Nations
A basic implementation of an RPG game database using postgreSQL and python

## Steps to run the application
- install docker and docker-compose
- populate a `.env` file with POSTGRES\_USER, POSTGRES\_PASSWORD and POSTGRES_URL (the last one should be 'db' when using docker-compose or 'localhost' during development)
- `docker-compose up -d` to start the application
- access [http://localhost:8080](http://localhost:8080) to see the application working!
- when done, use `docker-compose down` to stop the application and delete everything in the database. If it is necessary to retain data between shutdowns, see [this file](docker-compose.yml) to setup persistency.

## Additional steps for development
To setup the development of the server locally, follow these steps:
- install python3-dev and libpq-dev
- `pip install -r requirements.txt`
- `docker compose up db -d` to start the database
- `./src/main.py` to start the server in debug mode. Hot reloading is enabled this way, so if you change files and save them, the change will apply immedialty.
- when changes are to be tested in a production environment, use `docker-compose build` to force rebuilding the server docker image before a `docker-compose up` command.

Remember to use [PEP8](https://peps.python.org/pep-0008/) for formatting python code. This can be made easiear by using autopep8 and a configured ctrl+f in VSCode.

To develop the database schema and add data during runtime, use `docker exec -it postgres psql -U $POSTGRES_USER`, where $POSTGRES\_USER is the user as defined in the `.env` file, to start a SQL command line prompt.

## Made Fully by
- [Lucas Eduardo Gulka Pulcinelli](https://github.com/lucasgpulcinelli/)
- 

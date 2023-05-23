# Clash of Nations
A basic implementation of an RPG game database using postgreSQL and python

## Steps to run the application
- install python3 and libpq-dev
- `pip install -r requirements.txt`
- install docker and docker-compose
- populate a `.env` file with POSTGRES\_USER and POSTGRES\_PASSWORD
- `docker-compose up -d` to start the database
- `./src/main.py` to start the application
- when done, use `docker-compose down` to stop the database. The files will persist in the `data/` directory, and will be restored in a next `docker-compose up` if not deleted.

## Made Fully by
- [Lucas Eduardo Gulka Pulcinelli](https://github.com/lucasgpulcinelli/)
- 

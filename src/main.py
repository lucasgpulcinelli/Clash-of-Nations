#!/usr/bin/env python3
import psycopg2
import flask
import sys
import waitress
import os

# connect to database
database = psycopg2.connect(f"host='{os.environ['POSTGRES_URL']}'              \
                              user='{os.environ['POSTGRES_USER']}'             \
                              password='{os.environ['POSTGRES_PASSWORD']}'")

# create the main flask application
app = flask.Flask('Clash of Nations', template_folder="res")


@app.route('/')
def index():
    cursor = database.cursor()
    cursor.execute(
        "SELECT (nome, data_de_criacao, aconselhador) FROM usuario;")
    results = cursor.fetchall() # transform this in a proper class
    cursor.close()

    return flask.render_template("index.html", results=results)


production = False
if len(sys.argv) >= 2 and sys.argv[1] == 'production':
    production = True

if production:
    waitress.serve(app)
else:
    app.run('0.0.0.0', 8080, debug=True)

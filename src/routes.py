import flask
import os
import sys

import database

# create the main flask application
app = flask.Flask('Clash of Nations', template_folder="res")

try:
    db = database.ClashOfNationsDB(os.environ['POSTGRES_URL'],
                                   os.environ['POSTGRES_USER'],
                                   os.environ['POSTGRES_PASSWORD'])
except Exception as e:
    print(f'could not connect to database: {e}', file=sys.stderr)
    exit(-1)


@app.route('/')
def root():
    return flask.redirect('/index.html')


@app.route('/index.html')
def index():
    return flask.render_template('index.html')


@app.route('/admin.html')
def admin():
    # use cookies to determine if the user is an admin (can access the page)
    query = "SELECT nome, email, data_de_criacao FROM usuario;"
    users = db.query(query, db.all)

    return flask.render_template('admin.html', users=users)

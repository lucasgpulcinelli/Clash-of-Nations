import flask
import os
import sys
import uuid
import psycopg2.errors

import database

# create the main flask application
app = flask.Flask('Clash of Nations', template_folder="res")

try:
    db = database.ClashOfNationsDB(os.environ['POSTGRES_URL'],
                                   os.environ['POSTGRES_USER'],
                                   os.environ['POSTGRES_PASSWORD'])
except Exception as e:
    print(f'could not connect to database: {type(e).__name__}: {e}',
          file=sys.stderr)
    exit(-1)

session_dict = {}


@app.route('/')
def root():
    return flask.redirect('/index.html')


@app.route('/index.html')
def index():
    return flask.render_template('index.html')


@app.route('/login.html')
def loginPage():
    if flask.request.cookies.get('sid'):
        return flask.redirect('/userhub.html')
    return flask.render_template('login.html')


@app.route('/api/login', methods=['POST'])
def login():
    username = flask.request.form.get('username')
    password = flask.request.form.get('password')
    if username is None or password is None:
        return flask.Response('<h1>Bad Request</h1>', 400)

    response = db.query(
        "SELECT senha FROM usuario WHERE nome=%s;", db.one, [username])

    if response is None:
        return flask.Response('<h1>User does not exist</h1>', 401)
    if response[0] != password:
        return flask.Response('<h1>Invalid Password</h1>', 401)

    # this is not perfect, there is a user_number*2**(-128) chance to generate a
    # duplicate... but it's close enough for our uses, considering that it's
    # just a session id that in practice would be temporary
    sid = uuid.uuid4().hex
    session_dict[sid] = username

    resp = flask.Response(status=201)
    resp.set_cookie('sid', sid)
    return resp


@app.route('/register.html')
def registerPage():
    if flask.request.cookies.get('sid'):
        return flask.redirect('/userhub.html')
    return flask.render_template('register.html')


@app.route('/api/register', methods=['POST'])
def register():
    username = flask.request.form.get('username')
    email = flask.request.form.get('email')
    password = flask.request.form.get('password')
    if username is None or email is None or password is None:
        return flask.Response('<h1>Bad Request</h1>', 400)

    statement = "INSERT INTO usuario (nome, email, senha) VALUES (%s, %s, %s)"

    try:
        db.insert(statement, [username, email, password])
    except Exception as e:
        if type(e) == psycopg2.errors.UniqueViolation:
            text = 'User or email already exists'
        elif type(e) == psycopg2.errors.StringDataRightTruncation:
            text = 'Text value too large'
        else:
            # catch-all if the error is uncommon
            text = f'{type(e).__name__}: {e}'

        return flask.Response(f'<h1>{text}</h1>', 409)

    return flask.Response(status=201)


@app.route('/userhub.html')
def user_hub():
    sid = flask.request.cookies.get('sid')
    if (not sid) or session_dict.get(sid) is None:
        return flask.redirect('/login.html')

    return flask.render_template('userhub.html')


@app.route('/admin.html')
def admin():
    sid = flask.request.cookies.get('sid')
    if (not sid) or session_dict.get(sid) != 'admin':  # should query db for admin access
        return flask.Response('<h1>Forbidden</h1>', 403)

    query = "SELECT nome, email, data_de_criacao FROM usuario;"
    users = db.query(query, db.all)

    return flask.render_template('admin.html', users=users)

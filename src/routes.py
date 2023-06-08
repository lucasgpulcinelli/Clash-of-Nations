import flask

# get the database helper functions, non-html routes and session dictionary
import db
import apiroutes
from session import sessions

# create the main flask application
app = flask.Flask('Clash of Nations', template_folder="res")

# register all non-html routes
app.register_blueprint(apiroutes.api_bp)


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


@app.route('/register.html')
def registerPage():
    if flask.request.cookies.get('sid'):
        return flask.redirect('/userhub.html')
    return flask.render_template('register.html')


@app.route('/userhub.html')
def user_hub():
    sid = flask.request.cookies.get('sid')
    if (not sid) or sessions.get(sid) is None:
        return flask.redirect('/login.html')

    return flask.render_template('userhub.html')


@app.route('/admin.html')
def admin():
    sid = flask.request.cookies.get('sid')
    # TODO: we should query db for admin access
    if (not sid) or sessions.get(sid) != 'admin':
        return flask.Response('<h1>Forbidden</h1>', 403)

    query = "SELECT nome, email, data_de_criacao FROM usuario;"
    try:
        users = db.query(query, quantityLambda=db.every)
    except db.Error as e:
        return flask.render_template('server_error.html', errtype=type(e).__name__, err=e, status=500)

    return flask.render_template('admin.html', users=users)

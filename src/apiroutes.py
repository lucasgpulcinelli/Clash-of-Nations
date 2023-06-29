import flask
import uuid
import psycopg2.errors as dberr

# get the database helper functions and session dictionary
import db
from session import sessions

# generate a blueprint: a variable we can add routes and can be imported by the
# main app
api_bp = flask.Blueprint('api_bp', __name__, url_prefix='/api')


@api_bp.route('/login', methods=['POST'])
def login():
    '''
    login authenticates login requests, creating session cookies and adding
    sessions to the dictionary. The form must contain a username and password.
    '''

    # get form data
    username = flask.request.form.get('username')
    password = flask.request.form.get('password')
    if username is None or password is None:
        return flask.Response('Bad Request', 400)

    # get the password for that user, if it exists
    try:
        loginq = '''
          SELECT nome
          FROM usuario
          WHERE nome=%s AND senha = crypt(%s, senha)
        '''
        response = db.query(loginq, [username, password], db.one)
    except db.Error as e:
        return flask.Response(
            f'Um erro inesperado ocorreu: {type(e).__name__}: {e}'), 500

    if response is None:
        return flask.Response(response='Usuário não existe ou senha inválida',
                              status=401)

    # generate a session id for the newly logged in user

    # this is not perfect, there is a user_number*2**(-128) chance to generate a
    # duplicate... but it's close enough for our uses, considering that it's
    # just a session id that in practice would be temporary
    sid = uuid.uuid4().hex
    sessions[sid] = username

    resp = flask.Response(status=201)
    resp.set_cookie('sid', sid)
    return resp


@api_bp.route('/register', methods=['POST'])
def register():
    '''
    register creates new users in the database.
    The form must contain a username, email and password.
    '''

    # get form data
    username = flask.request.form.get('username')
    email = flask.request.form.get('email')
    password = flask.request.form.get('password')
    if username is None or email is None or password is None:
        return flask.Response('Bad Request', 400)

    # try to add that user, if any error occurs, send a client error response
    statement = '''
      INSERT INTO usuario (nome, email, senha)
      VALUES (%s, %s, crypt(%s, gen_salt('bf', 8)))
    '''
    try:
        if len(password) > 50:
            raise dberr.StringDataRightTruncation
        db.query(statement, [username, email, password])
    except db.Error as e:
        if type(e) == dberr.UniqueViolation:
            text = 'Usuário ou email já estão cadastrados'
        elif type(e) == dberr.StringDataRightTruncation:
            text = 'Campo de texto muito grande, são aceitos até 50 caracteres'
        else:
            # catch-all if the error is uncommon
            text = f'Um erro inesperado ocorreu: {type(e).__name__}: {e}'

        return flask.Response(f'{text}', 409)

    # the user is registred! The main html page should redirect it to log in
    return flask.Response(status=201)


@api_bp.route('/create', methods=['POST'])
def create():
    '''
    create creates new characters in the database.
    The form must contain at least name, power, class and nation.
    '''

    sid = flask.request.cookies.get('sid')
    if not sid:
        return flask.Response("Unauthorized", 401)

    User = sessions[sid]

    # get form data
    Name = flask.request.form.get('name')
    Power = flask.request.form.get('power')
    Class = flask.request.form.get('class')
    Nation = flask.request.form.get('nation')
    Nation_clan = flask.request.form.get('nation_clan')
    Specialization = flask.request.form.get('specialization')
    if User is None or Name is None or Power is None or Class is None or Nation is None:
        return flask.Response('Bad Request', 400)
    if Nation_clan is None:
        Nation_clan = [None, None]
    else:
        Nation_clan = Nation_clan.split(',')
    if Specialization is None:
        Specialization = None

    # try to add that user, if any error occurs, send a client error response
    statement = '''
      INSERT INTO Personagem (nome, nacao, usuario, pontos_de_poder, classe, nacao_do_clan, nome_do_clan, especializacao)
      VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    '''
    try:
        db.query(statement, [Name, Nation, User, Power, Class,
                 Nation_clan[0], Nation_clan[1], Specialization])
    except db.Error as e:
        if type(e) == dberr.UniqueViolation:
            text = 'Personagem já está cadastrado'
        elif type(e) == dberr.StringDataRightTruncation:
            text = 'Campo de texto muito grande, são aceitos até 50 caracteres'
        else:
            # catch-all if the error is uncommon
            text = f'Um erro inesperado ocorreu: {type(e).__name__}: {e}'

        return flask.Response(f'{text}', 409)

    # the user is registred! The main html page should redirect it to log in
    return flask.Response(status=201)


@api_bp.route('logout')
def logout():
    res = flask.redirect('/index.html')

    if flask.request.cookies.get('sid') is not None:
        sessions[flask.request.cookies['sid']] = None
        res.delete_cookie('sid')

    return res

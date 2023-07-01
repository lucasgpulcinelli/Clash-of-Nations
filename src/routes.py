import flask

# get the database helper functions, non-html routes and session dictionary
import db
import apiroutes
from session import sessions

# create the main flask application
app = flask.Flask('Clash of Nations', '')

# register all non-html routes
app.register_blueprint(apiroutes.api_bp)


@app.route('/')
def root():
    return flask.redirect('/index.html')


@app.route('/login.html')
def loginPage():
    if flask.request.cookies.get('sid'):
        # if the user is already logged in, just redirect it
        return flask.redirect('/userhub.html')
    return app.send_static_file('login.html')


@app.route('/register.html')
def registerPage():
    if flask.request.cookies.get('sid'):
        # if the user is already logged in, just redirect it
        return flask.redirect('/userhub.html')
    return flask.render_template('register.html')


@app.route('/userhub.html')
def user_hub():
    sid = flask.request.cookies.get('sid')
    if not sid:
        # if the user is not logged in, we need to authenticate first
        return flask.redirect('/login.html')
    if sessions.get(sid) is None:
        # if the user is logged in with an invalid cookie, delete it and redirect
        resp = flask.redirect('/login.html')
        resp.delete_cookie('sid')
        return resp

    # get the username from the cookie
    user = sessions[sid]

    query = '''
      SELECT ID, nome, nacao, classe
      FROM Personagem
      WHERE usuario = %s
      ORDER BY nome
    '''

    try:
        # get all it's characters
        characters = db.query(query, [user], db.every)
    except db.Error as e:
        return flask.render_template('server_error.html',
                                     errtype=type(e).__name__, err=e), 500

    # render the page with the database result if everything went right
    return flask.render_template('userhub.html', user=user,
                                 characters=characters)


@app.route('/charcreate.html')
def char_create():
    sid = flask.request.cookies.get('sid')
    if (not sid) or sessions.get(sid) is None:
        # if the user is not logged in, we need to authenticate first
        return flask.redirect('/login.html')

    # get the username from the cookie
    user = sessions[sid]

    queryNation = '''
      SELECT nome
      FROM nacao
      ORDER BY nome ASC
    '''

    try:
        # get all nations
        nations = db.query(queryNation, [], db.every)
    except db.Error as e:
        return flask.render_template('server_error.html',
                                     errtype=type(e).__name__, err=e), 500

    queryNationCla = '''
      SELECT nacao,nome
      FROM cla
      ORDER BY nacao ASC
    '''

    try:
        # get all clans
        nationsAndClans = db.query(queryNationCla, [], db.every)
    except db.Error as e:
        return flask.render_template('server_error.html',
                                     errtype=type(e).__name__, err=e), 500

    # render the creation page with the correct information if no errors happend
    return flask.render_template('charcreate.html', user=user,
                                 nationsAndClans=nationsAndClans, nations=nations)


@app.route('/charhub.html')
def char_hub():
    sid = flask.request.cookies.get('sid')
    if (not sid) or sessions.get(sid) is None:
        # if the user is not logged in, redirect it
        return flask.redirect('/login.html')

    # get the username from the cookie
    user = sessions[sid]

    # the character that needs to be displayed has it's id encoded as a URL argument
    character = flask.request.args.get('char')
    if character is None:
        # if no character was provided, go back to the user page to choose one
        return flask.redirect('/userhub.html')

    basicq = '''
      SELECT nome, nacao, pontos_de_poder, vida_maxima, dinheiro, classe,
        historia, experiencia, nome_do_clan, especializacao
      FROM Personagem
      WHERE usuario = %s AND ID = %s
    '''
    try:
        # get the general data for that character
        basic_data = db.query(basicq, [user, character], db.one)
    except db.Error as e:
        return flask.render_template('server_error.html',
                                     errtype=type(e).__name__, err=e), 500

    if basic_data is None:  # either the character does not exist, or the user is not it's owner
        return flask.redirect('/userhub.html')

    itemsq = '''
      SELECT ppi.item, ppi.quantidade, ppi.equipado, eq.nivel_permitido,
        eq.pontos_poder
      FROM Personagem_Possui_Itens ppi
      LEFT JOIN equipamento eq ON ppi.item = eq.item
      WHERE ppi.personagem = %s
      ORDER BY ppi.equipado DESC
    '''
    try:
        # get all items for that character, and, if they are equipments, get
        # some special info too
        items = db.query(itemsq, [character], db.every)
    except db.Error as e:
        return flask.render_template('server_error.html',
                                     errtype=type(e).__name__, err=e), 500

    if basic_data[8] == None:
        # if the character is not in a clan, we don't even need to do the last query
        clan_friends = None
    else:
        clanq = '''
          SELECT p.nome, p.usuario, p.classe, p.experiencia
          FROM personagem p
          WHERE p.nacao_do_clan = %s AND p.nome_do_clan = %s AND p.ID != %s
        '''
        try:
            # get all characters and their owners that are in the same clan as us
            clan_friends = db.query(clanq, [basic_data[1], basic_data[8],
                                            character], db.every)
        except db.Error as e:
            return flask.render_template('server_error.html',
                                         errtype=type(e).__name__, err=e), 500

    # if everything went right, we can render the final character page
    return flask.render_template('charhub.html', basic_data=basic_data,
                                 items=items, clan_friends=clan_friends)

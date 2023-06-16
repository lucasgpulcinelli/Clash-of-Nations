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
        return flask.redirect('/userhub.html')
    return app.send_static_file('login.html')


@app.route('/register.html')
def registerPage():
    if flask.request.cookies.get('sid'):
        return flask.redirect('/userhub.html')
    return flask.render_template('register.html')


@app.route('/userhub.html')
def user_hub():
    sid = flask.request.cookies.get('sid')
    if not sid:
        return flask.redirect('/login.html')
    if sessions.get(sid) is None:
        resp = flask.redirect('/login.html')
        resp.delete_cookie('sid')
        return resp

    user = sessions[sid]

    query = '''
      SELECT ID, nome, nacao, classe
      FROM Personagem
      WHERE usuario = %s
      ORDER BY nome
    '''

    try:
        characters = db.query(query, [user], db.every)
    except db.Error as e:
        return flask.render_template('server_error.html', errtype=type(e).__name__, err=e), 500

    return flask.render_template('userhub.html', user=user, characters=characters)


@app.route('/charhub.html')
def char_hub():
    sid = flask.request.cookies.get('sid')
    if (not sid) or sessions.get(sid) is None:
        return flask.redirect('/login.html')

    user = sessions[sid]

    character = flask.request.args.get('char')
    if character is None:
        return flask.redirect('/userhub.html')

    basicq = '''
      SELECT nome, nacao, pontos_de_poder, vida_maxima, dinheiro, classe,
        historia, experiencia, nome_do_clan, especializacao
      FROM Personagem
      WHERE usuario = %s AND ID = %s
    '''
    basic_data = db.query(basicq, [user, character], db.one)
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
    items = db.query(itemsq, [character], db.every)

    if basic_data[8] == None:
        clan_friends = None
    else:
        clanq = '''
          SELECT p.nome, p.usuario, p.classe, p.experiencia
          FROM personagem p
          WHERE p.nacao_do_clan = %s AND p.nome_do_clan = %s AND p.ID != %s
        '''
        clan_friends = db.query(clanq, [basic_data[1], basic_data[8],
                                        character], db.every)

    return flask.render_template('charhub.html', basic_data=basic_data,
                                 items=items, clan_friends=clan_friends)


@app.route('/admin.html')
def admin():
    sid = flask.request.cookies.get('sid')
    # TODO: we should query db for admin access
    if (not sid) or sessions.get(sid) != 'admin':
        return flask.Response('<h1>Forbidden</h1>', 403)

    query = "SELECT nome, email, data_de_criacao FROM usuario"
    try:
        users = db.query(query, quantityLambda=db.every)
    except db.Error as e:
        return flask.render_template('server_error.html', errtype=type(e).__name__, err=e), 500

    return flask.render_template('admin.html', users=users)

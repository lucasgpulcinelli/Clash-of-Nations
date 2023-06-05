import psycopg2
import os
import sys

try:
    # connect to the database using the environment variables provided
    # important: this file is imported multiple times, however this does not
    # create many different connections: if you look at connection.info.socket
    # (or just the memory location connection), you will see that the
    # connection is the exact same
    connection = psycopg2.connect(
        f"host='{os.environ['POSTGRES_URL']}'                                  \
          user='{os.environ['POSTGRES_USER']}'                                 \
          password='{os.environ['POSTGRES_PASSWORD']}'")
except Exception as e:
    print(f'could not connect to database: {type(e).__name__}: {e}',
          file=sys.stderr)
    exit(-1)


# the three functions below are to be used as parameters in query as
# quantityLambda

def every(cursor):
    return cursor.fetchall()


def one(cursor):
    return cursor.fetchone()


def get(n):
    return lambda cursor, n=n: cursor.fetchmany(n)


def query(query, variables=None, quantityLambda=every, cursor=None):
    '''
    query executes a query in the database and returns a list of tuples, where
    each entry of the list is a database row, and each entry in the tuple is a
    column. This function is primarialy ment to be used with SELECTs. The query
    is the query string itself, quantityLambda is one of db.every, db.one or
    db.get, ment to select how many results are wanted. Optionally, a list of
    variables for the query can be passed, as well as an existing cursor.
    '''

    close = False
    if not cursor:
        close = True
        cursor = connection.cursor()

    cursor.execute(query, variables)
    result = quantityLambda(cursor)

    if close:
        cursor.close()

    return result


def insert(statement, variables=None, cursor=None):
    '''
    insert executes a statement in the database, and if any error ocurrs,
    rollbacks the connection. This function is primarialy ment to be used with
    INSERTs. statement is the string with the SQL itself. Optionally, a list of
    variables for the statement can be passed, as well as an existing cursor.
    If the cursor is not passed, any successful execution commits changes.
    '''

    close = False
    if not cursor:
        close = True
        cursor = connection.cursor()

    try:
        cursor.execute(statement, variables)
    except Exception as e:
        if close:
            connection.rollback()
        raise e

    if close:
        connection.commit()
        cursor.close()

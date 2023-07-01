import psycopg2
import psycopg2.pool
import os
import sys

try:
    host = os.environ.get('POSTGRES_URL')
    if host is None:
        host = "localhost"

    # create a connection pool to the database using the environment variables
    # provided.
    # important: this file is imported multiple times, however this does not
    # create many different pools: if you look at the properties internally,
    # you will see that the pool is the exact same
    pool = psycopg2.pool.ThreadedConnectionPool(1, 5,
                                                host=host,
                                                user=os.environ['POSTGRES_USER'],
                                                password=os.environ['POSTGRES_PASSWORD'])
except Exception as e:
    print(f'could not connect to database: {type(e).__name__}: {e}',
          file=sys.stderr)
    exit(-1)

# a simple error alias to simplify imports
Error = psycopg2.Error

# the four functions below are to be used as parameters in query as
# quantityLambda


def every(cursor):
    return cursor.fetchall()


def one(cursor):
    return cursor.fetchone()


def get(n):
    return lambda cursor, n=n: cursor.fetchmany(n)


def no_read(cursor):
    return None


def query(query, variables=None, quantityLambda=no_read, connection=None):
    '''
    query executes a query in the database and returns a list of tuples, where
    each entry of the list is a database row, and each entry in the tuple is a
    column. The query is the query string itself, quantityLambda is one of
    db.every, db.one, db.get or db.no_read, ment to select how many results are
    wanted. Optionally, a list of variables for the query can be passed, as well
    as an existing connection.
    '''

    close = False
    if not connection:
        close = True
        connection = pool.getconn()

    cursor = connection.cursor()

    try:
        cursor.execute(query, variables)
    except psycopg2.Error as e:
        print(f"error in db connection: {type(e).__name__}: {e}")
        connection.rollback()
        cursor.close()
        if close:
            pool.putconn(connection)
        raise e

    result = quantityLambda(cursor)
    cursor.close()

    if close:
        connection.commit()
        pool.putconn(connection)

    return result

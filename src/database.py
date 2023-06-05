import psycopg2


class ClashOfNationsDB():
    def __init__(self, host, user, password):
        self.connection = psycopg2.connect(f"host='{host}' user='{user}'       \
                                             password='{password}'")
        self.all = lambda cursor: cursor.fetchall()
        self.one = lambda cursor: cursor.fetchone()

    def get(self, n):
        return lambda cursor, n=n: cursor.fetchmany(n)

    def query(self, query, quantityLambda=None, variables=None, cursor=None):
        if not quantityLambda:
            quantityLambda = self.all

        close = False
        if not cursor:
            close = True
            cursor = self.connection.cursor()

        cursor.execute(query, variables)
        result = quantityLambda(cursor)

        if close:
            cursor.close()

        return result

    def insert(self, statement, variables=None, cursor=None):
        close = False
        if not cursor:
            close = True
            cursor = self.connection.cursor()

        try:
            cursor.execute(statement, variables)
        except Exception as e:
            if close:
                self.connection.rollback()
            raise e

        if close:
            self.connection.commit()
            cursor.close()

#!/usr/bin/env python3
import psycopg2
from dotenv import dotenv_values

config = dotenv_values(".env")

if __name__ == "__main__":
    conn = psycopg2.connect(f"host='localhost'                                 \
                              user='{config['POSTGRES_USER']}'                 \
                              password='{config['POSTGRES_PASSWORD']}'")
    cur = conn.cursor()

    cur.execute("SELECT (nome, data_de_criacao, aconselhador) FROM usuario;")
    print(cur.fetchall())


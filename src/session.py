'''
the session dictionary: holds a dictionary from string to string, where the key
is the user session id, generated as a random UUID4 (which should be sent as a
cookie named 'sid') and the value is the username for that user.

This is made because if the username were to be stored directly as a cookie it
would be trivial to impersonate someone without their password. This system is
definetly not perfect, but the main objective of the project is database access
and not security engineering, so it is enough.
'''
sessions = {}

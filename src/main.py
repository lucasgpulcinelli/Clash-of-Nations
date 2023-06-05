#!/usr/bin/env python3
import sys
import waitress

# get all routes for the application
import routes


if __name__ == "__main__":
    # run in production or debug mode to ease development depending on sys.argv.
    production = False
    if len(sys.argv) >= 2 and sys.argv[1] == 'production':
        production = True

    if production:
        waitress.serve(routes.app)
    else:
        routes.app.run('0.0.0.0', 8080, debug=True)

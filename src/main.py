#!/usr/bin/env python3
import sys
import waitress

import routes


if __name__ == "__main__":
    production = False
    if len(sys.argv) >= 2 and sys.argv[1] == 'production':
        production = True

    if production:
        waitress.serve(routes.app)
    else:
        routes.app.run('0.0.0.0', 8080, debug=True)

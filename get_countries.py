from app.app_get_countries import *

if __name__ == '__main__':
    """
    Starts debug server
    """
    APP.run(debug=False, host='127.0.0.1', port=5100, ssl_context=None)

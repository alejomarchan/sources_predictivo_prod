from flask import Flask
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import json
from flask_cors import CORS

APP = Flask(__name__)
APP.config['JSONIFY_PRETTYPRINT_REGULAR'] = True
APP.config['RESTPLUS_MASK_SWAGGER'] = False
#APP.config['SWAGGER_UI_DOC_EXPANSION'] = 'full'

CORS(APP)

with open('./config/config_general.json', 'r') as config_file:
    CONFIG = json.load(config_file)

limiter = Limiter(
    APP,
    key_func=get_remote_address,
    default_limits=[CONFIG["CONFIG"]["LIMIT_PER_SECOND"] + " per second"]
)

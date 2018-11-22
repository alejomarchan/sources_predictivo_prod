from app import APP
import cx_Oracle
import json
from flask import render_template, request, jsonify
import log
import database
from flask_restplus import Api, Resource, fields

with open('./config/config_countries.json', 'r') as config_file:
    config = json.load(config_file)

with open('./config/config_general.json', 'r') as config_file:
    config_general = json.load(config_file)

global max_return
global log_tag
log_tag = config["CONFIG"]["LOG_TAG"]
srv_name = config["CONFIG"]["LOG_TAG"]
desc = config["CONFIG"]["DESCRIPTION"]
profile_name = config["CONFIG"]["PROFILE_NAME"]
conn_str = config_general["CONFIG"]["DB"]
max_return = config_general["CONFIG"]["MAX_RETURN"]
limite = config_general["CONFIG"]["LIMIT_PER_SECOND"]

log.init(profile_name)
log.dbg('Start')
database.init()

api = Api(APP, version='1.0', title=srv_name,
          description=desc + '\n'
                             'Conexión a BD:' + conn_str + '\n'
                                                           'Cantidad máxima de invocaciones por segundo:' + limite)

ns = api.namespace('getCountries', description='getCountries de Callejero Predictivo')


@APP.route('/getCountries', methods=['GET', 'POST'])
@ns.response(200, 'Success')
@ns.response(404, 'Not found')
@ns.response(429, 'Too many request')
@ns.param('country', 'Substring de Pais (ej:ARGE)')
def getCountries():
    try:
        list_parametros = (request.get_json())
        country = list_parametros["country"]
        cur = database.db.cursor()
        list = cur.var(cx_Oracle.STRING)
        cur.callproc('PREDICTIVO.get_pais', (country, max_return, list))
    except Exception as e:
        database.init()
        if database.db is not None:
            log.inf('Reconexion OK')
            cur = database.db.cursor()
            list = cur.var(cx_Oracle.STRING)
            cur.callproc('PREDICTIVO.get_pais', (country, max_return, list))
        else:
            log.err('Sin conexión a la base de datos')
            list = None
    response = list.getvalue()
    return json.dumps(response), 200

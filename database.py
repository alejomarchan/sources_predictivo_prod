import json
import cx_Oracle
import logging
import sys

def init():
    with open('./config/config_general.json', 'r') as config_file:
        config = json.load(config_file)
    global db
    conn_str = config["CONFIG"]["DB"]
    db = None
    try:
        logging.debug("Connecting to database...")
        db = cx_Oracle.connect(conn_str)
        logging.debug("Connected to database!")
    except cx_Oracle.DatabaseError as e:
        error = e.args
        logging.error("Failed to connect to database")
        logging.error(error.message)
        db = None
    else:
        logging.info("Connection established")

import logging
import graypy
import json


logger = None
log_tag = None

def init(profile_name):
    with open('./config/config_general.json', 'r') as config_file:
        config_general = json.load(config_file)

    with open('./config/'+profile_name+'.json', 'r') as config_file:
        config = json.load(config_file)

    global logger
    global log_tag
    log_tag = config["CONFIG"]["LOG_TAG"]
    logger = logging.getLogger(log_tag)
    logger.setLevel(logging.DEBUG)
    handler = graypy.GELFHandler(config_general["CONFIG"]["GRAYLOG_HOST"],
                                 config_general["CONFIG"]["GRAYLOG_PORT"])
    logger.addHandler(handler)


def dbg(str):
    global logger
    global log_tag
    logger.debug(log_tag + ': ' + str)


def err(str):
    global logger
    global log_tag
    logger.error(log_tag + ': ' + str)


def inf(str):
    global logger
    global log_tag
    logger.info(log_tag + ': ' + str)


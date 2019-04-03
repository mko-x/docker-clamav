#!/usr/bin/python3

import os
import logging as log
import sys

log.basicConfig(stream=sys.stderr, level=os.environ.get("LOG_LEVEL", "WARNING"))
logger=log.getLogger(__name__)

if not os.path.isfile("/store/main.cvd"):
    logger.info("Initial clam DB download.")
    os.system("freshclam")

logger.info("Schedule freshclam DB updater.")
os.system("freshclam -d -c 6")

logger.info("Run clamav daemon")
os.system("clamd")
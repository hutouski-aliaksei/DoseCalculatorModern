__version__ = '0.1.0'
__author__ = 'Aliaksei Hutouski'

import sys
from bridge import run_app
import faulthandler


if __name__ == '__main__':
    faulthandler.enable()
    sys.exit(run_app())

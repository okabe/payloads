from setuptools import setup

APP = ['stager.py']
DATA_FILES = []
OPTIONS = {
    'argv_emulation': True,
    'iconfile': 'templates/shield.ico'
}

setup(
    app=APP,
    data_files=DATA_FILES,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)

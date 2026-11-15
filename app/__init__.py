from flask import Flask
from config import Config
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config.from_object(Config)  # Read and apply the config file (config.py)
db = SQLAlchemy(app)

from app import routes
import os

from flask_login import LoginManager

from accounts_app.models import User
from core.settings import server

from dotenv import load_dotenv

load_dotenv()

server.secret_key = os.getenv("SECRET_KEY")

login_manager = LoginManager(app=server)

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(user_id)

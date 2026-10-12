import werkzeug
import werkzeug.security

from accounts_app.models import User
from core.db import DATABASE as db


class RegisterUserRepository:
    
    @staticmethod
    def register_user(email: str, password: str):
        # Перевіряємо існування користувача з таким email
        # Для виключення випадків повторного створення користувача
        selected_user = User.query.filter_by(
            email=email
        )
        
        user = selected_user.scalar()
        
        if user:
            return {
                "is_successful": False,
                "error": "Користувач з таким e-mail вже існує",
                "field": "email",
                "status": 400
            }
        
        # Создаем нового пользователя
        password_hash = werkzeug.security.generate_password_hash(
            password=password
        )
        
        new_user = User(
            email=email,
            password_hash=password_hash
        )
        
        db.session.add(new_user)
        db.session.commit()
        
        return {
            "is_successful": True,
            "data": {
                "id": new_user.id,
                "email": new_user.email
            },
            "status": 200
        }

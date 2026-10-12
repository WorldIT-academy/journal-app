from accounts_app.models import User
from werkzeug.security import check_password_hash

class AuthorizeUserRepository:
    
    @staticmethod
    def check_user(email: str, password: str):
        
        selected_users = User.query.filter_by(
            email=email
        )
        
        user: User = selected_users.scalar()
        
        if not user:
            return {
                "is_successful": False,
                "error": "Такого користувача не існує",
                "field": "email",
                "status": 400
            }
        
        is_correct = check_password_hash(
            password=password,
            pwhash=user.password_hash
        )
        
        if not is_correct:
            return {
                "is_successful": False,
                "error": "Неправильний пароль",
                "field": "password",
                "status": 400
            }
        
        return {
            "is_successful": True,
            "data": {
                "user": user
            },
            "status": 200
        }

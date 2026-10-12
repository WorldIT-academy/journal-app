from typing import Any


class RegisterUseCase:
    def __init__(self):
        pass
    
    def execute(self, action: str, **kwargs):
        
        if action == "validate":
            return self._validate_register_data(**kwargs)
    
    def _validate_register_data(
            self, 
            email: str, 
            password: str, 
            confirm_password: str
        ) -> dict[str, Any]:
        
        if not email:
            return {
                "is_successful": False,
                "error": "Вкажіть email",
                "field": "email",
                "status": 400
            }
        
        if "@" not in email:
            return {
                "is_successful": False,
                "error": "Введіть коректний email",
                "field": "email",
                "status": 400
            }
    
        # Password
        if not password:
            return {
                "is_successful": False,
                "error": "Вкажіть пароль",
                "field": "password",
                "status": 400
            }
        
        if len(password) < 8:
            return {
                "is_successful": False,
                "error": "Пароль має містити щонайменше 8 символів",
                "field": "password",
                "status": 400
            }
        
        # Password confirmation
        if not confirm_password:
            return {
                "is_successful": False,
                "error": "Підтвердіть пароль",
                "field": "confirm_password",
                "status": 400
            }
    
        if confirm_password != password:
            return {
                "is_successful": False,
                "error": "Паролі не збігаються",
                "field": "confirm_password",
                "status": 400
            }
        
        return {
            "is_successful": True,
            "data": {
                "message": "Користувача успішно зареєстровано",
            } 
        }

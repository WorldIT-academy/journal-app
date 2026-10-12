
class AuthorizeUseCase:
    def __init__(self):
        pass

    def execute(self, action: str, **kwargs):
        
        if action == "validate":
            return self._validate_authorize_data(**kwargs)
    
    def _validate_authorize_data(
            self,
            email: str, 
            password: str
        ):
        
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
        
        return {
            "is_successful": True,
            "data": {
                "message": None # Буде заповнено у services, у випадку успішного створення сесії
            } 
        }

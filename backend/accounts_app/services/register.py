from accounts_app.repositories.register import RegisterUserRepository
from accounts_app.use_cases import RegisterUseCase

class RegisterUserServices:
    
    @staticmethod
    def register_user(data: dict):
        email = data["email"]
        password = data["password"]
        confirm_password = data["confirm_password"]
        
        register_use_case = RegisterUseCase()
        
        result = register_use_case.execute(
            action="validate",
            email=email,
            password=password,
            confirm_password=confirm_password
        )
        
        if not result["is_successful"]:
            return result
        
        register_user_result = RegisterUserRepository.register_user(
            email=email,
            password=password
        )
        
        if not register_user_result["is_successful"]:
            return register_user_result
        
        # Возвращаем успешній ответ (неуспешній возвращается віше, в условии not result["is_successful"])
        return result

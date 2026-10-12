from flask import session
from flask_login import login_user

from accounts_app.repositories.authorize import AuthorizeUserRepository
from accounts_app.use_cases.authorize_use_case import AuthorizeUseCase


class AuthorizeUserServices:
    
    @staticmethod
    def authorize_user(data: dict):
        
        email = data["email"]
        password = data["password"]
        
        authorize_use_case = AuthorizeUseCase()
        
        result = authorize_use_case.execute(
            action="validate",
            email=email,
            password=password
        )
        
        if not result["is_successful"]:
            return result
        
        check_user_result = AuthorizeUserRepository.check_user(
            email=email,
            password=password
        )
        
        if not check_user_result["is_successful"]:
            return check_user_result
        
        login_user(check_user_result["data"]["user"])
        
        # Указіваем данніе сессии и сообщение об успешной авторизации пользователя
        result["data"]["message"] = "Користувача успішно авторизовано"
        
        # Возвращаем успешній ответ (неуспешній возвращается віше, в условии «not result["is_successful"])»
        return result

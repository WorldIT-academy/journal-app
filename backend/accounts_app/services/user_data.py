from flask_login import current_user

from accounts_app.repositories.user_data import UserDataRepository
from accounts_app.use_cases.user_data_use_case import UserDataUseCase


class UserDataServices:
    
    @staticmethod
    def get_user_data():
        
        user_result = UserDataRepository.get_user_data(
            id=current_user.id,
        )
        
        if not user_result["is_successful"]:
            return user_result
        
        # Возвращаем успешній ответ (неуспешній возвращается віше, в условии not result["is_successful"])
        return user_result
    
    @staticmethod
    def update_user_data(data: dict):
        first_name = data["first_name"]
        last_name = data["last_name"]
        work_day_start = data["work_day_start"]
        work_day_end = data["work_day_end"]
        week_start = data["week_start"]
        
        user_data_use_case = UserDataUseCase()
        
        result = user_data_use_case.execute(
            action="validate",
            first_name=first_name,
            last_name=last_name,
            work_day_start=work_day_start,
            work_day_end=work_day_end,
            week_start=week_start,
        )
        
        if not result["is_successful"]:
            return result
        
        user_data_update_result = UserDataRepository.update_user_data(
            first_name=first_name,
            last_name=last_name,
            work_day_start=work_day_start,
            work_day_end=work_day_end,
            week_start=week_start,
        )
        
        if not user_data_update_result["is_successful"]:
            return user_data_update_result
        
        return result

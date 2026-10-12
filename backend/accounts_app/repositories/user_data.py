from typing import Any
from datetime import datetime
from flask_login import current_user

from core.db import DATABASE as db
from accounts_app.models import User


class UserDataRepository:
    
    @staticmethod
    def get_user_data(id: int) -> dict[str, Any]:
        
        user: User = User.query.get(id)
        
        if not user:
            return {
                "is_successful": False,
                "error": "Такого користувача не існує",
                "status": 400
            }
        
        return {
            "is_successful": True,
            "data": {
                "email": user.email,
                "first_name": user.first_name,
                "last_name": user.last_name,
                "week_start": user.week_start,
                "work_day_start": user.work_day_start.strftime("%Y-%m-%dT%H:%M:%S"),
                "work_day_end": user.work_day_end.strftime("%Y-%m-%dT%H:%M:%S"),
                "avatar": user.avatar,
                "timezone": user.timezone
            },
            "status": 200
        }
    
    @staticmethod
    def update_user_data(
        first_name: str,
        last_name: str,
        work_day_start: str,
        work_day_end: str,
        week_start: str,
    ) -> dict[str, Any]:
        
        user: User = User.query.get(current_user.id)
        
        if user is None:
            return {
                "is_successful": False,
                "error": "Такого користувача не існує",
                "status": 400
            }
        
        user.first_name = first_name.strip()
        user.last_name = last_name.strip()
        user.work_day_start = datetime.strptime(work_day_start.strip(), "%H:%M").time()
        user.work_day_end = datetime.strptime(work_day_end.strip(), "%H:%M").time()
        user.week_start = int(week_start)
        
        try:
            db.session.commit()
            return {
                "is_successful": True,
                "error": "Налаштування збережено успішно",
            }
        except Exception:
            return {
                "is_successful": False,
                "error": "Не вдалося зберегти налаштування",
                "status": 500
            }

import re
from datetime import datetime
from typing import Any


class UserDataUseCase:
    def __init__(self):
        pass
    
    def execute(self, action: str, **kwargs):
        
        if action == "validate":
            return self._validate_user_data(**kwargs)
    
    def _validate_user_data(
        self,
        first_name: str,
        last_name: str,
        work_day_start: str,
        work_day_end: str,
        week_start: str,
    ) -> dict[str, Any]:

        # Буквы любого алфавита; между словами допускаются пробел, дефис и апострофы
        name_pattern = r"[^\W\d_]+(?:[ '’ʼ-][^\W\d_]+)*"

        first_name = (first_name or "").strip()
        last_name = (last_name or "").strip()
        work_day_start = (work_day_start or "").strip()
        work_day_end = (work_day_end or "").strip()
        week_start = (week_start or "").strip()

        # First name
        if not first_name:
            return {
                "is_successful": False,
                "error": "Вкажіть імʼя",
                "field": "first_name",
                "status": 400
            }

        if len(first_name) > 50:
            return {
                "is_successful": False,
                "error": "Імʼя не може бути довшим за 50 символів",
                "field": "first_name",
                "status": 400
            }

        if not re.fullmatch(name_pattern, first_name):
            return {
                "is_successful": False,
                "error": "Імʼя може містити лише літери, пробіл, дефіс та апостроф",
                "field": "first_name",
                "status": 400
            }

        # Last name
        if not last_name:
            return {
                "is_successful": False,
                "error": "Вкажіть прізвище",
                "field": "last_name",
                "status": 400
            }

        if len(last_name) > 50:
            return {
                "is_successful": False,
                "error": "Прізвище не може бути довшим за 50 символів",
                "field": "last_name",
                "status": 400
            }

        if not re.fullmatch(name_pattern, last_name):
            return {
                "is_successful": False,
                "error": "Прізвище може містити лише літери, пробіл, дефіс та апостроф",
                "field": "last_name",
                "status": 400
            }

        # Work day start
        if not work_day_start:
            return {
                "is_successful": False,
                "error": "Вкажіть початок робочого дня",
                "field": "work_day_start",
                "status": 400
            }

        try:
            start_time = datetime.strptime(work_day_start, "%H:%M").time()
        except ValueError:
            return {
                "is_successful": False,
                "error": "Час має бути у форматі ГГ:ХХ",
                "field": "work_day_start",
                "status": 400
            }

        # Work day end
        if not work_day_end:
            return {
                "is_successful": False,
                "error": "Вкажіть кінець робочого дня",
                "field": "work_day_end",
                "status": 400
            }

        try:
            end_time = datetime.strptime(work_day_end, "%H:%M").time()
        except ValueError:
            return {
                "is_successful": False,
                "error": "Час має бути у форматі ГГ:ХХ",
                "field": "work_day_end",
                "status": 400
            }

        if end_time <= start_time:
            return {
                "is_successful": False,
                "error": "Кінець робочого дня має бути пізніше за початок",
                "field": "work_day_end",
                "status": 400
            }

        # Week start ("1" - понеділок, "7" - неділя)
        if not week_start:
            return {
                "is_successful": False,
                "error": "Оберіть початок тижня",
                "field": "week_start",
                "status": 400
            }

        if week_start not in ("1", "7"):
            return {
                "is_successful": False,
                "error": "Початок тижня може бути лише понеділок або неділя",
                "field": "week_start",
                "status": 400
            }

        return {
            "is_successful": True,
            "data": {
                "message": "Налаштування успішно збережено",
            }
        }

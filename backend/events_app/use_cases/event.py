from datetime import datetime


class EventUseCase:
    def __init__(self):
        pass
    
    def execute(self, action: str, **kwargs):
        
        if action == "validate":
            return self._validate_event_data(**kwargs)
        elif action == "convert_date":
            return self.convert_date(**kwargs)
    
    def _validate_event_data(
        self,
        start_at: datetime,
        end_at: datetime,
        title: str,
        description: str,
        location: str,
        category_id: int,
    ):
        
        if not start_at:
            return {
                "is_successful": False,
                "error": "Дата і час початку події обовʼязкові",
                "field": "start_at",
                "status": 400
            }

        if not end_at:
            return {
                "is_successful": False,
                "error": "Дата і час кінця події обовʼязкові",
                "field": "end_at",
                "status": 400
            }

        if end_at <= start_at:
            return {
                "is_successful": False,
                "error": "Час кінця має бути після часу початку",
                "field": "end_at",
                "status": 400
            }

        if not title or not title.strip():
            return {
                "is_successful": False,
                "error": "Відсутня назва події",
                "field": "title",
                "status": 400
            }

        if not description or not description.strip():
            return {
                "is_successful": False,
                "error": "Відсутній опис події",
                "field": "description",
                "status": 400
            }

        if not location or not location.strip():
            return {
                "is_successful": False,
                "error": "Відсутня локація події",
                "field": "location",
                "status": 400
            }

        if not category_id:
            return {
                "is_successful": False,
                "error": "Відсутня категорія події",
                "field": "category_id",
                "status": 400
            }

        return {
            "is_successful": True
        }
    
    def convert_date(
            self, 
            date: str, 
            start: str, 
            end: str
        ):
        
        try:
            date = datetime.strptime(date, "%Y-%m-%d")
            
            start_parts = start.split(":")
            end_parts = end.split(":")

            start_at = datetime(
                date.year,
                date.month,
                date.day,
                int(start_parts[0]),
                int(start_parts[1]),
            )
            
            end_at = datetime(
                date.year,
                date.month,
                date.day,
                int(end_parts[0]),
                int(end_parts[1]),
            )
            
            return {
                "is_successful": True,
                "data": {
                    "message": "Успішно створена подія",
                    "start_at": start_at,
                    "end_at": end_at
                }
            }
        
        except Exception as error:
            return {
                "is_successful": False,
                "error":  f"Неправильний формат дати початку/кінця",
                "field": "calendar",
                "status": 400
            }

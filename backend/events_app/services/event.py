from events_app.repositories.event import EventRepository
from events_app.use_cases.event import EventUseCase


class EventServices:
    
    @staticmethod
    def get_all_events():
        
        events_data_list = EventRepository.get_all_events()
        
        if len(events_data_list) < 1:
            return {
                "data": {
                    "message": "Події відсутні",
                },
                "status": 404
            }
        
        return {
            "data": {
                "message": "Успішно отримані події",
                "events": events_data_list
            },
            "status": 200
        }
    
    @staticmethod
    def create_event(data: dict):
        
        date = data["date"]
        start = data["start"]
        end = data["end"]
        title = data["title"]
        description = data["description"]
        location = data["location"]
        category_id = data["category_id"]
        
        event_use_case = EventUseCase()
        
        convert_date_result = event_use_case.execute(
            action="convert_date",
            date=date,
            start=start,
            end=end,
        )
        
        if not convert_date_result["is_successful"]:
            return convert_date_result
        
        validate_data_result = event_use_case.execute(
            action="validate",
            start_at=convert_date_result["data"]["start_at"],
            end_at=convert_date_result["data"]["end_at"],
            title=title,
            description=description,
            location=location,
            category_id=category_id
        )
        
        if not validate_data_result["is_successful"]:
            return validate_data_result
        
        created_event_result = EventRepository.create_event(
            start_at=convert_date_result["data"]["start_at"],
            end_at=convert_date_result["data"]["end_at"],
            title=title,
            description=description,
            location=location,
            category_id=int(category_id)
        )
        
        return created_event_result
    
    @staticmethod
    def delete_event(id: int):
        
        return EventRepository.delete_event(id=id)

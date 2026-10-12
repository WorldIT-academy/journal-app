from flask_login import current_user
from datetime import datetime

from events_app.models import Event
from core.db import DATABASE as db


class EventRepository:
    
    @staticmethod
    def create_event(
            start_at: datetime,
            end_at: datetime,
            title: str,
            description: str,
            location: str,
            category_id: int,
        ):
        
        new_event = Event(
            start_at=start_at,
            end_at=end_at,
            title=title,
            description=description,
            location=location,
            user_id=current_user.id,
            category_id=category_id,
        )
        
        db.session.add(new_event)
        db.session.commit()
        
        return {
            "is_successful": True,
            "data": {
                "message": "Подію створено успішно",
                "id": new_event.id,
                "start_at": new_event.start_at,
                "end_at": new_event.end_at,
                "title": new_event.title,
                "description": new_event.description,
                "location": new_event.location,
                "category_id": new_event.category_id
            }
        }
    
    def get_all_events():
        events = list(Event.query.filter_by(
            user_id=current_user.id
        ))
        
        if len(events) < 1:
            return []
        
        events_data_list = []
        
        for event in events:
            event: Event
            
            events_data_list.append({
                "id": event.id,
                "start_at": event.start_at,
                "end_at": event.end_at,
                "title": event.title,
                "description": event.description,
                "location": event.location,
                "category_id": event.category_id
            })
        
        return events_data_list
    
    @staticmethod
    def delete_event(id: int):
        
        event: Event = Event.query.get(id)
        
        if not event:
            return {
                "data": {
                    "message": "Подія не існує"
                },
                "status": 404
            }
        
        if event.user_id != current_user.id:
            return {
                "data": {
                    "message": "Нема права на видалення події"
                },
                "status": 403
            }
        
        db.session.delete(event)
        db.session.commit()
        
        return {
            "data": {
                "message": "Подію видалено успішно"
            },
            "status": 200
        }

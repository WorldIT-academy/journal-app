from flask.views import MethodView
from flask import request, jsonify
from flask_login import login_required

from events_app.services.event import EventServices

class EventView(MethodView):
    
    @login_required
    def post(self):
        
        data = {
            "date": request.form.get("date"),
            "start": request.form.get("start"),
            "end": request.form.get("end"),
            "title": request.form.get("title"),
            "description": request.form.get("description"),
            "location": request.form.get("location"),
            "category_id": request.form.get("category_id"),
        }
        
        result = EventServices.create_event(data=data)
        
        if not result["is_successful"]:
            return jsonify({
                "error": result["error"],
                "field": result["field"]
            }), result["status"]
        
        return jsonify(result["data"]), 201
    
    @login_required
    def get(self):
        
        result = EventServices.get_all_events()
        
        return jsonify(result["data"]), result["status"]
    
    @login_required
    def delete(self, event_id: int):
        
        result = EventServices.delete_event(id=event_id)
        
        return jsonify(result["data"]), result["status"]

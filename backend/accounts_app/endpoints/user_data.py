from flask.views import MethodView
from flask import request, jsonify
from flask_login import login_required

from accounts_app.services.user_data import UserDataServices


class UserDataView(MethodView):
    
    @login_required
    def get(self):
        
        result = UserDataServices.get_user_data()
        
        if not result["is_successful"]:
            return jsonify({
            "error": result["error"]
        }), result["status"]
        
        return jsonify(result["data"]), 200
    
    @login_required
    def put(self):
        data = {
            "first_name": request.form.get("first_name"),
            "last_name": request.form.get("last_name"),
            "work_day_start": request.form.get("work_day_start"),
            "work_day_end": request.form.get("work_day_end"),
            "week_start": request.form.get("week_start"),
        }
        
        result = UserDataServices.update_user_data(data)
        
        if not result["is_successful"]:
            return jsonify({
            "error": result["error"]
        }), result["status"]
        
        return jsonify(result["data"]), 200

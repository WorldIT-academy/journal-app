from flask.views import MethodView
from flask import request, jsonify

from accounts_app.services.register import RegisterUserServices


class RegisterEndpoint(MethodView):
    
    def post(self):
        data = {
            "email": request.form.get("email"),
            "password": request.form.get("password"),
            "confirm_password": request.form.get("confirm_password"),
        }
        
        result = RegisterUserServices.register_user(data=data)
        
        if not result["is_successful"]:
            return jsonify({
            "error": result["error"],
            "field": result["field"]
        }), result["status"]
        
        return jsonify(result["data"]), 201

from flask.views import MethodView
from flask import request, jsonify

from accounts_app.services.authorize import AuthorizeUserServices


class AuthorizeView(MethodView):
    
    def post(self):
        data = {
            "email": request.form.get("email"),
            "password": request.form.get("password"),
        }
        
        result = AuthorizeUserServices.authorize_user(data=data)
        
        if not result["is_successful"]:
            return jsonify({
            "error": result["error"],
            "field": result["field"]
        }), result["status"]
        
        return jsonify(result["data"]), 200

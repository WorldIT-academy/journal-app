from flask.views import MethodView
from flask import jsonify
from flask_login import login_required, current_user

class AuthenticateView(MethodView):
    
    @login_required
    def get(self):
        return jsonify({
            "authenticated": True,
            "user_id": current_user.id
        }), 200

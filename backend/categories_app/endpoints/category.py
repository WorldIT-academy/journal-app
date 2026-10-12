from flask.views import MethodView
from flask import request, jsonify
from flask_login import login_required

from categories_app.services.category import CategoryServices

class CategoryView(MethodView):
    
    @login_required
    def post(self):
        data = {
            "color": request.form.get("color"),
            "name": request.form.get("name"),
            "icon": request.form.get("icon"),
        }
        
        result = CategoryServices.create_category(data=data)
        
        if not result["is_successful"]:
            return jsonify({
                "error": result["error"],
                "field": result["field"]
            }), result["status"]
        
        return jsonify(result["data"]), 201
    
    @login_required
    def get(self):
        
        result = CategoryServices.get_all_categories()
        
        return jsonify(result["data"]), result["status"]
    
    @login_required
    def delete(self, category_id: int):
        
        result = CategoryServices.delete_category(id=category_id)
        
        return jsonify(result["data"]), result["status"]

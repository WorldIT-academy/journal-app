from flask_login import current_user

from core.db import DATABASE as db
from categories_app.models import Category


class CategoryRepository:
    
    @staticmethod
    def create_category(
            color: str, 
            name: str, 
            icon: str
        ):
        
        new_category = Category(
            color=color,
            name=name,
            icon=icon,
            user_id=current_user.id
        )
        
        db.session.add(new_category)
        db.session.commit()
        
        return {
            "is_successful": True,
            "data": {
                "message": "Категорію створено успішно",
                "id": new_category.id,
                "color": new_category.color,
                "name": new_category.name,
                "icon": new_category.icon
            }
        }
    
    @staticmethod
    def get_all_categories():
        
        categories = list(Category.query.filter_by(
            user_id=current_user.id
        ))
        
        if len(categories) < 1:
            return []
        
        categories_data_list = []
        
        for category in categories:
            category: Category
            
            categories_data_list.append({
                "id": category.id,
                "color": category.color,
                "name": category.name,
                "icon": category.icon
            })
        
        return categories_data_list
    
    @staticmethod
    def delete_category(id: int):
        
        category: Category = Category.query.get(id)
        
        if not category:
            return {
                "data": {
                    "message": "Категорія не існує"
                },
                "status": 404
            }
        
        if category.user_id != current_user.id:
            return {
                "data": {
                    "message": "Нема права на видалення категорії"
                },
                "status": 403
            }
        
        db.session.delete(category)
        db.session.commit()
        
        return {
            "data": {
                "message": "Категорію видалено успішно"
            },
            "status": 200
        }

from categories_app.repositories.category import CategoryRepository
from categories_app.use_cases.category import CategoryUseCase


class CategoryServices:
    
    @staticmethod
    def create_category(data: dict):
        color = data["color"]
        name = data["name"]
        icon = data["icon"]
        
        category_use_case = CategoryUseCase()
        
        result = category_use_case.execute(
            action="validate",
            color=color,
            name=name,
            icon=icon,
        )
        
        if not result["is_successful"]:
            return result
        
        created_category_result = CategoryRepository.create_category(
            color=color,
            name=name,
            icon=icon,
        )
        
        return created_category_result
    
    @staticmethod
    def get_all_categories():
        
        categories_data_list = CategoryRepository.get_all_categories()
        
        if len(categories_data_list) < 1:
            return {
                "data": {
                    "message": "Категорії відсутні",
                },
                "status": 404
            }
        
        return {
            "data": {
                "message": "Успішно отримані категорії",
                "categories": categories_data_list
            },
            "status": 200
        }
    
    def delete_category(id: int):
        
        return CategoryRepository.delete_category(id=id)

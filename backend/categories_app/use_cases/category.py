
class CategoryUseCase:
    def __init__(self):
        pass

    def execute(self, action: str, **kwargs):
        
        if action == "validate":
            return self._validate_category_data(**kwargs)
    
    def _validate_category_data(
            self,
            color: str, 
            name: str,
            icon: str
        ):
        
        # COLOR
        if not color:
            return {
                "is_successful": False,
                "error": "Вкажіть колір",
                "field": "color",
                "status": 400
            }
    
        # NAME
        if not name:
            return {
                "is_successful": False,
                "error": "Вкажіть назву категорії",
                "field": "name",
                "status": 400
            }
        
        # ICON
        if not icon:
            return {
                "is_successful": False,
                "error": "Вкажіть іконку",
                "field": "icon",
                "status": 400
            }
        
        if not ".svg" in icon or "/" in icon:
            return {
                "is_successful": False,
                "error": "Неправильний формат іконки",
                "field": "icon",
                "status": 400
            }
        
        return {
            "is_successful": True
        }

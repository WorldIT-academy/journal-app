from accounts_app.endpoints.authenticate import AuthenticateView
from accounts_app.endpoints.authorize import AuthorizeView
from accounts_app.endpoints.register import RegisterEndpoint

from accounts_app.app import accounts_app
from accounts_app.endpoints.user_data import UserDataView
from calendar_app.app import calendar_app
from categories_app.app import categories_app
from categories_app.endpoints.category import CategoryView
from events_app.app import events_app
from events_app.endpoints.event import EventView
from habits_app.app import habits_app
from notifications_app.app import notifications_app
from tasks_app.app import tasks_app

from core.settings import server


# Accounts app
server.add_url_rule(
    rule="/register",
    view_func=RegisterEndpoint.as_view("register")
)
server.add_url_rule(
    rule="/authorize",
    view_func=AuthorizeView.as_view("authorize")
)

server.add_url_rule(
    rule="/authenticate",
    view_func=AuthenticateView.as_view("authenticate")
)

server.add_url_rule(
    rule="/user",
    view_func=UserDataView.as_view("user_data")
)

# Categories
category_view = CategoryView.as_view("categories")

server.add_url_rule(
    rule="/categories",
    view_func=category_view,
    methods=["GET", "POST"]
)

server.add_url_rule(
    rule="/categories/<int:category_id>",
    view_func=category_view,
    methods=["DELETE"]
)

# Events
event_view = EventView.as_view("events")

server.add_url_rule(
    rule="/events",
    view_func=event_view,
    methods=["GET", "POST"]
)

server.add_url_rule(
    rule="/events/<int:event_id>",
    view_func=event_view,
    methods=["DELETE"]
)

# Blueprint registration
server.register_blueprint(blueprint=accounts_app)
server.register_blueprint(blueprint=calendar_app)
server.register_blueprint(blueprint=categories_app)
server.register_blueprint(blueprint=events_app)
server.register_blueprint(blueprint=habits_app)
server.register_blueprint(blueprint=notifications_app)
server.register_blueprint(blueprint=tasks_app)

import flask_sqlalchemy
import flask_migrate

from core.settings import BASE_DIR, server


server.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///data.db"

DATABASE = flask_sqlalchemy.SQLAlchemy(app=server)

MIGRATE = flask_migrate.Migrate(
    app=server,
    db=DATABASE,
    directory=BASE_DIR / "core" / "migrations"
)

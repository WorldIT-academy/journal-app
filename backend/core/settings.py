import flask
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent

server = flask.Flask(
    import_name="core",
    instance_path=BASE_DIR / "core" / "instance",
    static_folder="static",
    template_folder="templates"
)

from core.db import DATABASE as db


class Category(db.Model):
    __tablename__ = "categories"

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    name = db.Column(
        db.String,
        nullable=False
    )

    color = db.Column(
        db.String,
        nullable=False
    )

    icon = db.Column(
        db.String,
        nullable=False
    )

    user_id = db.Column(
        db.Integer,
        db.ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    user = db.relationship(
        "User",
        back_populates="categories"
    )

    events = db.relationship(
        "Event",
        back_populates="category"
    )

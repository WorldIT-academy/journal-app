from core.db import DATABASE as db


class Event(db.Model):
    __tablename__ = "events"

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    title = db.Column(
        db.String,
        nullable=False
    )

    description = db.Column(
        db.Text,
        nullable=True
    )

    start_at = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        index=True
    )

    end_at = db.Column(
        db.DateTime(timezone=True),
        nullable=False
    )

    location = db.Column(
        db.String,
        nullable=True
    )

    category_id = db.Column(
        db.Integer,
        db.ForeignKey("categories.id", ondelete="SET NULL"),
        nullable=True,
        index=True
    )

    user_id = db.Column(
        db.Integer,
        db.ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    category = db.relationship(
        "Category",
        back_populates="events"
    )

    user = db.relationship(
        "User",
        back_populates="events"
    )

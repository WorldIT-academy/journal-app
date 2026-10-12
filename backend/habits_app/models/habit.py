from core.db import DATABASE as db


class Habit(db.Model):
    __tablename__ = "habits"

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    name = db.Column(
        db.String,
        nullable=False
    )

    is_archived = db.Column(
        db.Boolean,
        nullable=False,
        default=False
    )

    category_id = db.Column(
        db.Integer,
        db.ForeignKey(
            "categories.id",
            ondelete="SET NULL"
        ),
        nullable=True,
        index=True
    )

    user_id = db.Column(
        db.Integer,
        db.ForeignKey(
            "users.id",
            ondelete="CASCADE"
        ),
        nullable=False,
        index=True
    )

    user = db.relationship(
        "User",
        back_populates="habits"
    )

    entries = db.relationship(
        "HabitEntry",
        back_populates="habit",
        cascade="all, delete-orphan"
    )

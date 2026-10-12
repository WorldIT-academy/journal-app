from core.db import DATABASE as db


class HabitEntry(db.Model):
    __tablename__ = "habit_entries"

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    date = db.Column(
        db.Date,
        nullable=False
    )

    completed_at = db.Column(
        db.DateTime(timezone=True),
        nullable=True
    )

    habit_id = db.Column(
        db.Integer,
        db.ForeignKey(
            "habits.id",
            ondelete="CASCADE"
        ),
        nullable=False,
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

    habit = db.relationship(
        "Habit",
        back_populates="entries"
    )

    user = db.relationship(
        "User",
        back_populates="habit_entries"
    )

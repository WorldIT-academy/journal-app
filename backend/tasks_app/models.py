from core.db import DATABASE as db


class Task(db.Model):
    __tablename__ = "tasks"

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

    priority = db.Column(
        db.Integer,
        nullable=False,
        default=2
    )

    deadline_date = db.Column(
        db.Date,
        nullable=True,
        index=True
    )

    deadline_time = db.Column(
        db.Time,
        nullable=True
    )

    completed_at = db.Column(
        db.DateTime(timezone=True),
        nullable=True
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
        back_populates="tasks"
    )

from core.db import DATABASE as db


class Notification(db.Model):
    __tablename__ = "notifications"

    id = db.Column(
        db.Integer,
        primary_key=True
    )

    message = db.Column(
        db.String,
        nullable=False
    )

    type = db.Column(
        db.String,
        nullable=False
    )

    notify_at = db.Column(
        db.DateTime(timezone=True),
        nullable=False,
        index=True
    )

    is_read = db.Column(
        db.Boolean,
        nullable=False,
        default=False
    )

    target_type = db.Column(
        db.String,
        nullable=True
    )

    target_id = db.Column(
        db.Integer,
        nullable=True
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
        back_populates="notifications"
    )

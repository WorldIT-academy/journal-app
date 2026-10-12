from datetime import time

from core.db import DATABASE as db

from flask_login import UserMixin


class User(db.Model, UserMixin):
    __tablename__ = "users"
    
    id = db.Column(
        db.Integer,
        primary_key=True
    )
    
    email = db.Column(
        db.String,
        nullable=False,
        unique=True
    )
    
    password_hash = db.Column(
        db.String,
        nullable=False
    )
    
    first_name = db.Column(
        db.String,
        nullable=True
    )
    
    last_name = db.Column(
        db.String,
        nullable=True
    )
    
    avatar = db.Column(
        db.String,
        nullable=True
    )
    
    timezone = db.Column(
        db.String,
        nullable=False,
        default="Europe/Kyiv"
    )
    
    work_day_start = db.Column(
        db.Time,
        nullable=False,
        default=time(8, 0)
    )
    
    work_day_end = db.Column(
        db.Time,
        nullable=False,
        default=time(22, 0)
    )
    
    week_start = db.Column(
        db.Integer,
        nullable=False,
        default=1
    )
    
    categories = db.relationship(
        "Category",
        back_populates="user"
    )
    
    events = db.relationship(
        "Event",
        back_populates="user"
    )
    
    tasks = db.relationship(
        "Task",
        back_populates="user",
        cascade="all, delete-orphan"
    )
    
    habits = db.relationship(
        "Habit",
        back_populates="user",
        cascade="all, delete-orphan"
    )
    
    habit_entries = db.relationship(
        "HabitEntry",
        back_populates="user",
        cascade="all, delete-orphan"
    )
    
    notifications = db.relationship(
        "Notification",
        back_populates="user",
        cascade="all, delete-orphan"
    )

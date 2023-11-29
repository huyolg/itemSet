from pydantic import BaseModel
from typing import Optional
from fastapi import Body


class LoginModel(BaseModel):
    name: Optional[str] = Body(
        None, title="用户名", min_length=2, max_length=10, regex='^[A-Za-z0-9@#!$%^&*-_=+|]+$')
    password: Optional[str] = Body(
        None, title="密码", min_length=5, max_length=20, regex='^[A-Za-z0-9@#!$%^&*-_=+|]+$')

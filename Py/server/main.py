from fastapi import FastAPI, Request, Body
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from typing import Optional
from mysql import connector
import pymysql

from user import LoginModel
from validate import LoginModelValidate

app = FastAPI()

# name: Optional[str] = Body(None, title='用户名', max_length=10),
#           password: Optional[str] = Body(None, title='密码', max_length=10)


# 重写了RequestValidationError的 exception_handler方法
@app.exception_handler(RequestValidationError)
async def post_validation_exception_handler(request: Request, exc: RequestValidationError):

    """
    自定义异常处理
    :param request: Request的实例化对象
    :param exc: RequestValidationError的错误堆栈信息
    :return:
    """

    print(f'参数不对{request.method},{request.url}')
    err_list = exc.errors()
    err_msg = ['.'.join(error.get('loc')) + ':' + error.get('msg')
               for error in err_list]

    return JSONResponse({'code': 400, 'msg': err_msg})


@app.post('/login')
def login(model: LoginModel, request: Request):
    name = model.name
    password = model.password
    print(name)
    print(password)
    return {
        'success': True,
        'user': {
            'name': name,
            'password': password
        }
    }


@app.get('/version')
def readVersion():
    return {"version": "1.0.0"}


@app.get('/user/info/{usr_id}')
def readUserInfo(usr_id: int):
    return {
        "name": 'hd',
        "age": 26,
        "job": "IT dog",
        "user_id": usr_id
    }


if __name__ == "__main__":
    # import uvicorn
    # uvicorn.run(app="main:app", port=3333, workers=4)
    mydb = pymysql.connect(
        host="localhost",
        user="root",
        password="hudada@HUDADA1230",
        port=3306
    )
    cur = mydb.cursor()

    # sql = 'select * from score;'      # SQL语句

    # cur.execute(sql)  # 执行sql语句

    # sql_inset = 'INSERT into score(score,stduent_id) VALUE (10,10),(33,6),(66,25);'

    # cur.execute(sql_inset)

    # sql = 'update score SET score=200 where stduent_id=2;'
    # cur.execute(sql)+

    sql_show = 'show databases;'
    cur.execute(sql_show)
    hasUserDatabase = False
    for x in cur:
        database_name = x[0]
        if database_name == 'userInfo':
            hasUserDatabase = True
            break

    if hasUserDatabase == False:
        sql_create = 'create database userInfo;'
        cur.execute(sql_create)

    sql_create = 'use userInfo;'
    cur.execute(sql_create)

    cur.execute('create TABLE if not exists UserAccount(id int not null auto_increment, name VARCHAR(100) not null, email VARCHAR(100) not null, login_date DATE, PRIMARY KEY ( id )) engine=InnoDB;')
    userName = 'xiaolei'

    sql_search = '''select * from UserAccount where name="%s";''' % userName
    cur.execute(sql_search)
    res = cur.fetchall()
    if len(res) > 0:
        print(res)
        print('用户已存在')
    else:
        sql_insert = f'insert into UserAccount(name, email) values("{userName}", "{userName}");'
        cur.execute(sql_insert)
    cur.execute('select * from UserAccount;')

    data = cur.fetchall()

    mydb.commit()

    print(len(data))
    print(data)

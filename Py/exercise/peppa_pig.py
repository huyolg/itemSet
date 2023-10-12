from turtle import *


def setting():
    pensize(4)
    hideturtle()
    colormode(255)
    color((255, 155, 192), 'pink')
    setup(840, 500)
    speed(10)


def nose(x, y):
    penup()
    goto(x, y)
    pendown()
    # 设置乌龟移动方向 0-东 90-北 180-西 270-南
    seth(-30)
    begin_fill()
    a = 0.4


def main():
    setting()
    nose(-100, 100)


if __name__ == '__main__':
    main()

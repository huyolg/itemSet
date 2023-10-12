''' 猜数字 '''

from random import randint

answer = randint(0, 100)
count = 0
while True:
    num = int(input('输入你猜测的数字：'))
    count += 1
    if num == answer:
        print('恭喜你 猜中了')
        break
    elif num > answer:
        print('大了')
    elif num < answer:
        print('小了')


if count > 7:
    print('一共猜了 %d 次，智商不在线啊-' % count)
else:
    print('一共猜了 %d 次，智商刚刚的-' % count)

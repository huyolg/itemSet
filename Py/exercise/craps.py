"""
Craps赌博游戏
玩家摇两颗色子 如果第一次摇出7点或11点 玩家胜
如果摇出2点 3点 12点 庄家胜 其他情况游戏继续
玩家再次要色子 如果摇出7点 庄家胜
如果摇出第一次摇的点数 玩家胜
否则游戏继续 玩家继续摇色子
玩家进入游戏时有1000元的赌注 全部输光游戏结束
"""

from random import randint

money = 1000
while money > 0:
    print('你当前的资产：', money)
    need_go_on = False
    while True:
        debt = int(input('请下注：'))
        if 0 < debt <= money:
            break
    first = randint(1, 6) + randint(1, 6)
    print('你的点数是：', first)
    if first == 7 or first == 11:
        print('you win')
        money += debt
    elif first == 2 or first == 3 or first == 12:
        print('庄家赢')
        money -= debt
    else:
        need_go_on = True

    while need_go_on:
        current = randint(1, 6) + randint(1, 6)
        print('你的点数是：', current)
        if current == 7:
            print('庄家赢')
            money -= debt
            need_go_on = False
        elif current == first:
            print('you win')
            money += debt
            need_go_on = False

print('你破产了，快还钱~')

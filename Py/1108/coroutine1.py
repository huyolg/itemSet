from time import sleep
from random import random


def buid_deliver_main(man_id):
    total = 0
    while True:
        total += 1
        print('%d号快递员准备接今天的第%d单.' % (man_id, total))
        pkg = yield
        print('%d号快递员收到编号为%s的包裹.' % (man_id, pkg))
        sleep(random() * 3)
def package_center(deliver_man, max_per_day):
    num = 1
    deliver_man.send(None)
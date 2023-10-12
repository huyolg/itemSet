"""
1-100之间偶数和
"""

from math import sqrt
sum = 0
for x in range(0, 101, 2):
    sum += x
print('偶数和 = ', sum)


"""素数判断"""
print('****** 素数判断 ******')
num = int(input('输入一个正整数：'))
end = int(sqrt(num))
print(end)
is_prime = True
for x in range(2, end + 1):
    if num % x == 0:
        is_prime = False
        break
if is_prime and num != 1:
    print('%d 是素数' % num)
else:
    print('%d 不是素数' % num)


'''最小公倍数 最大公约数'''
print('****** 最小公约数 - 最大公倍数 ******')

x = int(input('x = '))
y = int(input('y = '))
if x > y:
    (x, y) = (y, x)
for i in range(x, 0, -1):
    if x % i == 0 and y % i == 0:
        print('%s 和 %s 的最小公约数 = ' % (x, y), i)
        print('%s 和 %s 的最大公倍数 = ' % (x, y), x * (y // i))
        break


"""
打印三角形
*
**
***
****
*****

    *
   **
  ***
 ****
*****

    *
   ***
  *****
 *******
*********
"""
row = int(input('输入行数：'))
for i in range(0, row):
    for _ in range(0, i + 1):
        print('*', end="")
    print('')

for i in range(0, row):
    for j in range(0, row):
        if j < row - i - 1:
            print(' ', end="")
        else:
            print('*', end="")
    print('')

for i in range(0, row):
    for _ in range(0, row - i - 1):
        print(' ', end="")
    for _ in range(0, 2 * i + 1):
        print('*', end="")
    print('')

'''
华氏温度 -> 摄氏温度
F = 1.8C + 32
'''

f = float(input('请输入华氏温度：'))
c = (f - 32) / 1.8
print('%.2f 华氏温度 = %.2f 设置温度' % (f, c))
'''
使用变量进行四则运算
'''
import sys


a = 12
b = 3
print(a + b)  # 15
print(a - b)  # 9
print(a * b)  # 36
print(a / b, type(a / b))  # 4.0 <class 'float'>

"""
使用内置函数进行转换
- `int()`：将一个数值或字符串转换成整数，可以指定进制。
- `float()`：将一个字符串转换成浮点数。
- `str()`：将指定的对象转换成字符串形式，可以指定编码。
- `chr()`：将整数转换成该编码对应的字符串（一个字符）。
- `ord()`：将字符串（一个字符）转换成对应的编码（整数）。
使用input()函数获取键盘输入(字符串)
"""
a1 = int(input('a = '))
b1 = int(input('b = '))
print('%d + %d = %d' % (a1, b1, a1 + b1))
print('%d - %d = %d' % (a1, b1, a1 - b1))
print('%d * %d = %d' % (a1, b1, a1 * b1))
print('%d / %d = %d' % (a1, b1, a1 / b1))
print('%d %% %d = %d' % (a1, b1, a1 % b1))
print('%d // %d = %d' % (a1, b1, a1 // b1))
print('%d ** %d = %d' % (a1, b1, a1 ** b1))

'''
运算符
| 运算符                                                       | 描述                           |
| ------------------------------------------------------------ | ------------------------------ |
| `[]` `[:]`                                                   | 下标，切片                     |
| `**`                                                         | 指数                           |
| `~` `+` `-`                                                  | 按位取反, 正负号               |
| `*` `/` `%` `//`                                             | 乘，除，模，整除               |
| `+` `-`                                                      | 加，减                         |
| `>>` `<<`                                                    | 右移，左移                     |
| `&`                                                          | 按位与                         |
| `^` `\|`                                                      | 按位异或，按位或               |
| `<=` `<` `>` `>=`                                            | 小于等于，小于，大于，大于等于 |
| `==` `!=`                                                    | 等于，不等于                   |
| `is`  `is not`                                               | 身份运算符                     |
| `in` `not in`                                                | 成员运算符                     |
| `not` `or` `and`                                             | 逻辑运算符                     |
| `=` `+=` `-=` `*=` `/=` `%=` `//=` `**=` `&=` `|=` `^=` `>>=` `<<=` | （复合）赋值运算符             |
'''
flag0 = 1 == 1
flag1 = 3 > 2
flag2 = 2 < 1
flag3 = flag1 and flag2
flag4 = flag1 or flag2
flag5 = not (1 != 2)
print('flag0 =', flag0)    # flag0 = True
print('flag1 =', flag1)    # flag1 = True
print('flag2 =', flag2)    # flag2 = False
print('flag3 =', flag3)    # flag3 = False
print('flag4 =', flag4)    # flag4 = True
print('flag5 =', flag5)    # flag5 = False


'''
循环
- `range(101)`：可以用来产生0到100范围的整数，需要注意的是取不到101。
- `range(1, 101)`：可以用来产生1到100范围的整数，相当于前面是闭区间后面是开区间。
- `range(1, 101, 2)`：可以用来产生1到100的奇数，其中2是步长，即每次数值递增的值。
- `range(100, 0, -2)`：可以用来产生100到1的偶数，其中-2是步长，即每次数字递减的值。
'''


'''
字符串
Python为字符串类型提供了非常丰富的运算符，我们可以使用`+`运算符来实现字符串的拼接，可以使用`*`运算符来重复一个字符串的内容，可以使用`in`和`not in`来判断一个字符串是否包含另外一个字符串（成员运算），我们也可以用`[]`和`[:]`运算符从字符串取出某个字符或某些字符（切片运算）
'''

s1 = 'hello ' * 3
print(s1)  # hello hello hello
s2 = 'world'
s1 += s2
print(s1)  # hello hello hello world
print('ll' in s1)  # True
print('good' in s1)  # False
str2 = 'abc123456'
# 从字符串中取出指定位置的字符(下标运算)
print(str2[2])  # c
# 字符串切片(从指定的开始索引到指定的结束索引)
print(str2[2:5])  # c12
print(str2[2:])  # c123456
print(str2[2::2])  # c246
print(str2[::2])  # ac246
print(str2[::-1])  # 654321cba
print(str2[-3:-1])  # 45


str1 = 'hello, world!'
# 通过内置函数len计算字符串的长度
print(len(str1))  # 13
# 获得字符串首字母大写的拷贝
print(str1.capitalize())  # Hello, world!
# 获得字符串每个单词首字母大写的拷贝
print(str1.title())  # Hello, World!
# 获得字符串变大写后的拷贝
print(str1.upper())  # HELLO, WORLD!
# 从字符串中查找子串所在位置
print(str1.find('or'))  # 8
print(str1.find('shit'))  # -1
# 与find类似但找不到子串时会引发异常
# print(str1.index('or'))
# print(str1.index('shit'))
# 检查字符串是否以指定的字符串开头
print(str1.startswith('He'))  # False
print(str1.startswith('hel'))  # True
# 检查字符串是否以指定的字符串结尾
print(str1.endswith('!'))  # True
# 将字符串以指定的宽度居中并在两侧填充指定的字符
print(str1.center(50, '*'))
# 将字符串以指定的宽度靠右放置左侧填充指定的字符
print(str1.rjust(50, ' '))
str2 = 'abc123456'
# 检查字符串是否由数字构成
print(str2.isdigit())  # False
# 检查字符串是否以字母构成
print(str2.isalpha())  # False
# 检查字符串是否以数字和字母构成
print(str2.isalnum())  # True
str3 = '  jackfrued@126.com '
print(str3)
# 获得字符串修剪左右两侧空格之后的拷贝
print(str3.strip())
print('-----------------------')

'''
数组
'''
print('-------数组----------------')

list1 = [1, 3, 5, 7, 100]
print(list1)  # [1, 3, 5, 7, 100]
# 乘号表示列表元素的重复
list2 = ['hello'] * 3
print(list2)  # ['hello', 'hello', 'hello']
# 计算列表长度(元素个数)
print(len(list1))  # 5
# 下标(索引)运算
print(list1[0])  # 1
print(list1[4])  # 100
# print(list1[5])  # IndexError: list index out of range
print(list1[-1])  # 100
print(list1[-3])  # 5
list1[2] = 300
print(list1)  # [1, 3, 300, 7, 100]
# 通过循环用下标遍历列表元素
for index in range(len(list1)):
    print(list1[index])
# 通过for循环遍历列表元素
for elem in list1:
    print(elem)
# 通过enumerate函数处理列表之后再遍历可以同时获得元素索引和值
for index, elem in enumerate(list1):
    print(index, elem)

'''
数组添加和移除元素

'''
list1 = [1, 3, 5, 7, 100]
# 添加元素
list1.append(200)
print(list1)
list1.insert(1, 400)
print(list1)
# 合并两个列表
# list1.extend([1000, 2000])
list1 += [1000, 2000]
print(list1)  # [1, 400, 3, 5, 7, 100, 200, 1000, 2000]
print(len(list1))  # 9
# 先通过成员运算判断元素是否在列表中，如果存在就删除该元素
if 3 in list1:
    list1.remove(3)
if 1234 in list1:
    list1.remove(1234)
print(list1)  # [1, 400, 5, 7, 100, 200, 1000, 2000]
# 从指定的位置删除元素
list1.pop(0)
list1.pop(len(list1) - 1)
print(list1)  # [400, 5, 7, 100, 200, 1000]
# 清空列表元素
list1.clear()
print(list1)  # []

'''
数组切片操作
'''

fruits = ['grape', 'apple', 'strawberry', 'waxberry']
fruits += ['pitaya', 'pear', 'mango']
# 列表切片
fruits2 = fruits[1:4]
print(fruits2)  # apple strawberry waxberry
# 可以通过完整切片操作来复制列表
fruits3 = fruits[:]
# ['grape', 'apple', 'strawberry', 'waxberry', 'pitaya', 'pear', 'mango']
print(fruits3)
fruits4 = fruits[-3:-1]
print(fruits4)  # ['pitaya', 'pear']
# 可以通过反向切片操作来获得倒转后的列表的拷贝
fruits5 = fruits[::-1]
# ['mango', 'pear', 'pitaya', 'waxberry', 'strawberry', 'apple', 'grape']
print(fruits5)
print('-----------------------')

'''
数组排序 sort
'''

list1 = ['orange', 'apple', 'zoo', 'internationalization', 'blueberry']
list2 = sorted(list1)
# sorted函数返回列表排序后的拷贝不会修改传入的列表
# 函数的设计就应该像sorted函数一样尽可能不产生副作用
list3 = sorted(list1, reverse=True)
# 通过key关键字参数指定根据字符串长度进行排序而不是默认的字母表顺序
list4 = sorted(list1, key=len)
print(list1)
print(list2)
print(list3)
print(list4)
# 给列表对象发出排序消息直接在列表对象上进行排序
list1.sort(reverse=True)
print(list1)
print('-----------------------')

'''列表生成式、生成器'''

f = [x for x in range(1, 10)]
print(f)
f = [x + y for x in 'ABCDE' for y in '1234567']
print(f)
# 用列表的生成表达式语法创建列表容器
# 用这种语法创建列表之后元素已经准备就绪所以需要耗费较多的内存空间
f = [x ** 2 for x in range(1, 100)]
print(sys.getsizeof(f))  # 查看对象占用内存的字节数
print(f)
# 请注意下面的代码创建的不是一个列表而是一个生成器对象
# 通过生成器可以获取到数据但它不占用额外的空间存储数据
# 每次需要数据的时候就通过内部的运算得到数据(需要花费额外的时间)
f = (x ** 2 for x in range(1, 100))
print(sys.getsizeof(f))  # 相比生成式生成器不占用存储数据的空间
print(f)
for val in f:
    print(val)
print('-----------------------')

'''
元组
'''
print('---------元组--------------')

t = ('nick name', 18, '地球')
# 获取元素
print(t[0])
t = ('nick name', 20, True, '上海')
print(t)
persion = list(t)
print(persion)
# 修改元素
persion[0] = 'xiaoming'
print(persion)

fruit_list = ['apple', 'orange', 'watermalen']
fruit_t = tuple(fruit_list)
print(fruit_t)
print('-----------------------')

'''集合'''
print('----------集合-------------')
set1 = {1, 2, 3, 3, 3, 2}
print(set1)
print('Length =', len(set1))
# 创建集合的构造器语法(面向对象部分会进行详细讲解)
set2 = set(range(1, 10))
set3 = set((1, 2, 3, 3, 2, 1))
print(set2, set3)
# 创建集合的推导式语法(推导式也可以用于推导集合)
set4 = {num for num in range(1, 100) if num % 3 == 0 or num % 5 == 0}
print(set4)

set1.add(4)
print('set1 = ', set1)
set1.update([111, 222])
print('set1 = ', set1)
set1.discard(111)
print('set1 = ', set1)
set1.remove(3)
print('set1 = ', set1)
print('set1 = ', set1.pop())
print('set1 = ', set1)

# 集合的交集、并集、差集、对称差运算
print(set1 & set2)
# print(set1.intersection(set2))
print(set1 | set2)
# print(set1.union(set2))
print(set1 - set2)
# print(set1.difference(set2))
print(set1 ^ set2)
# print(set1.symmetric_difference(set2))
# 判断子集和超集
print(set2 <= set1)
# print(set2.issubset(set1))
print(set3 <= set1)
# print(set3.issubset(set1))
print(set1 >= set2)
# print(set1.issuperset(set2))
print(set1 >= set3)
# print(set1.issuperset(set3))


'''字典'''
scores = {"xiaoming": 100, "lilei": 70, "hanmeimei": 15}
dic1 = dict(one=1, two=2, three=3)
dic2 = dict(zip(['a', 'b', 'c'], '123'))
print(dic1)
print(dic2)
dic3 = {num: num ** 2 for num in range(1, 10)}
print(dic3)
scores.update(gray=60)
print(scores)
# get方法也是通过键获取对应的值但是可以设置默认值
print(scores.get('gray', 60))
# 删除字典中的元素
print(scores.popitem())
print(scores.popitem())
print(scores.pop('xiaoming', 100))
# 清空字典
scores.clear()
print(scores)




stu = 
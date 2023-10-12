# from pywebio.input import *
# input("This is a simple text input")
# select("This is a drop down menu", ['Option1', 'Option2'])
# checkbox("Multiple Choices!", options=["a", 'b', 'c', 'd'])
# radio("Select any one", options=['1', '2', '3'])
# textarea('Text Area', rows=3, placeholder='Multiple line text input')

from pywebio.output import *
from pywebio import session
# 网页上显示纯文本
put_text("Hello friend!")
# 网页上显示表格
put_table([
    ['Object', 'Unit'],
    ['A', '55'],
    ['B', '73'],
])
# 网页上显示 MarkDown
put_markdown('~~PyWebIO~~')
# 网页上显示下载文件的链接
put_file('output_file.txt', b'You can put anything here')
# 网页上显示图片
put_image(open('python_logo.png', 'rb').read())
# 网页上显示弹窗
popup('popup title', 'popup text content')
# 保持回话是打开状态，否则页面显示完毕程序退出
session.hold()

import tkinter
from tkinter import ttk
from random import randint


class Guess(tkinter.Frame):
    def setTK(self):

        lab1 = tkinter.Label(self._tk, text='你猜的数字：')
        self.entry1 = tkinter.Entry(self._tk)

        self.tipsLab = tkinter.Label(self._tk)

        confirmBtn = tkinter.Button(
            self._tk, text='确定', command=self.handlerConfirm)

        lab1.grid(row=0)
        self.entry1.grid(row=0, column=1)
        confirmBtn.grid(row=0, column=2)
        self.tipsLab.grid(row=1, column=1)

        doneBtn = tkinter.Button(self._tk, text='我知道了')
        retryBtn = tkinter.Button(
            self._tk, text='再来一遍', command=self.handlerRetry)

        doneBtn.grid(row=3, column=1)
        retryBtn.grid(row=3, column=2)

    def changedIput(e):
        print(e)

    def handlerConfirm(self):
        text = self.entry1.get()

        guessNum = int(text)
        self.calc(guessNum)

    def handlerRetry(self):
        text = self.entry1.get()
        self._count = 0
        self._answer = randint(0, 100)
        self.entry1.delete(0, len(text))
        self.tipsLab['text'] = ''

    def calc(self, num):

        if num != self._gusNum:
            self._count += 1
        self._gusNum = num

        result = ''
        if num > self._answer:
            result = "猜大了"
            self.tipsLab['fg'] = 'red'
        elif num < self._answer:
            result = "猜小了"
            self.tipsLab['fg'] = 'red'
        else:
            result = "恭喜你，猜对了\n一共猜了 %s 次" % self._count
            self.tipsLab['fg'] = 'green'
        self.tipsLab['text'] = result

    def __init__(self, master=None):
        self._gusNum = -1
        self._tk = master
        self._answer = randint(0, 100)
        self._count = 0
        tkinter.Frame = master
        self.setTK()


tkWindow = tkinter.Tk()
# 窗口标题
tkWindow.title('猜数字')
# 窗口大小
screenWidth = tkWindow.winfo_screenwidth()
screenheight = tkWindow.winfo_screenheight()
w = 500
h = 400
x = 0  # (screenWidth - w) / 2
y = 0  # (screenheight - h) / 2
tkWindow.geometry("%dx%d+%d+%d" % (w, h, x, y))
app = Guess(master=tkWindow)


tkWindow.mainloop()

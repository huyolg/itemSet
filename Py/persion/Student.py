class Student(object):
    def __init__(self, name, age):
        self.name = name
        self.age = age

    def study(self, book):
        print('%s在学习%s' % self.name, book)

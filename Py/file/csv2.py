import csv
import codecs


class Student(object):
    def __init__(self, name, age, fov):
        self._name = name
        self._age = age
        self._fov = fov
        self._index = -1

    @property
    def age(self):
        return self._age

    @property
    def name(self):
        return self._name

    @property
    def fov(self):
        return self._fov


fileName = 'student.csv'
students = [Student('hanli', 188, 'xiulian'), Student('hanlei', 18, 'study')]

try:
    with open(fileName, 'w', encoding='utf-8') as f:
        f.write(codecs.BOM_UTF8.decode())
        writer = csv.writer(f)
        for item in students:
            writer.writerow([item.name, item.age, item.fov])
except BaseException as e:
    print('can not writer file: ', fileName, e)
else:
    print('save complete')

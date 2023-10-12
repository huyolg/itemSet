import csv

fileName = 'student.csv'

try:
    with open(fileName) as f:
        reader = csv.reader(f)
        data = list(reader)
except FileNotFoundError:
    print('can not opent file:', fileName)
else:
    for item in data:
        print('%-30s%-20s%-10s' % (item[0], item[1], item[2]))

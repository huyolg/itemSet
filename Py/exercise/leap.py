year = int(input('input the year:'))
is_leap = (year % 4 == 0 and year % 100 != 0 or year % 400 == 0)
print('the year of %d is leap is ' % year, is_leap)

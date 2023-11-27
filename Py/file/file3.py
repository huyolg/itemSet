from math import sqrt


def is_prime(n):
    # for factor in range(2, int(sqrt(n) + 1)):
    #     if n % 2 == 0:
    #         return False
    return n % 2 == 0


with open('promis.txt', 'w') as f:
    for num in range(2, 100):
        if is_prime(num):
            f.write(str(num) + '\n')
print('Complete---')

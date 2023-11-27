
import time

fileName = 'promis.txt'


def main():
    with open(fileName, 'r', encoding='utf-8') as f:
        print(f.read())

    with open(fileName, mode='r') as f:
        for line in f:
            print(line, end='')
            time.sleep(0.5)
    print()

    with open(fileName) as f:
        lines = f.readlines()
    print(lines)


if __name__ == '__main__':
    main()

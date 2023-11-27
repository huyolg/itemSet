'''
读写二进制
'''

import base64

with open('11.jpg', 'rb') as f:
    data = f.read()
    print('字节数 = ', len(data))
    print(data)
    print(type(data))
with open('14.jpg', 'wb') as f:
    f.write(data)
print('Complete')

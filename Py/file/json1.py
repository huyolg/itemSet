
import json
import csv2

json_str = '{"name": "专家", "age": 38, "fov": "能骗一个是一个"}'
result = json.loads(json_str)
print(result)

te = csv2.Student(**result)
print(te)
print(te.name)
print(te.fov)
print(te.age)

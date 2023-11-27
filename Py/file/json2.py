import json

person = {"name": "xiaoming", "fov": "movie", "gae": "18"}
person_str = json.dumps(person)
print(person_str, type(person_str))

fruits_list = ["apple", "orange", "banana"]
fruit_str = json.dumps(fruits_list)
print(fruit_str, type(fruit_str))

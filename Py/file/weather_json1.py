
from Weather import Weather

import json

json_str = 'weather.json'
with open(json_str, 'r') as f:
    weather_str = f.read()
    print(type(weather_str))

weather_model = json.loads(weather_str)
wea = Weather(**weather_model)
print(wea)
print(wea.yesterday)
print(wea.forecast[0].date)

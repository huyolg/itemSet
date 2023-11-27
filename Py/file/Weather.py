
"""
    {
        "wendu": "29",
        "ganmao": "各项气象条件适宜，发生感冒机率较低。但请避免长期处于空调房间中，以防感冒。",
        "forecast": [
            {
                "fengxiang": "南风",
                "fengli": "3-4级",
                "high": "高温 32℃",
                "type": "多云",
                "low": "低温 17℃",
                "date": "16日星期二"
            },
            {
                "fengxiang": "南风",
                "fengli": "微风级",
                "high": "高温 34℃",
                "type": "晴",
                "low": "低温 19℃",
                "date": "17日星期三"
            },
            {
                "fengxiang": "南风",
                "fengli": "微风级",
                "high": "高温 35℃",
                "type": "晴",
                "low": "低温 22℃",
                "date": "18日星期四"
            },
            {
                "fengxiang": "南风",
                "fengli": "微风级",
                "high": "高温 35℃",
                "type": "多云",
                "low": "低温 22℃",
                "date": "19日星期五"
            },
            {
                "fengxiang": "南风",
                "fengli": "3-4级",
                "high": "高温 34℃",
                "type": "晴",
                "low": "低温 21℃",
                "date": "20日星期六"
            }
        ],
        "yesterday": {
            "fl": "微风",
            "fx": "南风",
            "high": "高温 28℃",
            "type": "晴",
            "low": "低温 15℃",
            "date": "15日星期一"
        },
        "aqi": "72",
        "city": "北京"
    }
"""


class Forecast(object):
    def __init__(self, fengxiang, fengli, high, type, low, date):
        self.fengxiang = fengxiang
        self.fengli = fengli
        self.high = high
        self.type = type
        self.low = low
        self.date = date


class Weather(object):
    def __init__(self, wendu, ganmao, forecast, aqi, city, yesterday):
        self.__wendu = wendu
        self.__ganmao = ganmao

        self.__aqi = aqi
        self.__city = city
        self.__yesterday = yesterday
        casts = []
        for cast in forecast:
            cast_model = Forecast(**cast)
            casts.append(cast_model)
        self.__forecast = casts

    @property
    def wendu(self):
        return self.__wendu

    @property
    def ganmao(self):
        return self.__ganmao

    @property
    def forecast(self):
        return self.__forecast

    @property
    def aqi(self):
        return self.__aqi

    @property
    def city(self):
        return self.__city

    @property
    def yesterday(self):
        return self.__yesterday

class Persion (object):
  def __init__(self, name, age):
    self._name = name
    self._age = age

  @property
  def name(self):
    return self._name
  
  @property
  def age(self):
    return self._age
  
  def play(self, age):
    print('%s is playing' % self._name)


class Man(Persion):
  
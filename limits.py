from PySide6.QtCore import QObject, Signal, Property
from scipy.stats import poisson
import locale


class Limit(QObject):
    data_changed_changed = Signal()
    wait_changed = Signal()

    def __init__(self):
        QObject.__init__(self)

        locale.setlocale(locale.LC_ALL, '')

        self._background = "1"

        self._far = "0.0001"

        self._time = "1"

        self._limit = 0

        self._wait = False

        self._data_changed = True

    @property
    def background(self):
        return self._background

    @property
    def far(self):
        return self._far

    @property
    def time(self):
        return self._time

    @property
    def limit(self):
        return self._limit

    @background.setter
    def background(self, value):
        self._background = value

    @far.setter
    def far(self, value):
        self._far = value

    @time.setter
    def time(self, value):
        self._time = value

    @limit.setter
    def limit(self, value):
        self._limit = value

    @Property(bool, notify=data_changed_changed)
    def data_changed(self):
        return self._data_changed

    @data_changed.setter
    def data_changed(self, value):
        self._data_changed = value

    @Property(bool, notify=wait_changed)
    def wait(self):
        return self._wait

    def calculate(self):
        self._wait = True
        self.wait_changed.emit()

        prob = locale.atof(self._far) * locale.atof(self._time)
        prob_temp = 1
        mean = locale.atof(self._background) * locale.atof(self._time)
        k = int(mean)
        while prob_temp > prob:
            k = k + 1
            prob_temp = 0
            for j in range(k, 5000):
                prob_temp = prob_temp + poisson.pmf(j, mean)
        self._limit = k

        self._data_changed = True
        self.data_changed_changed.emit()

        self._wait = False
        self.wait_changed.emit()

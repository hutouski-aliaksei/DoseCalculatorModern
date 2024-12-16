from PySide6.QtCore import QObject, Signal, Property
import scipy.integrate as integrate
import locale


def profile(x, r, v, n):
    return 2 * ((n * (r ** 2)) / ((r ** 2) + (v * x) ** 2))


class Dynamic(QObject):
    data_changed_changed = Signal()

    def __init__(self):
        QObject.__init__(self)

        locale.setlocale(locale.LC_ALL, '')

        self._distance_1 = "1"
        self._distance_2 = "1"

        self._velocity_1 = "1"
        self._velocity_2 = "1"

        self._time_1 = "1"
        self._time_2 = "1"

        self._coefficient_1 = 1.0
        self._coefficient_2 = 1.0

        self._ratio = 1.0

        self.calculate()

        self._data_changed = True

    @property
    def distance_1(self):
        return self._distance_1

    @property
    def distance_2(self):
        return self._distance_2

    @property
    def velocity_1(self):
        return self._velocity_1

    @property
    def velocity_2(self):
        return self._velocity_2

    @property
    def time_1(self):
        return self._time_1

    @property
    def time_2(self):
        return self._time_2

    @property
    def coefficient_1(self):
        return self._coefficient_1

    @property
    def coefficient_2(self):
        return self._coefficient_2

    @property
    def ratio(self):
        return self._ratio

    @distance_1.setter
    def distance_1(self, value):
        self._distance_1 = value

    @distance_2.setter
    def distance_2(self, value):
        self._distance_2 = value

    @velocity_1.setter
    def velocity_1(self, value):
        self._velocity_1 = value

    @velocity_2.setter
    def velocity_2(self, value):
        self._velocity_2 = value

    @time_1.setter
    def time_1(self, value):
        self._time_1 = value

    @time_2.setter
    def time_2(self, value):
        self._time_2 = value

    @Property(bool, notify=data_changed_changed)
    def data_changed(self):
        return self._data_changed

    @data_changed.setter
    def data_changed(self, value):
        self._data_changed = value

    def calculate(self):
        self._coefficient_1 = integrate.quad(profile, 0, locale.atof(self._time_1) / 2,
                                             args=(locale.atof(self._distance_1), locale.atof(self._velocity_1), 1))[0]
        self._coefficient_1 = locale.atof(self._time_1) / self._coefficient_1

        self._coefficient_2 = integrate.quad(profile, 0, locale.atof(self._time_2) / 2,
                                             args=(locale.atof(self._distance_2), locale.atof(self._velocity_2), 1))[0]
        self._coefficient_2 = locale.atof(self._time_2) / self._coefficient_2

        if self._coefficient_2 != 0:
            self._ratio = ((self._coefficient_1 / self._coefficient_2) *
                           ((locale.atof(self._distance_2)**2) / (locale.atof(self._distance_1)**2)))

        self._data_changed = True
        self.data_changed_changed.emit()

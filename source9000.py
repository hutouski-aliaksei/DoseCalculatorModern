from PySide6.QtCore import QObject, Signal, Property
from datetime import *
import locale


def interpolation(x, y, m):
    if m < x[0]:
        delta_x = x[1] - x[0]
        delta_y = y[1] - y[0]
        delta_m = x[0] - m
        result = y[0] - (delta_y / delta_x) * delta_m
        return result
    if m > x[-1]:
        delta_x = x[-1] - x[-2]
        delta_y = y[-1] - y[-2]
        delta_m = m - x[0]
        result = y[-1] + (delta_y / delta_x) * delta_m
        return result
    else:
        for i in range(len(x) - 1):
            if m == x[i]:
                result = y[i]
                return result
            else:
                if x[i] < m < x[i + 1]:
                    delta_x = x[i + 1] - x[i]
                    delta_y = y[i + 1] - y[i]
                    delta_m = m - x[i]
                    result = y[i] + (delta_y / delta_x) * delta_m
                    return result


class Source9000(QObject):
    data_changed_changed = Signal()
    wait_changed = Signal()

    def __init__(self, db):
        QObject.__init__(self)

        locale.setlocale(locale.LC_ALL, '')
        self._db = db
        self._number = 0
        self._name = self._db.sources9000[self._number][2]
        self._serial = str(self._db.sources9000[self._number][1])
        self._prod_date = self._db.sources9000[self._number][3]
        self._cur_date = datetime.now().strftime('%m/%d/%Y')
        for item in self._db.halflife:
            if item[0] == self._name:
                self._halflife = item[1]
                break
        self._line = float(self._db.sources9000[self._number][4])
        self._points = self._db.read(self._serial, '')
        self._current_points = []
        self._distance = '100'
        self._offset = '0'

        self._material = 'Air'
        self._thickness = '0'
        self._coefficients = self._db.read('Materials', 'Air')
        self._attenuation_values = 0.0

        self._type = 'Ambient'
        self._der_coefficients = self._db.read('DoseConversionCoefficients', 'Ambient')

        self._dose_rate = '100'

        self._wait = False

        self.calculate()

        self._data_changed = True

    @property
    def name(self):
        return self._name

    @property
    def number(self):
        return self._number

    @property
    def serial(self):
        return self._serial

    @property
    def prod_date(self):
        return self._prod_date

    @property
    def cur_date(self):
        return self._cur_date

    @property
    def halflife(self):
        return self._halflife

    @property
    def line(self):
        return self._line

    @property
    def distance(self):
        return self._distance

    @property
    def offset(self):
        return self._offset

    @property
    def dose_rate(self):
        return self._dose_rate

    @property
    def material(self):
        return self._material

    @property
    def thickness(self):
        return self._thickness

    @property
    def coefficients(self):
        return self._coefficients

    @property
    def attenuation_values(self):
        return self._attenuation_values

    @property
    def type(self):
        return self._type

    @property
    def der_coefficients(self):
        return self._der_coefficients

    @property
    def points(self):
        return self._points

    @property
    def current_points(self):
        return self._current_points

    @name.setter
    def name(self, value):
        self._name = value

    @serial.setter
    def serial(self, value):
        self._serial = value

    @prod_date.setter
    def prod_date(self, value):
        self._prod_date = value

    @cur_date.setter
    def cur_date(self, value):
        self._cur_date = value

    @halflife.setter
    def halflife(self, value):
        self._halflife = value

    @line.setter
    def line(self, value):
        self._line = value

    @distance.setter
    def distance(self, value):
        self._distance = value

    @offset.setter
    def offset(self, value):
        self._offset = value

    @Property(bool, notify=data_changed_changed)
    def data_changed(self):
        return self._data_changed

    @Property(bool, notify=wait_changed)
    def wait(self):
        return self._wait

    @data_changed.setter
    def data_changed(self, value):
        self._data_changed = value

    @material.setter
    def material(self, value):
        self._material = value

    @thickness.setter
    def thickness(self, value):
        self._thickness = value

    @coefficients.setter
    def coefficients(self, value):
        self._coefficients = value

    @attenuation_values.setter
    def attenuation_values(self, value):
        self._attenuation_values = value

    @type.setter
    def type(self, value):
        self._type = value

    @der_coefficients.setter
    def der_coefficients(self, value):
        self._der_coefficients = value

    @dose_rate.setter
    def dose_rate(self, value):
        self._dose_rate = value

    def index_changed(self, index):
        self._number = index
        self._name = self._db.sources9000[self._number][2]
        self._serial = str(self._db.sources9000[self._number][1])
        self._prod_date = self._db.sources9000[self._number][3]
        self._cur_date = datetime.now().strftime('%m/%d/%Y')
        for item in self._db.halflife:
            if item[0] == self._name:
                self._halflife = item[1]
                break
        self._line = float(self._db.sources9000[self._number][4])
        self._points = self._db.read(self._serial, '')
        self._current_points = []

        self.calculate()

    def decay(self):
        p_d = datetime.strptime(self._prod_date, '%m/%d/%Y')
        c_d = datetime.strptime(self._cur_date, '%m/%d/%Y')
        delta = c_d - p_d
        decay_time = delta.days
        self._current_points = []
        for item in self._points:
            self._current_points.append([item[0], (item[1] * 2.718281828 ** (-(0.693 / self._halflife) * decay_time)) *
                                         self._attenuation_values])

    def der_search(self):
        temp = 10000
        point = []
        for item in self._current_points:
            if abs(locale.atof(self._distance) - locale.atof(self._offset) - item[0]) < temp:
                temp = abs(locale.atof(self._distance) - locale.atof(self._offset) - item[0])
                point = item

        self._dose_rate = str(round((point[1] / (((locale.atof(self._distance) - locale.atof(self._offset))**2) /
                                                 (point[0]**2))) * 1000, 3))

        self._data_changed = True
        self.data_changed_changed.emit()

    def line_dose_rate(self):
        temp_en = []
        temp_c = []
        for item in self._der_coefficients:
            temp_en.append(item[0])
            temp_c.append(item[1])

        temp = []
        for item in self._current_points:
            temp.append([item[0], item[1] * interpolation(temp_en, temp_c, self._line) * 3600])

        self._current_points = temp

    def calculate(self):
        self._coefficients = self._db.read('Materials', self._material)
        self._der_coefficients = self._db.read('DoseConversionCoefficients', self._type)
        self.attenuation()
        self.decay()
        self.line_dose_rate()
        self.distance_search()

        self._data_changed = True
        self.data_changed_changed.emit()

    def attenuation(self):
        temp_en = []
        temp_c = []
        for item in self._coefficients:
            temp_en.append(item[0])
            temp_c.append(item[1])
        self._attenuation_values = 2.718281828 ** (-locale.atof(self._thickness) *
                                                   interpolation(temp_en, temp_c, self._line))

    def distance_search(self):
        temp = 10000
        point = []
        for item in self._current_points:
            if abs((locale.atof(self._dose_rate) / 1000) - item[1]) < temp:
                temp = abs((locale.atof(self._dose_rate) / 1000) - item[1])
                point = item

        self._distance = str(round(point[0] * (point[1] / (locale.atof(self._dose_rate) / 1000))**0.5, 3))

        temp = 10000
        point = []
        for item in self._current_points:
            if abs(locale.atof(self._distance) - item[0]) < temp:
                temp = abs(locale.atof(self._distance) - item[0])
                point = item

        self._distance = str(round(point[0] * (point[1] / (locale.atof(self._dose_rate) / 1000)) ** 0.5 +
                             locale.atof(self._offset), 3))

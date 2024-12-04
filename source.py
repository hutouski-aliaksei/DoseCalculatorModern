from PySide6.QtCore import QObject, Signal, Property
import numpy as np
from scipy import interpolate
from datetime import *


class Source(QObject):
    data_changed_changed = Signal()

    def __init__(self, db):
        QObject.__init__(self)

        self._db = db
        self._number = 0
        self._name = self._db.sources[self._number][1]
        self._serial = str(self._db.sources[self._number][2])
        self._prod_date = self._db.sources[self._number][3]
        self._cur_date = datetime.now().strftime('%m/%d/%Y')
        self._original_activity = round(self._db.sources[self._number][4])
        for item in self._db.halflife:
            if item[0] == self._name:
                self._halflife = item[1]
                break
        self._lines = self._db.read('Lines', self._name)
        self._distance = '10.0'

        self._material = 'Air'
        self._thickness = '0.0'
        self._coefficients = self._db.read('Materials', 'Air')
        self._attenuation_values = []

        self._air_thickness = float(self._distance) - float(self._thickness)
        self._air_coefficients = self._db.read('Materials', 'Air')
        self._air_attenuation_values = []

        self._type = 'Ambient'
        self._der_coefficients = self._db.read('DoseConversionCoefficients', 'Ambient')
        self._kerma_coeffs = self._db.read('DoseConversionCoefficients', 'Kerma')

        self._current_activity = 0
        self._flux = []
        self._kerma_rate = []
        self._dose_rate = []

        self._sum_flux = 0
        self._sum_dose_rate = 0

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
    def original_activity(self):
        return self._original_activity

    @property
    def halflife(self):
        return self._halflife

    @property
    def lines(self):
        return self._lines

    @property
    def distance(self):
        return self._distance

    @property
    def kerma_rate(self):
        return self._kerma_rate

    @property
    def flux(self):
        return self._flux

    @property
    def dose_rate(self):
        return self._dose_rate

    @property
    def current_activity(self):
        return self._current_activity

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
    def air_thickness(self):
        return self._air_thickness

    @property
    def air_coefficients(self):
        return self._air_coefficients

    @property
    def air_attenuation_values(self):
        return self._air_attenuation_values

    @property
    def type(self):
        return self._type

    @property
    def der_coefficients(self):
        return self._der_coefficients

    @property
    def kerma_koeffs(self):
        return self._kerma_coeffs

    @property
    def sum_flux(self):
        return self._sum_flux

    @property
    def sum_dose_rate(self):
        return self._sum_dose_rate

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

    @original_activity.setter
    def original_activity(self, value):
        self._original_activity = value

    @halflife.setter
    def halflife(self, value):
        self._halflife = value

    @lines.setter
    def lines(self, value):
        self._lines = value

    @distance.setter
    def distance(self, value):
        self._distance = value

    @current_activity.setter
    def current_activity(self, value):
        self._current_activity = value

    @Property(bool, notify=data_changed_changed)
    def data_changed(self):
        return self._data_changed

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

    @air_thickness.setter
    def air_thickness(self, value):
        self._air_thickness = value

    @air_coefficients.setter
    def air_coefficients(self, value):
        self._air_coefficients = value

    @air_attenuation_values.setter
    def air_attenuation_values(self, value):
        self._air_attenuation_values = value

    @type.setter
    def type(self, value):
        self._type = value

    @der_coefficients.setter
    def der_coefficients(self, value):
        self._der_coefficients = value

    @kerma_koeffs.setter
    def kerma_koeffs(self, value):
        self._kerma_coeffs = value

    def index_changed(self, index):
        self._number = index
        self._name = self._db.sources[self._number][1]
        self._serial = str(self._db.sources[self._number][2])
        self._prod_date = self._db.sources[self._number][3]
        self._cur_date = datetime.now().strftime('%m/%d/%Y')
        self._original_activity = round(self._db.sources[self._number][4])
        for item in self._db.halflife:
            if item[0] == self._name:
                self._halflife = item[1]
                break
        self._lines = self._db.read('Lines', self._name)
        self._current_activity = 0

        self.decay()
        self.calculate()

    def parameters_changed(self):
        for item in self._db.halflife:
            if item[0] == self._name:
                self._halflife = item[1]
                break
        self._lines = self._db.read('Lines', self._name)

        self.decay()
        self.calculate()

    def decay(self):
        p_d = datetime.strptime(self._prod_date, '%m/%d/%Y')
        c_d = datetime.strptime(self._cur_date, '%m/%d/%Y')
        delta = c_d - p_d
        decay_time = delta.days
        current_activity = round(self._original_activity * np.exp(-(0.693 / self._halflife) * decay_time))
        self._current_activity = current_activity

    def line_kerma_rate(self):
        kerma_rate = []
        temp_en = []
        temp_c = []
        for item in self._kerma_coeffs:
            temp_en.append(item[0])
            temp_c.append(item[1])
        kerma_interpolated = interpolate.interp1d(temp_en, temp_c, fill_value='extrapolate')

        for i in range(len(self._lines)):
            kerma_value = kerma_interpolated(self._lines[i][0]) * 3600
            kerma_rate.append(kerma_value * self._flux[i])
        self._kerma_rate = kerma_rate

    def line_flux(self):
        s_a = np.arcsin(np.sin(0.5 / float(self._distance)) ** 2) / np.pi
        flux = []

        for i in range(len(self._lines)):
            flux.append((self._lines[i][1] / 100) * self._current_activity * s_a * self._attenuation_values[i] *
                        self._air_attenuation_values[i])
        self._flux = flux

    def line_dose_rate(self):
        d_r = []
        temp_en = []
        temp_c = []
        for item in self._der_coefficients:
            temp_en.append(item[0])
            temp_c.append(item[1])
        h_interpolated = interpolate.interp1d(temp_en, temp_c, fill_value='extrapolate')

        for i in range(len(self._lines)):
            d_r.append(self._kerma_rate[i] * h_interpolated(self._lines[i][0]))
        self._dose_rate = d_r

    def calculate(self):
        self._air_thickness = float(self._distance) - float(self._thickness)
        self._coefficients = self._db.read('Materials', self._material)
        self._der_coefficients = self._db.read('DoseConversionCoefficients', self._type)
        self.attenuation()
        self.line_flux()
        self.line_kerma_rate()
        self.line_dose_rate()

        self._sum_flux = float(sum(self._flux))
        self._sum_dose_rate = float(sum(self._dose_rate))

        self._data_changed = True
        self.data_changed_changed.emit()

    def attenuation(self):
        attenuation_values = []
        temp_en = []
        temp_c = []
        for item in self._coefficients:
            temp_en.append(item[0])
            temp_c.append(item[1])
        attenuation_interpolated = interpolate.interp1d(temp_en, temp_c, fill_value='extrapolate')
        for item in self._lines:
            attenuation_values.append(np.exp(-float(self._thickness) * attenuation_interpolated(item[0])))
        self._attenuation_values = attenuation_values

        attenuation_values = []
        temp_en = []
        temp_c = []
        for item in self._air_coefficients:
            temp_en.append(item[0])
            temp_c.append(item[1])
        attenuation_interpolated = interpolate.interp1d(temp_en, temp_c, fill_value='extrapolate')
        for item in self._lines:
            attenuation_values.append(np.exp(-self._air_thickness * attenuation_interpolated(item[0])))
        self._air_attenuation_values = attenuation_values

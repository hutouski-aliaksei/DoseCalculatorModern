from PySide6.QtCore import QObject, Signal, Property
import numpy as np
from scipy import interpolate
from datetime import *
from database import Database


class Source(QObject):
    data_changed_changed = Signal()

    def __init__(self, database, number, distance):
        QObject.__init__(self)

        self._db = Database('DoseCalculator_DB.db')

        self._name = self._db.sources[number][1]
        self._number = number
        self._serial = str(self._db.sources[number][2])
        self._prod_date = self._db.sources[number][3]
        self._cur_date = datetime.now().strftime('%m/%d/%Y')
        self._original_activity = round(self._db.sources[number][4])
        for item in self._db.halflife:
            if item[0] == self._name:
                self._halflife = item[1]
                break
        self._lines = self._db.read('Lines', self._name)
        self._distance = distance
        self._current_activity = 0
        self.decay()
        self._flux = []
        self._kerma_rate = []
        self._dose_rate = []

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
        self._flux = []
        self._kerma_rate = []
        self._dose_rate = []

        self._data_changed = True
        self.data_changed_changed.emit()

    def decay(self):
        p_d = datetime.strptime(self._prod_date, '%m/%d/%Y')
        c_d = datetime.strptime(self._cur_date, '%m/%d/%Y')
        delta = c_d - p_d
        decay_time = delta.days
        current_activity = round(self._original_activity * np.exp(-(0.693 / self._halflife) * decay_time))
        self._current_activity = current_activity

    def line_kerma_rate(self, dose_type):
        kerma_interpolated = interpolate.interp1d(dose_type.kerma_coeffs[:, 0], dose_type.kerma_coeffs[:, 1], fill_value='extrapolate')
        kerma_value = kerma_interpolated(self._lines[:, 0]) * 3600
        kerma_rate = kerma_value * self._flux
        self._kerma_rate = kerma_rate

    def line_flux(self, shield, air_shield):
        s_a = np.arcsin(np.sin(0.5 / self._distance) ** 2) / np.pi
        flux = (self._lines[:, 1] / 100) * self._current_activity * s_a * shield.attenuation_values * air_shield.attenuation_values
        self._flux = flux
               # attenuation(att_coeff_air, energy, distance_cm - thickness_cm) * \
               # attenuation(att_coeff_material, energy, thickness_cm)

    def line_dose_rate(self, dose_type):
        h10_interpolated = interpolate.interp1d(dose_type.coefficients[:, 0], dose_type.coefficients[:, 1], fill_value='extrapolate')
        d_r = self._kerma_rate * h10_interpolated(self._lines[:, 0])
        self._dose_rate = d_r
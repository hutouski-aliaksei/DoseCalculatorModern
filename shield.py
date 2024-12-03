from PySide6.QtCore import QObject, Signal, Property
import numpy as np
from scipy import interpolate


class Shield(QObject):
    def __init__(self, material, thickness, coefficients):
        QObject.__init__(self)
        self._material = material
        self._thickness = thickness
        self._coefficients = coefficients
        self._attenuation_values = []

    @property
    def coefficients(self):
        return self._coefficients

    @property
    def thickness(self):
        return self._thickness

    @property
    def material(self):
        return self._material

    @property
    def attenuation_values(self):
        return self._attenuation_values

    @coefficients.setter
    def coefficients(self, value):
        self._coefficients = value

    @thickness.setter
    def thickness(self, value):
        self._thickness = value

    @material.setter
    def material(self, value):
        self._material = value

    def attenuation(self, energy):
        attenuation_interpolated = interpolate.interp1d(self._coefficients[:, 0], self._coefficients[:, 1],
                                                        fill_value='extrapolate')
        attenuation_values = np.exp(-self._thickness * attenuation_interpolated(energy))
        self._attenuation_values = attenuation_values

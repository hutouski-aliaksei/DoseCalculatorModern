from PySide6.QtCore import QObject, Signal, Property


class DoseType(QObject):
    def __init__(self, type, coefficients, kerma_coeffs):
        QObject.__init__(self)
        self._type = type
        self._coefficients = coefficients
        self._kerma_coeffs = kerma_coeffs

    @property
    def coefficients(self):
        return self._coefficients

    @property
    def type(self):
        return self._type

    @property
    def kerma_coeffs(self):
        return self._kerma_coeffs

    @coefficients.setter
    def coefficients(self, value):
        self._coefficients = value

    @type.setter
    def type(self, value):
        self._type = value
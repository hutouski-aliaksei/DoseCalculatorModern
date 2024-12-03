from PySide6.QtWidgets import QApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, Property, QPoint
from PySide6.QtGui import QIcon
import sys
import qml_rc
import datetime
from database import Database
from source import Source
from shield import Shield
from dosetype import DoseType


class Bridge(QObject):
    view_array_changed = Signal()
    view_table_changed = Signal()
    catalogue_changed = Signal()
    isotope_list_changed = Signal()
    shields_list_changed = Signal()

    def __init__(self):
        QObject.__init__(self)
        self._view_array = []
        self._view_table = []
        self._catalogue = []
        self._isotope_list = []
        self._shields_list = []
        self._dose_types = ["Ambient", "Personal"]

        self._db = Database('DoseCalculator_DB.db')
        self._source = Source(self._db, 0, 10)
        self._airshield = Shield('Air', self._source.distance, self._db.read('Materials', 'Air'))
        self._shield = Shield('Air', 0, self._db.read('Materials', 'Air'))
        self._dose_t = DoseType('Ambient', self._db.read('DoseConversionCoefficients', 'Ambient'),
                                self._db.read('DoseConversionCoefficients', 'Kerma'))

        self._source.data_changed_changed.connect(self.source_data_changed)

        temp = []

        for item in self._db.halflife:
            temp.append(item[0])

        self._isotope_list = temp

        temp = []

        for item in self._db.sources:
            temp.append(f'{item[1]}\t{item[2]}')

        self._catalogue = temp

        self._shields_list = self._db.materials

        self.source_data_changed()

    @Property(list, notify=view_array_changed)
    def view_array(self):
        return self._view_array

    @view_array.setter
    def view_array(self, value):
        self._view_array = value

    @Property(list, notify=view_table_changed)
    def view_table(self):
        return self._view_table

    @Property(list, notify=catalogue_changed)
    def catalogue(self):
        return self._catalogue

    @Property(list, notify=shields_list_changed)
    def shields_list(self):
        return self._shields_list

    @Property(list, notify=isotope_list_changed)
    def isotope_list(self):
        return self._isotope_list

    def __setattr__(self, name, value):
        match name:
            case '_view_array':
                super().__setattr__(name, value)
                print(self._view_array)
                self.view_array_changed.emit()
            case '_view_table':
                super().__setattr__(name, value)
                self.view_table_changed.emit()
            case '_isotope_list':
                super().__setattr__(name, value)
                self.isotope_list_changed.emit()
            case '_catalogue':
                super().__setattr__(name, value)
                self.catalogue_changed.emit()
            case '_shields_list':
                super().__setattr__(name, value)
                self.shields_list_changed.emit()
            case _:
                super().__setattr__(name, value)

    def source_data_changed(self):
        temp = [self._source.number, self._source.name, self._source.halflife, self._source.prod_date, self._source.original_activity,
                self._source.cur_date, self._source.current_activity, self._shield.material, self._shield.thickness,
                self._source.distance, self._dose_t.type]
        self._view_array = temp

    @Slot(int)
    def on_source_changed(self, index):
        self._source.index_changed(index)

def run_app():
    app = QApplication(sys.argv)
    engine = QQmlApplicationEngine()
#    app.setWindowIcon(QIcon('icon.ico'))

    bridge = Bridge()

    engine.rootContext().setContextProperty('bridge', bridge)

    engine.load("qrc:/main.qml")

    if not engine.rootObjects():
        return -1

    return app.exec()

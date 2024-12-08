from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, Property
from PySide6.QtGui import QIcon, QGuiApplication
import sys
import qml_rc
from database import Database
from source import Source
import locale


class Bridge(QObject):
    view_array_changed = Signal()
    view_table_changed = Signal()
    catalogue_changed = Signal()
    isotope_list_changed = Signal()
    shields_list_changed = Signal()
    dose_types_changed = Signal()

    def __init__(self):
        QObject.__init__(self)
        locale.setlocale(locale.LC_ALL, '')

        self._view_array = []
        self._view_table = []
        self._catalogue = []
        self._isotope_list = []
        self._shields_list = []
        self._dose_types = ["Ambient", "Personal"]

        self._db = Database('DoseCalculator_DB.db')
        self._source = Source(self._db)

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

    @Property(list, notify=dose_types_changed)
    def dose_types(self):
        return self._dose_types

    def __setattr__(self, name, value):
        match name:
            case '_view_array':
                super().__setattr__(name, value)
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
        temp = [self._source.number, self._source.name, self._source.halflife, self._source.prod_date,
                self._source.original_activity, self._source.cur_date, self._source.current_activity,
                self._source.material, self._source.thickness, self._source.distance, self._source.type,
                self._source.sum_flux, self._source.sum_dose_rate]
        self._view_array = temp

        temp = []
        for i in range(len(self._source.lines)):
            temp.append(f'{round(self._source.lines[i][0]*1000, 3)}\t\t{self._source.lines[i][1]}\t\t{round(self._source.kerma_rate[i], 3)}\t\t'
                        f'{round(self._source.dose_rate[i], 3)}\t\t{round(self._source.flux[i], 3)}')
        self._view_table = temp

    @Slot(int)
    def on_source_changed(self, index):
        self._source.index_changed(index)

    @Slot(str)
    def on_action(self, action):
        match action:
            case "source":
                self._source.name = self._view_array[1]
                self._source.prod_date = self._view_array[3]
                self._source.original_activity = int(self._view_array[4])
                self._source.cur_date = self._view_array[5]
                self._source.current_activity = int(self._view_array[6])

                self._source.parameters_changed()
            case "activity":
                self._source.current_activity = int(self._view_array[6])
                self._source.material = self._view_array[7]
                self._source.thickness = self._view_array[8]
                self._source.distance = self._view_array[9]
                self._source.type = self._view_array[10]
                self._source.calculate()
            case "der":
                self._source.sum_dose_rate = locale.atof(self._view_array[12])
                self._source.reverse_calculation()



def run_app():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    app.setWindowIcon(QIcon('icon.ico'))

    bridge = Bridge()

    engine.rootContext().setContextProperty('bridge', bridge)

    engine.load("qrc:/main.qml")

    if not engine.rootObjects():
        return -1

    return app.exec()

from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, Property
from PySide6.QtGui import QIcon, QGuiApplication
import sys
import qml_rc
from database import Database
from source import Source
import locale
import threading
from dynamic import Dynamic
from limits import Limit


class Bridge(QObject):
    view_array_changed = Signal()
    view_table_changed = Signal()
    catalogue_changed = Signal()
    isotope_list_changed = Signal()
    shields_list_changed = Signal()
    dose_types_changed = Signal()
    wait_changed = Signal()
    view_dynamic_changed = Signal()

    def __init__(self):
        QObject.__init__(self)
        locale.setlocale(locale.LC_ALL, '')

        self._wait = False
        self._view_array = []
        self._view_table = []
        self._catalogue = []
        self._isotope_list = []
        self._shields_list = []
        self._dose_types = ["Ambient", "Personal"]

        self._view_dynamic = []

        self._db = Database('DoseCalculator_DB.db')
        self._source = Source(self._db)

        self._dynamic = Dynamic()
        self._limit = Limit()

        self._source.data_changed_changed.connect(self.source_data_changed)
        self._source.wait_changed.connect(self.wait_value_changed)
        self._dynamic.data_changed_changed.connect(self.dynamic_data_changed)
        self._limit.wait_changed.connect(self.wait_value_changed)
        self._limit.data_changed_changed.connect(self.dynamic_data_changed)

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
        self.dynamic_data_changed()

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

    @Property(bool, notify=wait_changed)
    def wait(self):
        return self._wait

    @Property(list, notify=view_dynamic_changed)
    def view_dynamic(self):
        return self._view_dynamic

    @view_dynamic.setter
    def view_dynamic(self, value):
        self._view_dynamic = value

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
            case '_wait':
                super().__setattr__(name, value)
                self.wait_changed.emit()
            case '_view_dynamic':
                super().__setattr__(name, value)
                self.view_dynamic_changed.emit()
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

    def dynamic_data_changed(self):
        temp = [self._dynamic.distance_1, self._dynamic.distance_2, self._dynamic.velocity_1, self._dynamic.velocity_2,
                self._dynamic.time_1, self._dynamic.time_2, self._dynamic.coefficient_1, self._dynamic.coefficient_2,
                self._dynamic.ratio, self._limit.background, self._limit.far, self._limit.time, self._limit.limit]
        self._view_dynamic = temp

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
                calc_thread = threading.Thread(target=self._source.reverse_calculation)
                calc_thread.daemon = True
                calc_thread.start()
            case "dynamic":
                self._dynamic.distance_1 = self._view_dynamic[0]
                self._dynamic.distance_2 = self._view_dynamic[1]
                self._dynamic.velocity_1 = self._view_dynamic[2]
                self._dynamic.velocity_2 = self._view_dynamic[3]
                self._dynamic.time_1 = self._view_dynamic[4]
                self._dynamic.time_2 = self._view_dynamic[5]
                self._dynamic.calculate()
            case "limit":
                self._limit.background = self._view_dynamic[9]
                self._limit.far = self._view_dynamic[10]
                self._limit.time = self._view_dynamic[11]
                limit_thread = threading.Thread(target=self._limit.calculate)
                limit_thread.daemon = True
                limit_thread.start()

    def wait_value_changed(self):
        self._wait = self._source.wait or self._limit.wait


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

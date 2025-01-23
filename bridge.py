from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QObject, Slot, Signal, Property
from PySide6.QtGui import QIcon, QGuiApplication
import sys
import sqlite3
import qml_rc
from database import Database
from source import Source
from source9000 import Source9000
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
    db_exists_changed = Signal()
    view_array9000_changed = Signal()
    view_table9000_changed = Signal()
    catalogue9000_changed = Signal()

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

        self._catalogue9000 = []
        self._view_array9000 = []
        self._view_table9000 = []

        self._view_dynamic = []
        self._db_exists = True

        self._dynamic = Dynamic()
        self._limit = Limit()

        self._dynamic.data_changed_changed.connect(self.dynamic_data_changed)
        self._limit.wait_changed.connect(self.wait_value_changed)
        self._limit.data_changed_changed.connect(self.dynamic_data_changed)

        self.dynamic_data_changed()

        try:
            self._db = Database('DoseCalculator_DB.db')
            self._source = Source(self._db)
            self._source9000 = Source9000(self._db)

            self._source.data_changed_changed.connect(self.source_data_changed)
            self._source.wait_changed.connect(self.wait_value_changed)
            self._source9000.data_changed_changed.connect(self.source9000_data_changed)

            temp = []

            for item in self._db.halflife:
                temp.append(item[0])

            self._isotope_list = temp

            temp = []

            for item in self._db.sources:
                temp.append(f'{item[1]}\t{item[2]}')

            self._catalogue = temp

            temp = []

            for item in self._db.sources9000:
                temp.append(f'{item[1]}')

            self._catalogue9000 = temp

            self._shields_list = self._db.materials

            self.source_data_changed()
            self.source9000_data_changed()
        except sqlite3.OperationalError:
            self._db_exists = False

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

    @Property(bool, notify=db_exists_changed)
    def db_exists(self):
        return self._db_exists

    @Property(list, notify=view_array9000_changed)
    def view_array9000(self):
        return self._view_array9000

    @view_array9000.setter
    def view_array9000(self, value):
        self._view_array9000 = value

    @Property(list, notify=view_table9000_changed)
    def view_table9000(self):
        return self._view_table9000

    @Property(list, notify=catalogue9000_changed)
    def catalogue9000(self):
        return self._catalogue9000

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
            case '_db_exists':
                super().__setattr__(name, value)
                self.db_exists_changed.emit()
            case '_view_array9000':
                super().__setattr__(name, value)
                self.view_array9000_changed.emit()
            case '_view_table9000':
                super().__setattr__(name, value)
                self.view_table9000_changed.emit()
            case '_catalogue9000':
                super().__setattr__(name, value)
                self.catalogue9000_changed.emit()
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
                self._dynamic.ratio, self._limit.background, self._limit.far, self._limit.time, self._limit.limit,
                self._limit.max_limit, ', '.join(['{:.2f}'.format(x) for x in self._limit.bckgr_cps])]
        self._view_dynamic = temp

    def source9000_data_changed(self):
        temp = [self._source9000.number, self._source9000.name, self._source9000.halflife, self._source9000.prod_date,
                self._source9000.cur_date, self._source9000.material, self._source9000.thickness,
                self._source9000.distance, self._source9000.type, self._source9000.dose_rate]
        self._view_array9000 = temp

        temp = []
        for i in range(len(self._source9000.points)):
            temp.append(
                f'{self._source9000.points[i][0]}\t\t\t{self._source9000.points[i][1]}\t\t\t' +
                '{:e}'.format(self._source9000.current_points[i][1]))
        self._view_table9000 = temp

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
            case "reverse_limit":
                self._limit.far = self._view_dynamic[10]
                self._limit.time = self._view_dynamic[11]
                self._limit.max_limit = self._view_dynamic[13]
                limit_thread = threading.Thread(target=self._limit.calculate_reverse)
                limit_thread.daemon = True
                limit_thread.start()
            case "parameters9000":
                self._source9000.cur_date = self._view_array9000[4]
                self._source9000.material = self._view_array9000[5]
                self._source9000.thickness = self._view_array9000[6]
                self._source9000.type = self._view_array9000[8]
                self._source9000.dose_rate = self._view_array9000[9]
                self._source9000.calculate()
            case "der9000":
                self._source9000.distance = self._view_array9000[7]
                self._source9000.der_search()
            case _:
                if int(action) < 10000:
                    self._source.index_changed(int(action))
                else:
                    self._source9000.index_changed(int(action)-10000)

    def wait_value_changed(self):
        if self._db_exists:
            self._wait = self._source.wait or self._limit.wait
        else:
            self._wait = self._limit.wait


def run_app():
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()
    app.setWindowIcon(QIcon('img/icon.ico'))

    bridge = Bridge()

    engine.rootContext().setContextProperty('bridge', bridge)

    engine.load("qrc:/qml/main.qml")

    if not engine.rootObjects():
        return -1

    return app.exec()

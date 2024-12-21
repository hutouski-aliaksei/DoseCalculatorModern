import sqlite3 as sq


class Database:
    def __init__(self, name):
        self._name = name
        con = sq.connect(self._name)
        self._cur = con.cursor()
        self._sources = self.read('Sources', '')
        self._halflife = self.read('Halflife', '')
        self._materials = self.read('Columns', '')

    @property
    def sources(self):
        return self._sources

    @property
    def halflife(self):
        return self._halflife

    @property
    def materials(self):
        return self._materials

    def read(self, table, name):
        data = []
        if table in ['DoseConversionCoefficients', 'Materials']:
            res = self._cur.execute(f"select energy, {name} from {table} where {name} is not null order by energy asc")
            data = res.fetchall()
            # data = np.array(data)
        elif table == 'Sources':
            res = self._cur.execute(f"select * from {table} order by id asc")
            data = res.fetchall()
            # data = pd.DataFrame(data)
            # data.columns = ['Number', 'Isotope', 'SourceNumber', 'ProductionDate', 'OriginalActivity_Bq']
        elif table == 'Halflife':
            res = self._cur.execute(f"select * from {table} order by Isotope asc")
            data = res.fetchall()
            # data = pd.DataFrame(data)
            # data.columns = ['Isotope', 'Half_life_d']
        elif table == 'Lines':
            res = self._cur.execute(f"select energy, yield from {table} where isotope = '{name}' order by energy asc")
            data = res.fetchall()
            # data = np.array(data)
        elif table == 'Columns':
            res = self._cur.execute("select name from pragma_table_info('Materials')")
            data = res.fetchall()
            data.pop(0)
            temp = []
            for item in data:
                temp.append(item[0])
            data = temp
        return data

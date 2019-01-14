import tkinter as tk
import math as m


class Osnove:
    def __init__(self):
        self.kolicina = ''
        self.enote = ['']
        self.vrednost = 0
        self.kolicine = {
            'masa': ['mg', 'cg', 'dg', 'g', 'dag', 'hg', 'kg', 't', 'oz', 'lb', 'st', 'tn', 'l.t.'],
            'dolžina': ['nm', 'μm', 'mm', 'cm', 'in', 'dm', 'ft', 'yd', 'm', 'km', 'mi', 'n.m.'],
            'ploščina': ['mm^2', 'cm^2', 'dm^2', 'm^2', 'a', 'ha', 'km^2'],
            'volumen': ['mm^3', 'cm^3', 'dm^3', 'm^3', 'ml', 'cl', 'dl', 'l', 'hl'],
            'energija': ['mJ', 'cJ', 'dJ', 'J', 'daJ', 'hJ', 'kJ', 'MJ'],
            'koti v ravnini': ['kotne sekunde', 'kotne minute', '°', 'rad'],
            'podatki': ['b', 'B', 'kB', 'MB', 'GB', 'TB'],
            'čas': ['ms', 'cs', 'ds', 's', 'min', 'h', 'dan', 'mesec', 'let'],
            'frekvenca': ['Hz', 'kHz', 'MHz', 'GHz', 'THz'],
            'tlak': ['Pa', 'mbar', 'kPa', 'bar']}

        self.desetiske_kolicine = ['energija']
        self.dolzinska_razmerja = {'nm': 1e-9, 'μm': 1e-6,'mm': 0.001, 'cm': 0.01, 'in': 0.0254, 'dm': 0.1, 'ft': 0.3048, 'yd': 0.9144, 'm': 1, 'km': 1000, 'mi': 1609.34, 'n.m.': 1852}
        self.masna_razmerja = {'mg': 0.001, 'oz' : 28.3495, 'lb' : 453.592, 'st' : 6350.29, 'g': 1, 'dag': 10, 'kg': 1000, 't' : 1e6, 'tn' : 907185, 'l.t.' : 1.016e+6}
        self.energijska_razmerja = {'eV': 1.6022e-19, 'mJ': 0.001, 'J': 1, 'kJ': 1000, 'MJ': (10 ** 6), 'GJ': (10 ** 9), 'TJ': (10 ** 12),}
        self.kvadratna_razmerja = {'m': 100 ** (-3), 'c': 100 ** (-2), 'd': 100 ** (-1),
                                   '': 1, 'a': 100, 'ha': 100 ** 2, 'k': 100 ** 3}
        self.kubicna_razmerja = {'m': 1000 ** (-3), 'c': 1000 ** (-2), 'd': 1000 ** (-1), '': 1,
                                 'ml': 10 ** (-6), 'cl': 10 ** (-5), 'dl': 10 ** (-4), 'l': 10 ** (-3), 'hl': 10 ** (-1)}
        self.casovna_razmerja = {'min': 60, 'h': 3600, 'dan': 86400, 'mesec': 2592000, 'let': 31104000}
        self.tlacna_razmerja = {'': 0, 'Pa': 1, 'mbar': 100, 'kPa': 1000, 'bar': 10 ** 5}
        self.podatkovna_razmerja = {'b': 0.125, '': 1, 'k': 1024, 'M': 1024 ** 2, 'G': 1024 ** 3, 'T': 1024 ** 4}
        self.kotna_razmerja = {'': 0, 'kotne sekunde': (1 / 3600), 'kotne minute': (1 / 60), '°': 1, 'rad': (180 / m.pi)}

    def nastavi_vrednost(self, vrednost):
        self.vrednost = float(vrednost)

    def doloci_enote(self):
        if self.kolicina != '':
            self.enote = self.kolicine[self.kolicina]


class Pretvornik:
    def __init__(self):
        self.osnova = Osnove()
        self.okno = tk.Tk()
        self.okno.title('Pretvornik enot')
######################################################################
        self.vhod = tk.Entry(self.okno)
        self.vhod.insert(0, string='0')

        self.vhodna_enotna_spremenljivka = tk.StringVar(self.okno)
        self.vhodna_enotna_spremenljivka.set('')
        self.vhodna_enota = tk.OptionMenu(self.okno, self.vhodna_enotna_spremenljivka, *self.osnova.enote)
        self.vhodna_enotna_spremenljivka.trace('w', self.vrednosti_enot)
#######################################################################
        self.kolicinska_spremenljivka = tk.StringVar(self.okno)

        kolicine = self.osnova.kolicine.keys()

        self.kolicinska_spremenljivka.set('količina')

        self.kolicinski_meni = tk.OptionMenu(self.okno, self.kolicinska_spremenljivka, *kolicine)

        self.kolicinska_spremenljivka.trace('w', self.doloci_izbiro_enot)
#######################################################################
        self.izhod = tk.Label(self.okno, width=20, text='0')

        self.izhodna_enotna_spremenljivka = tk.StringVar(self.okno)

        enote = self.osnova.enote
        self.izhodna_enotna_spremenljivka.set('')
        self.izhodna_enota = tk.OptionMenu(self.okno, self.izhodna_enotna_spremenljivka, *self.osnova.enote)
        self.izhodna_enotna_spremenljivka.trace('w', self.vrednosti_enot)

        self.je_enako = tk.Label(self.okno, text='=')
        self.gumb = tk.Button(self.okno, text='Pretvori', command=self.pretvorba)
#######################################################################
        self.vhod.grid(row=2, column=2)
        self.vhodna_enota.grid(row=2, column=3)
        self.kolicinski_meni.grid(row=1, column=5)
        self.je_enako.grid(row=2, column=5)
        self.izhod.grid(row=2, column=7)
        self.izhodna_enota.grid(row=2, column=8)
        self.gumb.grid(row=2, column=9)
#######################################################################
        self.okno.mainloop()

    def osvezi_enote(self):
        self.izhodna_enotna_spremenljivka.set('')
        self.vhodna_enotna_spremenljivka.set('')
        self.vhodna_enota['menu'].delete(0, 'end')
        self.izhodna_enota['menu'].delete(0, 'end')

        nove_enote = tuple(self.osnova.enote)
        for enota in nove_enote:
            self.izhodna_enota['menu'].add_command(label=enota, command=tk._setit(self.izhodna_enotna_spremenljivka, enota))
            self.vhodna_enota['menu'].add_command(label=enota, command=tk._setit(self.vhodna_enotna_spremenljivka, enota))

    def dolocitev_vhodne_vrednosti(self):
        if self.vhod.get() == 'pi':
            self.osnova.nastavi_vrednost(m.pi)
        else:
            self.osnova.nastavi_vrednost(float(self.vhod.get()))
        return self.osnova.vrednost

    def pretvori(self):
        return self.vrednosti_enot()[0] * self.dolocitev_vhodne_vrednosti() / self.vrednosti_enot()[1]

    def pretvorba(self):
        self.izhod.configure(text='{}'.format(round(self.pretvori(), 16)))

    def doloci_izbiro_enot(self, *args):
        self.osnova.kolicina = self.kolicinska_spremenljivka.get()
        self.osnova.doloci_enote()
        self.osvezi_enote()

    def vrednosti_enot(self, *args):
        enoti = [self.vhodna_enotna_spremenljivka.get(), self.izhodna_enotna_spremenljivka.get()]
        vrednosti = []
        for x in enoti:
            if self.osnova.kolicina in self.osnova.desetiske_kolicine:
                v = self.osnova.desetiska_razmerja[x[:-1]]
            elif self.osnova.kolicina == 'dolžina':
                v = self.osnova.dolzinska_razmerja[x]
            elif self.osnova.kolicina == 'masa':
                if x == '':
                    v = 0
                else:
                    v = self.osnova.masna_razmerja[x]
            elif self.osnova.kolicina == 'frekvenca':
                v = self.osnova.desetiska_razmerja[x[:-2]]
            elif self.osnova.kolicina == 'ploščina':
                if x in ['a', 'ha']:
                    v = self.osnova.kvadratna_razmerja[x]
                else:
                    v = self.osnova.kvadratna_razmerja[x[:-3]]
            elif self.osnova.kolicina == 'volumen':
                if x in ['ml', 'cl', 'dl', 'l', 'hl']:
                    v = self.osnova.kubicna_razmerja[x]
                else:
                    v = self.osnova.kubicna_razmerja[x[:-3]]
            elif self.osnova.kolicina == 'podatki':
                if 'b' == x:
                    v = 0.125
                else:
                    v = self.osnova.podatkovna_razmerja[x[:-1]]
            elif self.osnova.kolicina == 'čas':
                if x in self.osnova.casovna_razmerja.keys():
                    v = self.osnova.casovna_razmerja[x]
                else:
                    v = self.osnova.desetiska_razmerja[x[:-1]]
            elif self.osnova.kolicina == 'tlak':
                v = self.osnova.tlacna_razmerja[vhodna_enota]
            elif self.osnova.kolicina == 'koti v ravnini':
                v = self.osnova.kotna_razmerja[x]
            vrednosti.append(v)
        return vrednosti

Pretvornik()
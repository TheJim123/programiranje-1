import requests
import re
import os
import csv

###############################################################################
# Najprej definirajmo nekaj pomožnih orodij za pridobivanje podatkov s spleta.
###############################################################################

# definiratje URL glavne strani bolhe za oglase z mačkami
cats_frontpage_url = 'http://www.bolha.com/zivali/male-zivali/macke/'
# mapa, v katero bomo shranili podatke
cat_directory = 'C:/Users/Jimmy/Documents/GitHub/programiranje-1/2-zajem-podatkov/vaje/macji_podatki'
# ime datoteke v katero bomo shranili glavno stran
frontpage_filename = 'macke.html'
# ime CSV datoteke v katero bomo shranili podatke
csv_filename = 'macji_podatki.csv'


def download_url_to_string(url):
    '''This function takes a URL as argument and tries to download it
    using requests. Upon success, it returns the page contents as string.'''
    try:
        # del kode, ki morda sproži napako
        r = requests.get(url).text
    except requests.exceptions.ConnectionError:
        print('The page you are trying to download does not exist, please do NOT try later')
    else:
        return str(r)
        # koda, ki se izvede pri napaki
        # dovolj je če izpišemo opozorilo in prekinemo izvajanje funkcije
        # nadaljujemo s kodo če ni prišlo do napake


def save_string_to_file(text, directory, filename):
    '''Write "text" to the file "filename" located in directory "directory",
    creating "directory" if necessary. If "directory" is the empty string, use
    the current directory.'''
    os.makedirs(directory, exist_ok=True)
    path = os.path.join(directory, filename)
    with open(path, 'w', encoding='utf-8') as file_out:
        file_out.write(text)
    return None

# Definirajte funkcijo, ki prenese glavno stran in jo shrani v datoteko.


def save_frontpage(url, directory, ime_datoteke):
    '''Save "cats_frontpage_url" to the file
    "cat_directory"/"frontpage_filename"'''
    save_string_to_file(download_url_to_string(url), directory, ime_datoteke)

###############################################################################
# Po pridobitvi podatkov jih želimo obdelati.
###############################################################################


def read_file_to_string(directory, filename):
    '''Return the contents of the file "directory"/"filename" as a string.'''
    with open(directory+'/'+filename, encoding='utf-8') as datoteka:
        return datoteka.read()

# Definirajte funkcijo, ki sprejme niz, ki predstavlja vsebino spletne strani,
# in ga razdeli na dele, kjer vsak del predstavlja en oglas. To storite s
# pomočjo regularnih izrazov, ki označujejo začetek in konec posameznega
# oglasa. Funkcija naj vrne seznam nizov.

oglasni_vzorec = re.compile(r'<div class="ad">.*?</div>\n\n\n\n|<div class="ad featured">.*?</div>\n\n\n\n', re.DOTALL)
def page_to_ads(directory, filename):
        '''Split "page" to a list of advertisement blocks.'''
        oglasi = []
        besedilo = read_file_to_string(directory, filename)
        for ujemanje in oglasni_vzorec.findall(besedilo):
                oglasi.append(ujemanje)
        return oglasi

# Definirajte funkcijo, ki sprejme niz, ki predstavlja oglas, in izlušči
# podatke o imenu, ceni in opisu v oglasu.

podatkovni_vzorec = re.compile(
        r'<h3><a title="(?P<naslov>.+?)" href=".+">.+</a></h3>.*'
        r'\n\n\s*?(?P<opis>.+?)\s*?<div class="additionalInfo">.*'
        r'<div class="price">(<span>)?(?P<cena>.+?)<.*?',
        re.DOTALL
)
def get_dict_from_ad_block(ujemanje):
        '''Build a dictionary containing the name, description and price of an ad block.'''
        podatki_oglasa = ujemanje.groupdict()
        podatki_oglasa['naslov'] = podatki_oglasa['naslov'].strip()
        podatki_oglasa['opis'] = podatki_oglasa['opis'].strip()
        podatki_oglasa['cena'] = podatki_oglasa['cena'].replace(",", ".").strip()
        return podatki_oglasa

# Definirajte funkcijo, ki sprejme ime in lokacijo datoteke, ki vsebuje
# besedilo spletne strani, in vrne seznam slovarjev, ki vsebujejo podatke o
# vseh oglasih strani.


def ads_from_file(directory, filename):
        '''Parse the ads in filename/directory into a dictionary list.'''
        podatki = []
        ad_data = []
        oglasi = page_to_ads(directory, filename)
        for oglas in oglasi:
                podatki += podatkovni_vzorec.finditer(oglas)
        for ujemanje in podatki:
                ad_data.append(get_dict_from_ad_block(ujemanje))
        return ad_data

###############################################################################
# Obdelane podatke želimo sedaj shraniti.
###############################################################################


def write_csv(fieldnames, rows, directory, filename):
    '''Write a CSV file to directory/filename. The fieldnames must be a list of
    strings, the rows a list of dictionaries each mapping a fieldname to a
    cell-value.'''
    os.makedirs(directory, exist_ok=True)
    path = os.path.join(directory, filename)
    with open(path, encoding='utf-8', 'w') as csv_file:
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        for row in rows:
            writer.writerow(row)
    return None

# Definirajte funkcijo, ki sprejme neprazen seznam slovarjev, ki predstavljajo
# podatke iz oglasa mačke, in zapiše vse podatke v csv datoteko. Imena za
# stolpce [fieldnames] pridobite iz slovarjev.
dictionary = ads_from_file(cat_directory, frontpage_filename)
def write_cat_ads_to_csv(slovarji):
        naslovnica = slovarji[0].keys()
        directory = cat_directory + '/'+csv_filename
        with open (directory, 'w') as dat:
                writer = csv.DictWriter(dat, naslovnica)
                writer.writeheader()
                for slovar in slovarji:
                        writer.writerow(slovar)
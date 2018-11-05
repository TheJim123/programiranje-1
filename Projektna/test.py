import csv
import json
import os
import re
import sys

import requests

def pripravi_imenik(ime_datoteke):
    '''Če še ne obstaja, pripravi prazen imenik za dano datoteko.'''
    imenik = os.path.dirname(ime_datoteke)
    if imenik:
        os.makedirs(imenik, exist_ok=True)

def vsebina_datoteke(ime_datoteke):
    '''Vrne niz z vsebino datoteke z danim imenom.'''
    with open(ime_datoteke, encoding='utf-8') as datoteka:
        return datoteka.read()



def zapisi_csv(slovarji, imena_polj, ime_datoteke):
    '''Iz seznama slovarjev ustvari CSV datoteko z glavo.'''
    pripravi_imenik(ime_datoteke)
    with open(ime_datoteke, 'w', encoding='utf-8') as csv_datoteka:
        writer = csv.DictWriter(csv_datoteka, fieldnames=imena_polj)
        writer.writeheader()
        for slovar in slovarji:
            writer.writerow(slovar)

vzorec = re.compile(
    r'<a.*?id="(?P<id>#area\d+?)".*?'
    r'<.*?alt="Anime:(?P<naslov>.*?)".*?>.*?'
    r'(?P<tip>TV|Movie).*?(?P<epizode>\(\d+ eps\))<br>.*?'
    r'\w+\s(?P<leto>\d+?)\s-\s.*?<br>.*?'
    r'(?P<ogledi>\d*?,?\d*?,*\d*?) members.*?'
    r'<td.*?></i><span.*?>(?P<ocena>\d\.\d\d)</span></div>.*?',
    re.DOTALL
)

def izloci_podatke_animeja(ujemanje_animeja):
    podatki_animeja = ujemanje_animeja.groupdict()
    podatki_animeja['id'] = podatki_animeja['id'].strip()
    podatki_animeja['naslov'] = podatki_animeja['naslov'].strip()
    podatki_animeja['tip'] = podatki_animeja['tip'].strip()
    podatki_animeja['epizode'] = podatki_animeja['epizode'].strip()
    podatki_animeja['leto'] = int(podatki_animeja['leto'])
    podatki_animeja['ogledi'] = podatki_animeja['ogledi'].replace(',', "'").strip()
    podatki_animeja['ocena'] = float(podatki_animeja['ocena'].replace(',', '.'))
    return podatki_animeja


podatki_animeja = []
for i in range(20, 30):
    vsebina = vsebina_datoteke(
        'C:/Users/Jimmy/Documents/GitHub/programiranje-1/Projektna/top-anime-{}.html'.format(i+1))
    for ujemanje_animeja in vzorec.finditer(vsebina):
        podatki_animeja.append(izloci_podatke_animeja(ujemanje_animeja))
# zapisi_json(podatki_animeja, 'obdelani-podatki/vsi-animeji.json')
zapisi_csv(podatki_animeja, ['id', 'naslov', 'tip', 'epizode',
                            'leto', 'ogledi', 'ocena'], 'C:/Users/Jimmy/Documents/GitHub/programiranje-1/Projektna/obdelani-podatki/vsi-animeji-3.csv')

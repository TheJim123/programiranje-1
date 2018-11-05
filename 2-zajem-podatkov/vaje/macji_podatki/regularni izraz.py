import csv
import json
import os
import re
import sys

import requests
cat_directory = 'C:/Users/Jimmy/Documents/GitHub/programiranje-1/2-zajem-podatkov/vaje/macji_podatki'
frontpage_filename = 'macke.html'

def read_file_to_string(directory, filename):
    '''Return the contents of the file "directory"/"filename" as a string.'''
    with open(directory+'/'+filename, encoding='utf-8') as datoteka:
        return datoteka.read()

vzorec1 = re.compile(r'<div class="ad">.*?</div>\n\n\n\n|<div class="ad featured">.*?</div>\n\n\n\n', re.DOTALL)
oglasi = []
besedilo = read_file_to_string(cat_directory, frontpage_filename)
for ujemanje in vzorec1.findall(besedilo):
    oglasi.append(ujemanje)
print(oglasi)

vzorec2 = re.compile(
        r'<h3><a title="(?P<naslov>.+?)" href=".+">.+</a></h3>.*'
        r'\n\n\s*?(?P<opis>.+?)\s*?<div class="additionalInfo">.*'
        r'<div class="price">(<span>)?(?P<cena>.+?)<.*?',
        re.DOTALL)
podatki = []
for oglas in oglasi:
    #print(vzorec2.finditer(oglas))
    podatki += (vzorec2.finditer(oglas))
print(podatki)
# for ujemanje in vzorec2.findall(besedilo):
#    podatki.append(ujemanje)
# print(podatki)
for ujemanje in podatki:
    print(ujemanje.groups())
#vzorec3 = re.compile(
#    r'.*?<div class="ad.*?">.*?'
#    r'<h3><a title="(?P<naslov>.+?)" href=".+">.+</a></h3>.*'
#    r'\n\n\s*?(?P<opis>.+?)\s*?<div class="additionalInfo">.*'
#    r'<div class="price">(<span>)?(?P<cena>.+?)<.*?'
#    r'</div>\n\n\n\n.*?',
#    re.DOTALL
#)
#for ujemanje in vzorec3.findall(besedilo):
#    print(ujemanje)


<tr class="ranking-list">
    <td class="rank ac" valign="top">
    <span class="lightLink top-anime-rank-text rank1">3</span>
  </td>
    <td class="title al va-t word-break">
    <a class="hoverinfo_trigger fl-l ml12 mr8" href="https://myanimelist.net/anime/9253/Steins_Gate" id="#area9253" rel="#info9253">
      <img width="50" height="70" alt="Anime: Steins;Gate" class="lazyload" border="0" data-src="https://myanimelist.cdn-dena.com/r/50x70/images/anime/5/73199.jpg?s=97b97d568f25a02cf5a22dda13b5371f" data-srcset="https://myanimelist.cdn-dena.com/r/50x70/images/anime/5/73199.jpg?s=97b97d568f25a02cf5a22dda13b5371f 1x, https://myanimelist.cdn-dena.com/r/100x140/images/anime/5/73199.jpg?s=8fe506c27a2eba32611561a2dd116389 2x" />
    </a>

    <div class="detail"><div id="area9253">
  <div id="info9253" rel="a9253" class="hoverinfo"></div>
</div>
<div class="di-ib clearfix"><a class="hoverinfo_trigger fl-l fs14 fw-b" href="https://myanimelist.net/anime/9253/Steins_Gate" id="#area9253" rel="#info9253">Steins;Gate</a><a href="https://myanimelist.net/anime/9253/Steins_Gate/video" class="icon-watch ml8" title="Watch Episode Video">Watch Episode Video</a></div><br><div class="information di-ib mt4">
        TV (24 eps)<br>
        Apr 2011 - Sep 2011<br>
        1,090,508 members
      </div></div>
  </td>

    <td class="score ac fs14"><div class="js-top-ranking-score-col di-ib al"><i class="icon-score-star mr4 on"></i><span class="text on">9.14</span></div>
  </td>

    <td class="your-score ac fs14">
    <div class="js-top-ranking-your-score-col di-ib al">      <a href="https://myanimelist.net/login.php?error=login_required&amp;from=%2Ftopanime.php%3Flimit%3D000" class=""><i class="icon-score-star mr4 "></i><span class="text ">N/A</span></a>
</div>
  </td>

    <td class="status ac">      <a href="https://myanimelist.net/login.php?error=login_required&amp;from=%2Ftopanime.php%3Flimit%3D000" class=" btn-addEdit-large btn-anime-watch-status js-anime-watch-status notinmylist"><i class="fa fa-plus-square-o mr4"></i>Add to list</a>
</td>
</tr>

vzorec = re.compile(
    r'<img width=.*?alt="Anime: (?P<naslov>.*?)" class=.*?'
    r'<div class=".*?"><a class=".*?" href=".*?" id="(?P<id>.*?)" rel=".*?">(?P<naslov>.*?)</a><a href=".*?" class=".*?" title=".*?".*?>.*?(?P<tip> TV \(\d+?\))<br>.*?'
    r'\w+\s(?P<leto>\d+?)\s-\s.*?<br>.*?'
    r'(?P<ogledi>\d*?,?\d*?,*\d*?) members.*?'
    r'<td class=".*?"><div class=".*?"><i class=".*?"></i><span class="text on">(?P<ocena>\d\.\d\d)</span></div>.*?',
    re.DOTALL
)
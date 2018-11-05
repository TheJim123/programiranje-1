import re

cat_directory = 'C:/Users/Jimmy/Documents/GitHub/programiranje-1/2-zajem-podatkov/vaje/macji_podatki'

frontpage_filename = 'macke.html'

izraz = r'^<div class="ad">|<div class="ad featured">.*\n\n\n\n$'
izrazek = re.compile(izraz, re.DOTALL)
# besedilo = ""
with open('C:/Users/Jimmy/Documents/GitHub/programiranje-1/2-zajem-podatkov/vaje/macji_podatki/macke.html') as f:
    besedilo = f.read()
    print(besedilo)
print(izrazek.findall(besedilo))

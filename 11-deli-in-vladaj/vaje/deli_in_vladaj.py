##############################################################################
# Želimo definirati pivotiranje na mestu za tabelo [a]. Ker bi želeli
# pivotirati zgolj dele tabele, se omejimo na del tabele, ki se nahaja med
# indeksoma [start] in [end].
#
# Primer: za [start = 0] in [end = 8] tabelo
#
# [10, 4, 5, 15, 11, 2, 17, 0, 18]
#
# preuredimo v
#
# [0, 2, 5, 4, 10, 11, 17, 15, 18]
#
# (Možnih je več različnih rešitev, pomembno je, da je element 10 pivot.)
#
# Sestavi funkcijo [pivot(a, start, end)], ki preuredi tabelo [a] tako, da bo
# element [ a[start] ] postal pivot za del tabele med indeksoma [start] in
# [end]. Funkcija naj vrne indeks, na katerem je po preurejanju pristal pivot.
# Funkcija naj deluje v času O(n), kjer je n dolžina tabele [a].
#
# Primer:
#
#     >>> a = [10, 4, 5, 15, 11, 2, 17, 0, 18]
#     >>> pivot(a, 1, 7)
#     3
#     >>> a
#     [10, 2, 0, 4, 11, 15, 17, 5, 18]
##############################################################################
a = [10, 4, 5, 15, 11, 2, 17, 0, 18]

def zamenjaj(a, prvi, drugi):
    return a[:prvi] + [a[drugi]] + a[(prvi + 1):drugi] + [a[prvi]] + a[(drugi + 1):]

def pivot(a, start, end):
    pyvot = a[start]
    #print(pyvot)
    pivotiranec = a[start:(end+1)]
    print(pivotiranec)
    i = 1 #gleda manjše od pivota
    while i <= end:
        if pivotiranec[i] > pyvot:
            #print('{}, ki je {}. element seznama, je večji od pivota'.format(pivotiranec[i], i+1))
            j = i + 1 #gleda večje od pivota, ko se pri manjših zatakne
            while j < end:
                if pivotiranec[j] < pyvot:
                    print("Smo v if")
                    pivotiranec = zamenjaj(pivotiranec, i, j)
                    print(pivotiranec)
                    break
                elif j == (end - 1):
                    print("Smo v elif")
                    pivotiranec = zamenjaj(pivotiranec, 0, i-1)
                    novi_a = a[:start] + pivotiranec + a[(end+1):]
                    a = novi_a
                    return a
                else:
                    print("Smo v else")
                j += 1
                #print("A")
                print("i:={}, j:={}".format(i, j))
        i += 1
    print(a)
    #return pivotiran_seznam.index(pyvot)

    

##############################################################################
# Tabelo a želimo urediti z algoritmom hitrega urejanja (quicksort).
#
# Napišite funkcijo [quicksort(a)], ki uredi tabelo [a] s pomočjo pivotiranja.
# Poskrbi, da algoritem deluje 'na mestu', torej ne uporablja novih tabel.
#
# Namig: Definirajte pomožno funkcijo [quicksort_part(a, start, end)], ki
#        uredi zgolj del tabele [a].
#
#   >>> a = [10, 4, 5, 15, 11, 3, 17, 2, 18]
#   >>> quicksort(a)
#   [2, 3, 4, 5, 10, 11, 15, 17, 18]
##############################################################################
#def quicksort(a):


##############################################################################
# V tabeli želimo poiskati vrednost k-tega elementa po velikosti.
#
# Primer: Če je
#
# >>> a = [10, 4, 5, 15, 11, 3, 17, 2, 18]
#
# potem je tretji element po velikosti enak 5, ker so od njega manši elementi
#  2, 3 in 4. Pri tem štejemo indekse od 0 naprej, torej je "ničti" element 2.
#
# Sestavite funkcijo [kth_element(a, k)], ki v tabeli [a] poišče [k]-ti
# element po velikosti. Funkcija sme spremeniti tabelo [a]. Cilj naloge je, da
# jo rešite brez da v celoti uredite tabelo [a].
##############################################################################
#def main():
#    pivot(a, 1, 7)
#    print("gay")
#    pass
# CBS Casus Functioneel Analist
## Casus 1: R

Voor de casus moeten de kwartaalmutaties voor twee producten met R worden berekend. Dit moet worden gedaan voor de CBS data "83131NED - Consumentenprijzen; prijsindex 2015=100". In deze tabel staat de ConsumentenPrijsIndex (CPI) per maand en per jaar van meerdere producten en voor het totaal. Ik heb de kwartaalmutatie berekend voor Fruit (code: 'CPI011600') en voor Groenten (code: 'CPI011700').

In de code wordt de data uit StatLine gehaald, de CPI per kwartaal berekend, waarmee de kwartaalmutatie bereknd worden. Deze data wordt vervolgens in een database gezet en worden er twee pdf's met plots. Hiervoor staat er de data van 2021 tot en met 2024 geplot voor Fruit in 'Rplots voor CPI Fruit ' en voor groenten Rplots voor CPI Groenten'. Hiervan wordt de CPI per jaar, per maand en per kwartaal geplot om een inzicht te krijgen in het verloop hiervan. Daarna wordt de kwartaalmutatie geplot. En als wordt de CPI per kwartaal en de kwartaalmutatie naarst elkaar geplot.


Dit proces is opgedeeld in 5 scripts. Het hoofdscript, consumentenprijs_index.R, wodt gebruikt om het proces uit te voeren en de functeis te gebruiken.


### code
In het mapje code staan 4 scrips met functies. Deze script zijn:
- clean_data.R: hier wordt de data ogeschoond en de benodigde data geselecteerd.
- prepare_data.R: hier wordt de maanddata omgezet naar kwartaaldata en wordt de kwartaaldata van het vorige kwartaal aan de rij toegevoegd.
- calculate_mutation.R: hier wordt de kwartaalmutatie berkend.
- plot_data.R: Hier worden er vier plots gemaakt.


### tests
Vervolgens staat er in het mapje tests 3 test script geschreven. Dit is om het proces in de gaten te houden en te kunnen controleren of functies naar behoren blijven werken.
test_clean_data.R: test de functie in clean_data.R
test_prepare_data.R: test de functie in prepare_data.R
test_calculate_mutation.R: test de functie in calculate_mutation.R

### Requirements
Als laatste is er er requirements.txt, in deze file staan de benodigde packages.

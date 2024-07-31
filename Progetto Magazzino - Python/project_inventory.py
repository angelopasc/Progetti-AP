from os import path
import csv
import emoji 

fieldnames = ["Nome prodotto", "Quantità", "Prezzo di acquisto", "Prezzo di vendita"]

def verify_file(file_name):
    #Funzione per verificare l'esistenza del file e aprirlo. Oppure crearlo
    if not path.exists(file_name):
        with open(file_name, 'w', newline='', encoding='utf-8') as file:
            print(f"Creazione del file {file_name} effettuata con successo.")
            writer = csv.writer(file)
            writer.writerow(fieldnames)
    else:
        print(emoji.emojize(":hourglass_done: Apertura file in corso."))

def check_intvalue():
    #funzione per controllare che l'input sia un numero intero
    while True:
        try:
            a = int(input("Quantità: "))
            if a >0:
                break
            else:
                print(emoji.emojize(":warning: ATTENZIONE! \n Il valore inserito deve essere un numero intero positivo!"))
        except:
            print(emoji.emojize(":warning: ATTENZIONE! \n Il valore inserito non è un numero intero!"))  
    return a

def check_floatvalue():
        #funzione per controllare che l'input sia tipo float
    while True:
        try:
            a = float(input())
            if a >0:
                break
            else:
                print(emoji.emojize(":warning: ATTENZIONE! \n Il valore inserito deve essere un numero positivo!"))
        except:
            print(emoji.emojize(":warning: ATTENZIONE! \n Il valore inserito non è ammesso!"))  
    return a
        
def create_list():
    #funzione per trasformare il file in una lista
    with open("store.csv",encoding='utf-8') as file:
        csv_reader = csv.DictReader(file)
        return list(csv_reader)
    
def add_product():
    #funzione per aggiungere un prodotto a magazzino
        data=create_list()
        product_name = input("Nome Prodotto: ")
        product_found = False
        
        for product in data:
                if product_name==product["Nome prodotto"]:
                    product_found = True
                    print("Prodotto già presente in inventario. Inserisci la quantità da aggiungere: ")
                    qty=check_intvalue()               
                    product["Quantità"] = int(product["Quantità"])+qty
                                      
                
        if not product_found: 
                qty=check_intvalue()
                print("Prezzo di acquisto: ")
                cost=check_floatvalue()
                print("Prezzo di vendita: ")
                selling_price=check_floatvalue()                
                product = {"Nome prodotto": product_name, "Quantità": qty, "Prezzo di acquisto": cost, 
                           "Prezzo di vendita": selling_price}
                data.append(product)
                      
        write(data,fieldnames)

def list_product():
    #funzione per elencare i prodotti
    data=create_list()
    print(format_row(fieldnames))
    for row in data:
        print(format_row([row["Nome prodotto"], row["Quantità"], row["Prezzo di acquisto"], 
                              row["Prezzo di vendita"]]))

def help_request():
    #funzione di aiuto
    print("\nI comandi disponibili sono: \n - aggiungi : aggiungi un prodotto al magazzino \n "
          "- elenca: elenca i prodotto in magazzino \n - vendita: registra una vendita effettuata\n"
         " - profitti: mostra i profitti totali \n - aiuto: mostra i possibili comandi \n "
          "- rimuovi: rimuovi un prodotto dall'inventario \n - chiudi: esci dal programma")

def max_width():
    #funzione per calcolare la larghezza massima della colonna nome per una corretta visualizzazione
    data=create_list()
    max_lenght = 0
    for row in data:
        lunghezze=[]
        lunghezze.append(len(row["Nome prodotto"]))
        lunghezze.sort(reverse=True)
        max_lenght=lunghezze[0]
        if max_lenght<15:
            max_lenght=13
    return max_lenght    

# Funzione per formattare le stringhe con larghezza fissa e variabile per la prima colonna
def format_row(values):
    widths = [max_width()+2, 12, 20, 20]
    return "".join(f"{value:^{width}}" for value, width in zip(values, widths))

def sell():
    #funzione di vendita
    data=create_list()
    sell_product = input("Inserisci il nome del prodotto da vendere: ")
    product_found = False
    for product in data:
        if sell_product == product["Nome prodotto"]:
            product_found = True
            sell_qty=check_intvalue()
            if check_qty(sell_qty,int(product["Quantità"])) == True:
                revenue = sell_qty*float(product["Prezzo di vendita"])
                profit = revenue - (sell_qty * float(product["Prezzo di acquisto"]))
                product["Quantità"] = int(product["Quantità"]) - sell_qty
                print(f"- {sell_qty} x {product['Nome prodotto']} {product['Prezzo di vendita']}€ \n  Totale = {revenue} €")
                write(data,fieldnames)
                return [revenue, profit]
    if not product_found: 
            print(emoji.emojize(":warning: ATTENZIONE! \n Prodotto non presente a magazzino.")) 
            return False
                                                                   
def check_qty(input_qty,stock_qty):
    #funzione per controllare la disponibilità in magazzino
    if input_qty>stock_qty:
            print(f"Vendita fuori stock. La quantità massima vendibile è {stock_qty}")
            return False
    return True
    
def write(store,fieldnames):
    #funzione di scrittura del file
    with open("store.csv",'w',newline='', encoding='utf-8') as file:
        writer = csv.DictWriter(file, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(store)
    
def remove_line():
    #funzione di rimozione di un prodotto dal magazzino aggiunto per errore
    data = create_list()
    del_product = input("Inserisci il nome del prodotto da eliminare: ")
    for product in data:
        if del_product == product["Nome prodotto"]:
            print(emoji.emojize(f":check_mark_button: Il prodotto {del_product} è stato rimosso definitivamente dall'inventario."))
            data.remove(product)
            write(data,fieldnames)

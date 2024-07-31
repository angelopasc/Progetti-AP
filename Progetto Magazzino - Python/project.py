from os import path
import csv
import emoji
import project_inventory as inv                  

file_name = "store.csv"
inv.verify_file(file_name)
total_revenue = 0
total_profit= 0

cmd = None

while cmd!="chiudi":
    cmd = input("\nCosa vuoi fare? ")
        
    if cmd=="vendita":
        selling = inv.sell()
        if selling:
            total_revenue += float(selling[0])
            total_profit += float(selling[1])
        else:
            pass
        
    elif cmd=="profitti":
        print(emoji.emojize(f":money_bag: I ricavi lordi totali sono: {total_revenue} €\n Il profitto netto totale é: {total_profit} €"))        
    
    elif cmd=="aggiungi":
        inv.add_product()
                 
    elif cmd=="elenca":
        print("\n")
        inv.list_product()
        
    elif cmd=="aiuto":
        inv.help_request()
    
    elif cmd=="chiudi":
        print(emoji.emojize(f"Grazie per averci scelto! A presto! :airplane:"))
        
    elif cmd=="rimuovi":
        inv.remove_line()
    else:
        print("Comando non valido. Inserire un comando corretto.")
        inv.help_request()

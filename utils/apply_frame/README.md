# Apply frame and compress

Questo script Python automatizza l'applicazione di una cornice PNG alle immagini e 
applica un valore di compressione.

## Installazione:

```
pip install -r requirements.txt
```

## Requisiti:

- Una cornice in formato PNG con dimensioni 3000x3000 pixel
- Le immagini da elaborare devono essere all'interno di una cartella specifica

# Come utilizzare lo script:

- Esegui il comando con i seguenti parametri (sostituisci i valori tra parentesi):

```
python main.py <path_cornice>.png <cartella_immagini> [--compression valore_compressione]
```

- il parametro `--compression` è opzionale, di default è impostato un valore di `75`
- i path possono essere sia relativi che assoluti

# Output:

Verrà mostrata una progressbar che indicherà lo stato del processo.

**Attenzione:** il processo è distruttivo, ovvero verranno sovrascritte le immagini 
originali senza la possibilità di tornare indietro.
_Utilizza questo script con cautela._
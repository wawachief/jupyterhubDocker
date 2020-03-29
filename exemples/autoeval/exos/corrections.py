from nbautoeval.exercise_function import ExerciseFunction
from nbautoeval.args import Args

from math import sqrt

# Fonction solution du probleme 

def isPrime(n):
    if n==2 or n==3:
        return True
    if n%2 == 0 or n<=1:
        return False
    d=3
    while n%d!=0 and d <= sqrt(n):
        d+=2
    return n%d!=0

# Jeu de donnees sur lequel la fonction de l'eleve sera testee

inputs_isPrime = [
    Args(1), Args(2), Args(3), Args(5), Args(17), Args(1001)  
]

# Fabrication de l'instance pour l'autoevaluation

exo_isPrime = ExerciseFunction(
    isPrime,         # La fonction modele
    inputs_isPrime,  # Le jeu de donnees
    layout='pprint',
    layout_args=(40, 25, 25),
)
## AUTEUR:
Philippe Caron

## PROFESSEUR:
Marc Feeley

DESCRIPTION DU PROJET
===================================================================================
L'objectif du projet est de concevoir un compilateur pour le langage lua capable de
produire du code assembleur compilable par gcc. La description détaillée du projet
peut-être consultée en suivant le lien ci-dessous:
https://github.com/PhilLCar/Luna/blob/master/description.pdf

INSTALATION
===================================================================================
Afin de pouvoir utiliser le compilateur Luna, il suffit (une fois tous le fichiers
téléchargés) d'entrer la commande:

	% make all

Il est par la suite recommander d'effectuer les test unitaires afin de s'assurer que
tout fonctionne, pour se faire entrer la commande:

	% make ut
ou

	% make test

À noter que cette commande peut être exécutée toute seule à la place de "make all" 
ce qui reviendra à exécuter ces les deux commandes successivement.

UTILISATION
====================================================================================
L'utilisation du compilateur est très simple, il suffit d'entrer la commande :

	% tbd

L'information sur le compilateur peut être obtenue en effectuant:

	% tbd

RAPPORT
===================================================================================
Il est possible de produire le rapport grâce à la commande:
	
	% make rapport

NETTOYAGE
====================================================================================
Si à n'importe quel moment l'usager trouve que le répertoire est sali par tous les 
fichier de compilation, il peut à tout moment effectuer:

	% make clean

Ce qui enlèvera tous les fichiers produits par "make". Après make clean, le
compilateur ne sera pas fonctionnel. 
Pour effacer tous sauf les fichier essentiels au compilateur, effectuer:

	% make cleancompile
ou

	% make cleansubfiles   #pour conserver les fichiers exécutables produits.

On peut également n'enlever que les fichiers du rapport en entrant la commande:

	% make cleanrapport




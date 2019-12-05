# WaxClassification
Classification des images en fonction du type, de l'impression, du prix et de la qualité des pagnes africains

Ce travail est divisé en cinq (5) étapes nécessaires qui s'enchainnent:

##1. La collecte des images
Il s'agit du développement d'algorithmes qui parcouront plusieurs sites web et recuperont des image en 2D. A cet effet nous avons développés entre 5 à 10 algorithmes pour parcourir les sites comme: Amazon, Cdistcount, .........
 
##2. Modéle de classification
Nous avons utilisé Tensorflow pour developper notre modéle de classification sur les images collectées. Ce modèle a été ensuite validé par des image de test avec une performance de 90%.

##3. Convertir le modèle
Nous utilisons ensuite le convertisseur TensorFlow Lite et quelques lignes de Python pour convertir notre modéle Tensorflow machine au format TensorFlow Lite (adapter au mobile).

##4. Déployement du modéle
Nous developpons notre application à l'aide *Android Studio* en Java et Exécutons notre modèle sur le périphérique avec l' interpréteur TensorFlow Lite , avec des API dans de nombreuses langues.

##5. Optimisez votre modèle
Optimisation du modèle pour réduire la taille de notre modèle et augmenter son efficacité avec un impact minimal sur la précision sur mobile.

# Connecter l'inventaire OSC à GLPI

#### Téléchargement et installation du plugin

- Nous allons sur cette route pour télécharger et décompresser le plugin

```sh
cd /var/www/html/glpi/plugins/
```

- Il s'agit du référentiel du plugin OCS Inventory pour GLPI: `https://github.com/pluginsGLPI/ocsinventoryng/releases`

#### Nous exécutons la commande suivante pour le télécharger

```sh
wget https://github.com/pluginsGLPI/ocsinventoryng/releases/download/2.0.4/glpi-ocsinventoryng-2.0.4.tar.bz2
```

#### La commande suivante pour décompresser

```sh
tar xvjf glpi-ocsinventoryng-2.0.4.tar.bz2
```

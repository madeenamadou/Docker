![](images/hadoop-logo-no-back-500.png)


# Installer et configurer un simple cluster Hadoop dans Docker

## Installation automatique

Dans ce document j'introduis mon [Dockerfile](/build-2.8.0/Dockerfile) pour installer et configurer dans Docker, un simple cluster Hadoop propulsé par CentOS. L’archive est disponible sur le [DockerHub](https://hub.docker.com/r/madeenamadou/hadoop-docker/) et peut être installée en utilisant la commande : 

```
docker pull madeenamadou/hadoop-docker
```

## Installation manuelle

On peut aussi l'installer en local, en clonant d'abord ce git, avec les commandes suivantes : 

```
git clone https://github.com/madeenamadou/hadoop-docker.git
cd hadoop-docker/build-2.8.0/
docker build -t hadoop-docker .
```

## Docker
Oon peut obtenir un client Docker [à partir d’ici](https://docs.docker.com/engine/installation/#supported-platforms). Docker nous permet d’utiliser n’importe quelle application sur n’importe quelle type d'architecture (un peu comme une machine virtuelle, mais de facon plus efficace). Pour plus de détails sur comment Docker fonctionne, voir [ici](https://www.docker.com/what-docker).


## Démarrer le Cluster

Docker démarre les services Hadoop (YARN, HDFS, NameNode, DataNode), a partir du fichier [entrypoint.sh](/build-2.8.0/entrypoint.sh).

```
docker run -it --name hadoop \
    -v ~/tmp/hadoop_image/logs:/opt/hadoop/logs \
    -v ~/tmp/hadoop_image/shared:/root/shared \
    -p 49707:49707 -p 8031:8031 -p 8032:8032 -p 8033:8033 \
    -p 8040:8040 -p 8030:8030 -p 8080:8080 -p 8888:8888 \
    -p 11000:11000 -p 10001:10001 -p 15000:15000 -p 10000:10000 \
    -p 50070:50070 -p 50075:50075 -p 50090:50090 -p 50020:50020 \
    -p 50010:50010 -p 2222:22 -p 8042:8042 -p 8088:8088 \
    -d madeenamadou/hadoop-docker
```

## Bash CentOS 

```
alias hadoop-dckr='docker ps -l -q' && \
    docker exec -it `hadoop-dckr` bash
```

Une fois dans le bash, on peut vérifier que les services Hadoop ont bien démarré en utilisant la commande

```jps```

![](/images/jps.png)

# Un exemple de MapReduce : wordcount

Nous allons rapidement créer un fichier contenant le texte "Ceci est une phrase de sept mots.", et utiliser l’algorithme **wordcount**, pour compter les occurences des mots.

```
echo "Ceci est une phrase de sept mots." | hadoop fs -appendToFile - /user/root/7mots.txt
hadoop jar /usr/local/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.8.0.jar wordcount /user/root/7mots.txt /user/root/7mots.result
```
![](/images/mapreduce.png)

Nous pouvons observer les résultats en utilisant : 

```
hadoop fs -cat /user/root/7mots.result/\*
```
![](/images/wordcount.PNG)

## Interfaces web

Avec la commande run plus haut, nous avions alloué des ports pour notre cluster sur la machine hôte. C’est de cette façon que nous pouvons accéder aux interfaces web du cluster à partir d’un navigateur. Lorsque nous installerons de nouveaux composants Hadoop, tels que Ambari-Server, il faudra allouer les ports dédiés à l'exécution de l'image.  

## NameNode Web UI http://localhost:50070

![](/images/namenode.PNG)

## DataNode Web UI http://localhost:50075

## Secondary NameNode Web UI http://localhost:50090

## Resource Manager Web UI http://localhost:8088

## Node Manager Web UI http://localhost:8042

Il n’y a que DockerToolBox pour Windows au moment de la publication de ce document. En utilisant DockerToolBox sur Windows, il faut avoir soin de remplacer **localhost** par **192.168.99.100** pour accéder aux interfaces web sur la machine hôte; DockerToolBox exécutent les applications a l'intérieur d'une machine virtuelle dont l'adresse est **192.168.99.100**.


## Exporter en fichier *.tar

Voila ! Nous avons maintenant un cluster prêt pour fonctionner sur n’importe quelle machine hôte à partir de Docker. Nous pouvons l'exporter sous forme de fichier tar :

```
docker save hadoop-docker > hadoop-docker.tar
```

Pour charger le cluster sur n'importe quelle autre machine, utiliser la commande :

```
docker load < hadoop-docker.tar
```

## Quelques ressources
- http://hadoop.apache.org/
- https://www.docker.com/what-docker


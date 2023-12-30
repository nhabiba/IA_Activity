# Projet d'Application d'Activités de Group
## Objectif
Ce projet vise à développer une application permettant de proposer et de gérer des activités à réaliser en groupe.
## Fonctionnalités Principales
- Affichage d'une liste d'activités disponibles.
- Création et suppression d'activités.
- Gestion des utilisateurs et des groupes pour participer aux activités.
- Affichage détaillé des informations relatives à chaque activité.
- Filtrage par Catégorie d'Activités.
- Gestion de profil utilisateur (modification des informations personnelles).
- Interface de connexion et d'inscription pour les utilisateurs.
## Technologies Utilisées
- Framework : Flutter pour le développement de l'interface utilisateur.
- Firebase pour la gestion de l'authentification, de la base de données et du stockage.
- Utilisation de l'IA pour la détection d'images .
### Lancement de l'Application
- Ouvrez Visual Studio Code.
- Ouvrez le projet de l'application dans Visual Studio Code.
- lancé un émulateur Android.
- Dans Visual Studio Code, ouvrez un terminal .
- Utilisez la commande suivante pour lancer l'application sur l'émulateur Android : " Flutter run ".
## Développement
### US_1: [MVP] Interface de login
Une interface de login avec champs pour le nom d'utilisateur et le mot de passe, un bouton de connexion, sécurisant le mot de passe, permettant l'accès à l'application et restant fonctionnelle avec des champs vides.
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/200d3546-fe00-4c53-b866-9a7e0c702645)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/ccc09758-a271-4507-ac78-4e7767098c29)
### "Formulaire d'Inscription : Email et Mot de Passe"
Une interface d'inscription comprenant des champs pour l'email et le mot de passe, avec un bouton d'inscription, permettant à l'utilisateur de créer un compte sécurisé.
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/90c5cb6d-0a0d-4da6-aa92-71fbe43982e8)
### "Vérification des Informations d'Inscription via Firebase"
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/f7ecbd8c-71b2-4504-805c-1e164c56f2cd)
### US_2: [MVP] Liste des activités
La page dédiée à la liste des activités offre une présentation visuelle des activités avec leurs images, titres, lieux et prix. Elle propose des boutons pour afficher les détails de chaque activité et pour supprimer une activité. De plus, elle inclut un bouton pour se déconnecter et revenir à la page de connexion.
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/035b8d1b-3119-4ecb-adbb-4e49996dd11b)
### US_3 : [MVP] Détail d’une activité
La page de détail d'une activité présente une vue exhaustive comprenant une image représentative, le titre de l'activité, sa catégorie (comme Sport, Shopping, etc.), le lieu où elle se déroule, le nombre minimum de personnes requis pour sa réalisation, ainsi que le prix associé à cette activité.
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/8e341d35-4ed1-4584-b609-03299b4a5cf3)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/a5bd795d-b2a2-4c62-8121-9ee34cd7119d)
### US_4 : [MVP] Filtrer sur la liste des activités
La page "Activités" propose une TabBar permettant de filtrer les activités par catégorie, affichant uniquement les activités correspondant à la catégorie sélectionnée lors du clic sur une entrée spécifique.
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/c40d8ed0-3aeb-4371-881a-a29aec36d5fb)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/2acd1f96-0332-45b8-8c86-7336de7569bb)
### US_5 : [MVP] Profil utilisateur
La fonctionnalité de profil offre la visualisation et la modification des données utilisateur, incluant le login (en lecture seule), le mot de passe (caché), la date d'anniversaire, l'adresse avec code postal restreint aux chiffres, la ville, avec des boutons pour sauvegarder et se déconnecter.
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/f5c4f6b1-436b-4d16-b663-baba9c5d68b6)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/ab5be0f5-b196-4aeb-b48c-5ff87645f10c)
### US_6 : [IA] Ajouter une nouvelle activité
La fonction d'ajout d'activité accessible depuis le profil via la BottomNavigationBar présente un formulaire structuré avec des champs pour l'image, le titre, le lieu, le nombre minimum de personnes requis, et le prix. La catégorie est automatiquement définie lors de la sélection de l'image. Un bouton "Valider" permet de sauvegarder ces données nouvellement ajoutées dans la base de données.
#### Activité de type sport:
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/acdca8c9-23b3-43b7-9bc3-4bcdebed71ca)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/1c8dfe9f-f19e-4160-880c-c09a988da627)
### "Vérification de l'ajout d'activité via Firebase"
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/71173d1c-0a27-4f80-9f1a-a477f36b10ad)
#### Activité de type shopping:
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/2f974027-d939-4aa8-b67b-e68416ebb770)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/5088a49c-e6e1-4307-8688-bd3078d7cdb7)
### "Vérification de l'ajout d'activité via Firebase"
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/34d12a7b-ffab-4a9e-9ca0-c69d5ef4059a)
### Cette interface assure que toute suppression d'une activité se traduit automatiquement par la suppression cohérente et immédiate des données associées dans Firebase:
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/64cc03b8-a120-4a75-b557-9133741c3224)
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/989d6c98-2ced-4388-8fc9-354c3e4c64a3)
### "Vérification de Supprission de toutes les activités via Firebase":
![image](https://github.com/nhabiba/IA_Activity/assets/109957486/eabe45ad-82ae-432a-a0af-f30c44e03181)
### Une démonstration en ligne du projet présentant ses fonctionnalités et son interface utilisateur.


























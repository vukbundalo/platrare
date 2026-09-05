# Politique de confidentialité — Platrare

**Date d'entrée en vigueur :** 4 septembre 2026

Platrare est une application de gestion des finances personnelles à architecture local-first. Cette politique décrit les données auxquelles l'application accède, leur utilisation et vos droits.

---

## 1. Qui sommes-nous

Platrare est publiée par un développeur individuel, qui est le responsable du traitement au sens du RGPD. Vous pouvez joindre le développeur à **[support email]**, via l'App Store ou Google Play, ou via **Paramètres → À propos → Contacter l’assistance** dans l'application.

---

## 2. Données stockées sur votre appareil

Toutes les données que vous créez dans Platrare restent **exclusivement sur votre appareil**. Nous n'exploitons aucun serveur qui reçoit ou stocke vos informations financières.

**Ce qui est stocké localement :**

| Catégorie | Détails |
|---|---|
| Grand livre financier | Comptes, soldes, limites de découvert, historique des transactions, transactions planifiées et catégories |
| Pièces jointes | Photos de reçus et documents que vous choisissez d'ajouter aux transactions |
| Préférences | Devise principale, devise secondaire, thème, langue, paramètre de visibilité du solde |
| Sécurité | État du verrouillage de l'app ; hachage cryptographique à sens unique de votre code PIN (le PIN brut n'est jamais stocké) |
| Cache des taux de change | Données publiques de taux de change téléchargées depuis une API tierce et mises en cache localement |
| Rappels | Si vous activez les rappels pour les transactions planifiées, la date d'échéance, la description et le montant de chaque transaction planifiée à venir sont transmis au planificateur de notifications locales du système d'exploitation afin qu'il puisse afficher le rappel même lorsque l'application est fermée. Ils ne quittent jamais l'appareil. |
| Instantané du widget d'écran d'accueil (iOS) | Un petit résumé précalculé (soldes projetés pour les prochains jours et libellés affichés par le widget) stocké dans le conteneur partagé privé de l'app afin que le widget puisse s'afficher sans ouvrir l'application. Lorsque le verrouillage de l'app est activé, les montants de cet instantané sont masqués sauf si vous en décidez autrement dans les Paramètres. |

---

## 3. Données envoyées sur Internet

### 3.1 Taux de change

L'application récupère périodiquement des données de taux de change disponibles publiquement depuis l'**API Frankfurter** (api.frankfurter.dev / api.frankfurter.app), qui publie des données de la **Banque Centrale Européenne (BCE)**. Ces requêtes ne contiennent **aucune information personnelle** — uniquement un appel HTTP anonyme standard. Vos comptes, soldes et transactions ne sont jamais transmis. Les données sont mises en cache jusqu'à **6 heures**.

### 3.2 Pas d'analyse ni de publicité

Platrare **ne contient aucun SDK d'analyse, aucun service de rapport de crash ni réseau publicitaire**. Aucune donnée d'utilisation, identifiant d'appareil ni télémétrie comportementale n'est collectée. Les rappels, les widgets d'écran d'accueil et les raccourcis fonctionnent entièrement hors ligne.

---

## 4. Autorisations de l'appareil

| Autorisation | Objectif | Quand demandée |
|---|---|---|
| Appareil photo | Capturer des photos de reçus | Uniquement lors du tap sur « Prendre une photo » |
| Bibliothèque de photos | Sélectionner des images à joindre | Uniquement lors du tap sur « Choisir dans la galerie » |
| Fichiers | Joindre des PDFs et documents | Uniquement lors du tap sur « Parcourir les fichiers » |
| Biométrie / Face ID | Déverrouiller l'application | Uniquement lors de l'affichage de l'écran de verrouillage |
| Notifications | Vous rappeler peu avant l'échéance d'une transaction planifiée | Uniquement lorsque vous activez les rappels dans les Paramètres |
| Exécution au démarrage (Android) | Replanifier vos rappels après le redémarrage de l'appareil | Automatiquement, uniquement si les rappels sont activés |
| Réseau | Obtenir les taux de change | Automatiquement ; aucune donnée personnelle n'est envoyée |

L'application ne demande pas l'accès à la localisation, aux contacts, au microphone, au calendrier ni à toute autre autorisation non listée ci-dessus.

---

## 5. Verrouillage et authentification biométrique

Lorsque vous activez **Verrouiller l'app à l'ouverture** :

- L'app utilise le framework biométrique sécurisé du SE (iOS LocalAuthentication / Android BiometricPrompt). Vos données biométriques sont traitées entièrement dans l'enclave sécurisée du SE — l'app n'y accède jamais, ne les stocke ni ne les transmet.
- Si vous définissez un code PIN, seul un **hachage cryptographique à sens unique** de ce PIN est stocké sur l'appareil. Le PIN brut n'est jamais écrit sur le disque.

---

## 6. Sauvegardes

**L'export** crée un fichier `.zip` (non chiffré) ou `.platrare` (chiffré AES-256 avec mot de passe). Vous choisissez où le stocker. **Nous ne recevons jamais votre sauvegarde.**

**La sauvegarde automatique quotidienne** enregistre un fichier uniquement dans le stockage privé de l'appareil. Elle ne télécharge rien automatiquement vers un service cloud. Vous pouvez la partager manuellement via **Paramètres → Sauvegarde automatique → Enregistrer dans le cloud**.

**L'import** remplace toutes les données de l'appareil par le contenu de la sauvegarde. N'importez que des sauvegardes provenant de sources fiables.

Seuls les exports `.platrare` chiffrés par mot de passe incluent le hachage du code PIN de verrouillage de l'app ; les exports non chiffrés et les sauvegardes automatiques quotidiennes ne l'incluent jamais. Lorsque vous restaurez une sauvegarde sans PIN, le PIN déjà défini sur l'appareil est conservé.

**Sauvegardes de l'appareil par le système d'exploitation.** La fonction de sauvegarde propre à votre téléphone (iCloud Backup sur iOS, Google Auto Backup sur Android) peut copier le grand livre de l'app, les sauvegardes automatiques quotidiennes et les préférences vers votre compte Apple ou Google dans le cadre de la sauvegarde de l'appareil, selon les conditions d'Apple ou de Google. Sur Android, les reçus joints en sont exclus afin de respecter la limite de sauvegarde du système. Vous contrôlez les sauvegardes de l'appareil dans les paramètres du système d'exploitation ; le développeur ne les reçoit jamais.

---

## 7. Widgets, raccourcis et Siri (iOS)

- **Les widgets d'écran d'accueil** affichent les soldes projetés à partir de l'instantané décrit à la section 2. L'instantané réside dans le conteneur partagé privé de l'app sur votre appareil et n'est jamais téléversé. Lorsque le verrouillage de l'app est activé, les montants sont masqués par défaut.
- **Les actions rapides et les App Shortcuts** (appui long sur l'icône de l'app, l'app Raccourcis ou Siri) ne font qu'ouvrir l'application sur un écran donné, par exemple « Ajouter une transaction ». La reconnaissance vocale de Siri est effectuée par iOS selon les conditions de confidentialité d'Apple ; l'app ne reçoit que la commande résolue et n'envoie jamais votre grand livre à Apple.

---

## 8. Enfants

Platrare n'est pas destinée aux enfants de moins de 13 ans. Nous ne collectons pas sciemment d'informations auprès d'enfants.

---

## 9. Conservation et suppression des données

Les données persistent sur votre appareil jusqu'à ce que vous les supprimiez dans l'app, utilisiez **Paramètres → Effacer les données**, importiez une sauvegarde de remplacement ou désinstalliez l'application. Comme nous ne détenons aucune copie de vos données sur nos serveurs, il n'y a rien à supprimer de notre côté.

---

## 10. Vos droits

- **Accès et portabilité** — Toutes vos données sont visibles dans l'app. Utilisez **Exporter la sauvegarde** pour une copie portable.
- **Rectification** — Modifiez n'importe quel enregistrement à tout moment.
- **Suppression** — Utilisez les fonctions de suppression dans l'app, **Effacer les données** ou désinstallez.

**Utilisateurs EEE/Royaume-Uni :** Le RGPD et le UK GDPR peuvent vous accorder des droits supplémentaires, y compris le droit de déposer une plainte auprès de votre autorité de contrôle locale.

**Résidents californiens :** La CCPA/CPRA peut s'appliquer. Comme nous ne vendons ni ne partageons de données personnelles, les droits d'opposition ne s'appliquent pas dans la plupart des cas.

---

## 11. Sécurité

- Données dans une base de données **isolée dans l'app**, inaccessible aux autres apps.
- Sauvegardes protégées par **chiffrement AES-256** optionnel.
- Codes PIN stockés uniquement sous forme de **hachage cryptographique à sens unique**.
- Trafic réseau exclusivement via **HTTPS**.

---

## 12. Modifications

Nous pouvons mettre à jour cette politique lorsque les fonctionnalités évoluent. La **date d'entrée en vigueur** reflètera la dernière révision. L'utilisation continue de l'app vaut acceptation des modifications.

---

## 13. Contact

Pour toute question ou demande relative à la confidentialité, écrivez à **[support email]**, utilisez le contact sur App Store ou Google Play, ou **Paramètres → À propos → Contacter l’assistance** dans l'app.

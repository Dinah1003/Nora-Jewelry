# Nøra Jewelry - Analyse Exploratoire des Données et Visualisation

## **Project Background**

Cette analyse est réalisée pour une boutique de bijoux e-commerce. L'objectif est d'identifier les tendances de vente, les performances des produits, la rétention client et les stratégies marketing efficaces à travers une analyse exploratoire des données (EDA) (sur SQL)et des visualisations interactives réalisées sur **Tableau**.

1. Le dashboard interactif peut être télécharger [ici](https://public.tableau.com/authoring/NoraJewelryDashboard/Tableaudebord2#1)
2. Les requêtes SQL utilisées pour inspecter et assurer la qualité des données peuvent être trouvées ici - (https://github.com/Dinah1003/Nora-Jewelry/blob/main/Data%20quality%20check.sql)
3. Les requêtes SQL qui répondent aux questions business peuvent être trouvées ici - (https://github.com/Dinah1003/Nora-Jewelry/blob/main/Requêtes%20business%20questions.sql)

## **Data Structure & Initial Checks**

La base de données principale est constituée de plusieurs tables, incluant :

- **Orders** : Historique des commandes avec prix, dates et ID client.
- **Customers** : Informations client, y compris programme de fidélité et région.
- **Geo_lookup** : Correspondance des pays avec les régions.
- **Marketing Channels** : Suivi des canaux d'acquisition clients.

![image alt](https://github.com/Dinah1003/Nora-Jewelry/blob/564c15e263d54633c78bcdf24485d5d8897222b7/Data%20structure.jpg)

## **Executive Summary**

![image alt](https://github.com/Dinah1003/Nora-Jewelry/blob/7c9c125fab56f6a0c207e71bcf2fdd472d12f414/Dashboard.jpg)

### **Overview of Findings**

L'analyse des ventes de la boutique de bijoux met en évidence plusieurs tendances clés. Tout d'abord, le chiffre d'affaires a connu une **croissance annuelle de 24%** entre 2023 et 2024, reflétant une dynamique positive pour l'entreprise. Certains produits phares, tels que le *Bracelet or cristal bleu Jasmine*, le *Collier argent perle Elsa* et la *Bague diamant blanc Sofia*, représentent à eux seuls **39% des ventes totales**, soulignant leur popularité auprès des clients. Du côté du marketing, **les réseaux sociaux s'imposent comme le canal le plus performant**, générant **30% du chiffre d'affaires**, tandis que d'autres canaux, comme les publicités payantes, montrent une efficacité moindre. Par ailleurs, une observation majeure concerne la fidélisation : **70% des clients ayant passé plusieurs commandes ne sont pas inscrits au programme de fidélité**, suggérant un potentiel d’optimisation pour renforcer la rétention client. Enfin, le **panier moyen demeure stable**, oscillant entre **260 et 280 €**, indiquant une constance dans le comportement d'achat des clients.

## **Insights Deep Dive**

### **1. Sales Trends**

- **Croissance annuelle** : +24% du CA de 2023 à 2024.
- **Mois les plus performants** : Septembre, Avril, Juin et Novembre enregistrent le plus d'achats.
- **Panier moyen** : Stable entre **260 et 280 €**.

### **2. Products Sales**

- **Top produits** (39% des ventes) :
    - Bracelet or cristal bleu Jasmine
    - Collier argent perle Elsa
    - Bague diamant blanc Sofia
- **Bundles les plus achetés ensemble** :
    - Collier argent perle Elsa & Bague diamant blanc Sofia (167x)
    - Bracelet or cristal bleu Jasmine & Collier argent perle Elsa (164x)
- **Produits avec le plus de retours** :
    - Bague turquoise bohème Elise (**24% de retours**)
    - Bracelet manchette Louise (**16% de retours**)
- **Répartition des ventes** : Légère sur-représentation des bracelets.

### **3. Customer Retention & Marketing Channels**

- **Programme de fidélité** :
    - 1/3 des clients sont membres.
    - Leur panier moyen est **seulement 4€ plus élevé** que les non-membres.
    - L'average order per customer est similaire (**1,5 commandes** en moyenne).
- **Canaux marketing les plus performants** :
    - **Social media (30%)** en tête, suivi des emails.
    - Les **paid ads sont les moins rentables sur toutes les régions**.
- **Temps moyen entre 2 commandes** : **202 jours**.
    - Opportunité pour une stratégie de relance marketing.
- **Non-loyal retained rate** : **70% des clients récurrents ne sont pas dans le programme de fidélité**.

### **4. Regional Sales**

- **Pays les plus performants** :
    - France et US en volume.
    - L'Allemagne a le **panier moyen le plus élevé (267 €)**.
- **Croissance YoY par pays** :
    - **France et Allemagne : +24%**
    - **USA : +28%**
    - **Italie : +34%**
- **Top produits par pays** :
    - **France** : Bague diamant blanc Sofia (**12% du CA**).
    - **Allemagne** : Bracelet or cristal bleu Jasmine (**16% du CA**).
    - **Italie** : Collier argent perle Elsa (**15% du CA**).
    - **USA** : Collier argent perle Elsa (**14% du CA**).

## **Recommendations**

1. **Optimiser la saisonnalité** : Renforcer les campagnes sur réseaux sociaux et par mailing pendant les mois forts (Septembre, Avril, Juin, Novembre). - Proposition de promotions en lien avec les saisons associées (Rentrée, Printemps, Début de l’Été et Fêtes de fin d’années)
2. **Améliorer le programme de fidélité** : Actuellement, **70% des clients fidèles** (ayant passé plus d’une commande) ne sont pas inscrits au programme de fidélité. Cela indique que l'offre actuelle du programme n'est **pas suffisamment attrayante ou bien communiquée**.

**Actions à mettre en place :**

- **Valoriser davantage les avantages du programme** : Mettre en avant des récompenses tangibles (réductions exclusives, accès anticipé à de nouvelles collections, cadeaux d'anniversaire, etc.).
- **Mieux intégrer le programme dans l’expérience d’achat** : Proposer une inscription simplifiée dès la première commande avec une incitation immédiate (ex : -10% sur la prochaine commande).
- **Personnaliser la communication** : Envoyer des emails ciblés aux clients fidèles non-inscrits pour leur montrer ce qu’ils ont manqué (ex : “Vous avez déjà commandé 2 fois chez nous ! Pourquoi ne pas profiter de notre programme exclusif ?”).
- **Gamifier l’expérience** : Ajouter un système de points visibles sur le compte client pour inciter à l’accumulation et à l’engagement.
1. **Cibler les relances clients** : Les données montrent qu’en moyenne, un client passe une seconde commande **202 jours après son premier achat**. Actuellement, il n’y a **pas de stratégie de relance structurée** pour inciter ces clients à revenir plus tôt.

**Actions à tester :**

- **Expérimenter des offres de rétention autour de 200 jours** : Envoyer un email personnalisé avec une offre promotionnelle (“Vous nous manquez ! Profitez de -15% sur votre prochain bijou”).
- **Tester différentes périodes de relance** : Exemples :
    - **À 150 jours** : Un rappel en douceur sur les nouveautés et best-sellers.
    - **À 180 jours** : Une recommandation personnalisée basée sur leurs achats passés.
    - **À 200 jours** : Une offre promotionnelle incitative avec un sentiment d’exclusivité.
- **Utiliser les occasions spéciales** : Envoyer des offres ciblées pour les anniversaires des clients ou des événements comme la Saint-Valentin, Noël ou la Fête des Mères.
1. **Optimiser les canaux marketing** : Investir davantage dans le social media et l'emailing au détriment des paid ads. - Stratégie d’influence…
2. **Personnaliser les offres par pays** : Adapter les promotions en fonction des produits les plus vendus localement.
3. **Optimiser les ventes des bundles populaires :** Étant donné que certains produits sont fréquemment achetés ensemble (*Collier argent perle Elsa & Bague diamant blanc Sofia* et *Bracelet or cristal bleu Jasmine & Collier argent perle Elsa*), il serait pertinent de proposer des **offres groupées** avec une légère réduction pour encourager davantage les achats combinés. Mettre en avant ces bundles dans les campagnes marketing et sur la page d’accueil du site pourrait augmenter la conversion et le panier moyen.
- **Réduire le taux de retour des produits les plus concernés: L**a *Bague turquoise bohème Elise* affiche un **taux de retour élevé (24%)**, suivi du *Bracelet manchette Louise (16%)*. Une analyse plus approfondie des motifs de retour (taille, qualité perçue, attentes des clients) est essentielle. Travailler avec les équipes produit pour **améliorer la description et les visuels** sur le site, intégrer plus d’avis clients et, si nécessaire, ajuster la qualité ou le design pour réduire les insatisfactions. Proposer une meilleure **assistance à l’achat** avec un guide des tailles plus détaillé et des recommandations basées sur les préférences des clients.
- **Affiner la stratégie marketing en fonction des retours clients :** Mettre en place un **suivi post-achat** pour mieux comprendre pourquoi certains produits sont retournés et adapter les futures campagnes en conséquence. Réorienter les publicités des produits à fort taux de retour vers des segments de clientèle plus pertinents ou ajuster la communication sur leurs caractéristiques pour mieux gérer les attentes.

## **Resources**

- **SQL Queries** : [Lien vers les requêtes SQL]
- **Tableau Dashboard** : [Lien vers le tableau interactif]
- **Data Cleaning & Preparation** : [Lien vers la documentation]

---

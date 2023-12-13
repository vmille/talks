---
paginate: true
footer: '![w:50](../assets/Cpp-Francophonie.svg)'
marp: true
---

<!-- _class: title -->
<!-- _footer: '' -->

# Erreurs & API

CppFrug #53

<p style="font-size: x-large">Vivien MILLE</p>

<p style="font-size: x-large">13/12/2023</p>

![bg left w:50%](../assets/Cpp-Francophonie.svg)

---
# Disclaimer

---
## Disclaimer

* En fonction des versions, certaines constructions ne sont pas supportées
* A chaque contexte sa solution
* Opinions are my own 

---
# API & responsabilité

---
## API & responsabilité

Quand vous exposez des APIs (~signatures de fonction), idéalement, elles devraient être:
* auto-documentées (ou au moins pas de doc externe au code)
* reduites au strict minimum (S & I de **SOLID** et loi d'Hyrum)
* complexes à contourner ou mal utiliser (**EUHM**: Easy to Use, Hard to Misuse)

---
## API & responsabilité

Mais quand vous exposez des APIs (~signatures de fonction), idéalement, vous devez:
* laisser le contrôle à l'utilisateur sur le domaine que vous avez défini
* être le plus explicite possible dans vos intentions (conventions, homogénéité)

---
# Pour vous, c'est quoi une erreur ?

---
## Proposition de vague définition

Parmi les éléments courants, on retrouve:

* Comportement non attendu d'un code / algorithme / logique
* Situation nécessitant un traitement particulier
* ~~happy path~~ 

---
## Qui décide de ce qu'est une erreur ?

Quelle personne décide si le comportement doit être considéré comme une erreur, et donc avoir un traitement particulier ?

* Développeur de l'API
* Utilisateur de l'API

---
## Définition d'une erreur

On a donc 2 contextes qui peuvent s'opposer. La responsabilité de la définition est donc: 
* partagée
* divisée
* opposable 
* ...

---
## Plusieurs niveaux d'erreurs

De plus, il est souvent nécessaire d'avoir plusieurs niveaux d'erreur (et donc mécanismes). Par exemple:
* erreurs internes (corruption de données, mauvaise utilisation d'une API entrainant un crash)
* erreurs dans le domaine de définition (pré/post-conditions d'une API)
* ...

---
## Définition d'une erreur

La définition d'une erreur est donc

<p style="text-align: center"><font size="22" color="red">MULTIPLE</font></p>
<p style="text-align: center">et</p>
<p style="text-align: center"><font size="22" color="red">CONTEXTUELLE</font></p>

---
## Axes d'analyse

Pour la suite, on aura 2 axes: 
* Fournisseur 
* Consommateur

---
# Pour vous, comment indiquer une erreur ?

---
# Code erreur

---
## Code erreur

<p style="text-align: center">Votre avis: API explicite ou pas ?</p>
</br>

```cpp
int foo(auto buffer, int* byte_read);
```
</br>

```cpp
int foo(auto buffer, int* error_code);
```

<!--
Qui alloue le paramètre in/out ?
-->

---
## Code erreur
<div class="container">
<div class="col">

<p style="text-align: center">Fournisseur</p>

* 🟢 Implémentation simple 
* 🟢 Early return
* 🔴 Nécessité de maintenir le dictionnaire à jour
* 🔴 Ensemble restreint / limitation des possibilités
</div>

<div class="col">

<p style="text-align: center">Consommateur</p>

* 🟠 Responsabilité de la vérification du code erreur 
* 🟢 Délégation de la gestion
* 🔴 Utilisation courante de in/out parameter
* 🔴 Possiblement N dictionnaires d'erreur pour N API
</div>
</div>

---
# Structure de contrôle d'erreur

---
## Structure de contrôle d'erreur

<p style="text-align: center">Votre avis: API explicite ou pas ?</p>
</br>

```cpp
content_type foo(auto buffer, error_code* e)
```

</br>

```cpp
error_code foo(auto buffer, content_type* e)
```

<!--
Qui alloue le paramètre in/out ?
-->

---
## Structure de contrôle d'erreur
<div class="container">
<div class="col">
<p style="text-align: center">Fournisseur</p>

* 🟢 Early return
* 🟢 Signification plus explicite 
* 🟠 Possiblement une structure par fonction
* 🟢 Moins nécessaire d'avoir une documentation externe

</div>
<div class="col">
<p style="text-align: center">Consommateur</p>

* 🟢 Délégation de la gestion
* 🔴 Paramètres in/out obligatoires
* 🔴 Allocation d'un objet souvent obligatoire
</div>
</div>

---
# Compléments

---
## Compléments

Pour ces 2 cas, il est possible d'utiliser des variables globales (par exemple errno en C).
</br>

<p style="text-align: center"><font size="22" color="red">Attention à la concurrence !</font></p>

---
# Conclusions partielles 1/3

---
## Conclusions partielles 1/3

Ces solutions présentent de grosses lacunes:
* faible expressivité de l'API (surtout le code erreur)
* aucune obligation de vérifier si erreur il y a

Mais facilitent un peu l'utilisation:
* types de retour (code ou structure) connus et limités
* liberté de traitement quant à l'erreur

---
# Exception

---
# Exception: the bazooka

---
## Exception: the bazooka

<p style="text-align: center">Votre avis: API explicite ou pas ?</p>

```cpp
void write(auto buffer);
```
</br>

```cpp
void write(auto buffer) throw;
```
</br>

```
void write(auto buffer) throw OutOfMemory, ConversionException;
```

---
## Exception: the bazooka

<div class="container">
<div class="col">
<p style="text-align: center">Fournisseur</p>

* 🟢 Early return
* 🔴 Pas de description de ce qui est jeté
* 🟠 Autant de type d'exception que nécessaire

</div>
<div class="col">

<p style="text-align: center">Consommateur</p>

* 🔴 try/catch nombreux (encore plus si contrôle au grain fin)
* 🟠 Nombreux types d'exception à attraper
* 🟠 Référence à la documentation
* 🔴 Impact de performance (stack unrolling, guard, ...) y compris si non utilisé

</div>
</div>

---
## Exception: the bazooka

De plus:
* Mécanisme non supporté par certains langages, ou non idiomatique (Rust)
* Comportements potentiellement différents en fonction des OS, hardwares, ...
* Saut important dans le contrôle de flux

---
## Définitions littéraires

*Larousse*:
> **exception**: Ce qui est hors de la loi commune, qui paraît unique

*Robert*:
> **exception**: Action d'excepter (🤦), qui est en dehors de la norme, du commun

---
## Définitions littéraires

Une exception doit rester rare et ne pas être utilisée comme control flow. 

<p style="text-align: center"><font size="22" color="red">CE N'EST PAS UN IF</font></p>

Lever une exception devrait entrainer l'arrêt du programme et ne devrait servir qu'à échouer proprement (désallocation, fermeture sockets, ...)

---
# Conclusions partielles 2/3

---
## Conclusions partielles 2/3

Pour les 3 premiers cas, plusieurs questions sont à poser:

* **Comment être sûr que la signification de l'erreur est correctement prise en charge ?** </br> ➤ La vérification reste au bon vouloir du consommateur (peut ne pas checker, peut checker et balek)
* **Est-ce que mes valeurs sont utilisables ou non ? (ie résultats partiels du calcul)** </br> ➤ Documentation obligatoire sinon tout ou rien

---
# Structure de contrôle de flux

---
## Structure de contrôle de flux

<p style="text-align: center">Votre avis: API explicite ou pas ?</p>
</br>

```cpp
result_type write(auto buffer);
```

avec
```
result_type = value_type || error_type 
```

---
## Structure de contrôle de flux

<p style="text-align: center">Votre avis: API explicite ou pas ?</p>
</br>
</br>

```cpp
std::expected<file_handle, write_error> write(auto buffer);
```

---
## Structure de contrôle de flux
```cpp
result_type foo(auto buffer);
```

```cpp
auto res = foo(b);
if (res.is_error()) {
    res.error(); // OK
    // retry, throw exception, default value, log, ...
}
res.value(); // OK
```

```cpp
auto res = foo(b); // contains error
res.value(); // throw exception
```

---
## Structure de contrôle de flux

<div class="container">
<div class="col">
<p style="text-align: center">Fournisseur</p>

* 🟢 Early return
* 🟢 Faible documentation nécessaire, souvent directement dans le code 
* 🟢 Injection automatique des types nécessaires
* 🟢 Impossibilité de contourner l'indication d'erreur

</div>
<div class="col">

<p style="text-align: center">Consommateur</p>

* 🟢 Type de retour uniquement 
* 🟠 Assez performant (mais unpacking nécessaire)
* 🟢 Granularité fine
* 🟢 Contrôle complet

</div>
</div>


---
## Structure de contrôle de flux

<p style="text-align: center"><font size="22" color="red">Attention à ne pas inverser les types Value et Error dans les déclarations de types !</font></p>

---
# Conclusions partielles 3/3

L'utilisation de structure de controle de flux permet:
* d'être extrèmement explicite dans l'intention du fournisseur
* de limiter les mauvais usages
* de restreindre les adhérences (types opaques ou ~anonymes)

---
# Conclusion

---
## Conclusion

* Définir et signifier une erreur est complexe et contextuel
* Quand vous déclarer une erreur, tenez compte des conventions, des technologies, des bonnes pratiques, ...
* Soyez le plus explicite possible dans le domaine que vous exposez
* Idéalement privilégier _std::expected_ pour les erreurs à la gestion utilisateurs et les exceptions pour les erreurs irrécuperablesfs

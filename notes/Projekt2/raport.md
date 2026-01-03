---
title: Projekt 2 MOM
subtitle: MOM projekt 2
author:
  - Krzysztof Fijałkowski
date: 01.01.2026
documentclass: article
geometry:
  - margin=1in
fontenc: T1
fontfamily: mlmodern
fontsize: 11pt
numbersections: true
---

## Doprecyzowanie problemu
Na podstawie polecenia, autor rozumie, że problem jest rozważany w kontekście jedodniowego cyklu, jednocześnie zakładając, że magazyny nie mają stanu początkowego ani końcowego. Dodadkowo zakładając, że produkty się nie psują.

# Model
## Zbiory
Produkty:
$$
P = \{P1, P2\}
$$
Zakłady produkcyjne:
$$
Z = \{W1, W2\}
$$
Magazyny:
$$
M = \{M1, M2, M3\}
$$
Odbiorcy:
$$
S = \{S1, S2, S3, S4\}
$$
## Parametry
Dzienne koszty operacyjne dla możliwych konfiguracji magazynu M1:
$$
K_{M1}^{1}, K_{M1}^{2}
$$
Dzienne koszty operacyjne dla możliwych konfiguracji magazynu M2:
$$
K_{M2}^{0}, K_{M2}^{1}, K_{M2}^{2}
$$
Dzienny koszt operacyjny jednego modułu magazynu M3:
$$
K_{M3}^{moduł}
$$
Koszt transportu z zakładu do magazynu
$$
c_{z,m} \quad z \in Z, m \in M
$$
Koszt transportu z magazynu do odbiorcy
$$
t_{m,s} \quad m \in M, s \in S
$$
Możliwe pojemności dla magazynu M1 (dwie opcje):
$$
Q_{M1}^{1}, Q_{M1}^{2}
$$
Możliwe pojemności dla magazynu M2 (trzy opcje):
$$
Q_{M2}^{0}, Q_{M2}^{1}, Q_{M2}^{2}
$$
Pojemność jednego modułu magazynu M3:
$$
Q_{M3}^{moduł}
$$
Zapotrzebowanie odbiorcy na produkt
$$
D_{s,p} \quad s \in S, p \in P
$$
Maksymalna produkcja zakładu na produkt
$$
P_{z,p} \quad z \in Z, p \in P
$$
## Zmienne decyzyjne
Transport z zakładu do magazynu (bezpośrednio implikuje produkcję)
$$
x_{z,m,p} \geq 0 \quad z \in Z, m \in M, p \in P
$$
Transport z magazynu do odbiorcy
$$
y_{m,s,p} \geq 0 \quad m \in M, s \in S, p \in P
$$
Zmienne binarne wyboru konfiguracji magazynu M1:
$$
u_{M1}^{1}, u_{M1}^{2} \in \{0,1\}
$$
gdzie $u_{M1}^{1} = 1$ oznacza wybór pierwszej opcji pojemności ($Q_{M1}^{1}$), a $u_{M1}^{2} = 1$ oznacza wybór drugiej opcji pojemności ($Q_{M1}^{2}$).

Zmienne binarne wyboru konfiguracji magazynu M2:
$$
u_{M2}^{0}, u_{M2}^{1}, u_{M2}^{2} \in \{0,1\}
$$
gdzie $u_{M2}^{0} = 1$ oznacza niebudowanie magazynu (pojemność $Q_{M2}^{0}$), $u_{M2}^{1} = 1$ oznacza wybór pierwszej opcji pojemności ($Q_{M2}^{1}$), a $u_{M2}^{2} = 1$ oznacza wybór drugiej opcji pojemności ($Q_{M2}^{2}$).

Liczba modułów magazynu M3:
$$
n_{M3} \in \mathbb{Z}_+ \cup \{0\}
$$
gdzie każdy moduł ma pojemność ($Q_{M3}^{moduł}$) jednostek.

## Ograniczenia
Ograniczenia produkcyjne - każdy zakład nie może wyprodukować więcej niż jego maksymalna zdolność produkcyjna:
$$
\sum_{m \in M} x_{z,m,p} \leq P_{z,p} \quad \forall z \in Z, p \in P
$$

Wybór dokładnie jednej konfiguracji dla magazynu M1:
$$
u_{M1}^{1} + u_{M1}^{2} = 1
$$

Wybór dokładnie jednej konfiguracji dla magazynu M2:
$$
u_{M2}^{0} + u_{M2}^{1} + u_{M2}^{2} = 1
$$

Ograniczenia magazynowe - ilość produktów przechowywanych w magazynie nie może przekroczyć jego pojemności:

Dla magazynu M1:
$$
\sum_{z \in Z} \sum_{p \in P} x_{z,M1,p} \leq Q_{M1}^{1} \cdot u_{M1}^{1} + Q_{M1}^{2} \cdot u_{M1}^{2}
$$

Dla magazynu M2:
$$
\sum_{z \in Z} \sum_{p \in P} x_{z,M2,p} \leq Q_{M2}^{0} \cdot u_{M2}^{0} + Q_{M2}^{1} \cdot u_{M2}^{1} + Q_{M2}^{2} \cdot u_{M2}^{2}
$$

Dla magazynu M3:
$$
\sum_{z \in Z} \sum_{p \in P} x_{z,M3,p} \leq Q_{M3}^{moduł} \cdot n_{M3}
$$

Ograniczenia bilansowe - produkty wpływające do magazynu muszą równać się produktom wypływającym:
$$
\sum_{z \in Z} x_{z,m,p} = \sum_{s \in S} y_{m,s,p} \quad \forall m \in M, p \in P
$$

Ograniczenia zapotrzebowania - każdy odbiorca musi otrzymać wymagane ilości produktów:
$$
\sum_{m \in M} y_{m,s,p} = D_{s,p} \quad \forall s \in S, p \in P
$$

## Funkcja celu
Minimalizacja całkowitego dziennego kosztu dystrybucji, który jest sumą trzech składników:

1. **Koszty transportu z zakładów do magazynów:**
$$
\sum_{z \in Z} \sum_{m \in M} \sum_{p \in P} c_{z,m} \cdot x_{z,m,p}
$$

2. **Koszty transportu z magazynów do odbiorców:**
$$
\sum_{m \in M} \sum_{s \in S} \sum_{p \in P} t_{m,s} \cdot y_{m,s,p}
$$

3. **Koszty operacyjne magazynów:**
$$
K_{M1}^{1} \cdot u_{M1}^{1} + K_{M1}^{2} \cdot u_{M1}^{2} + K_{M2}^{0} \cdot u_{M2}^{0} + K_{M2}^{1} \cdot u_{M2}^{1} + K_{M2}^{2} \cdot u_{M2}^{2} + K_{M3}^{moduł} \cdot n_{M3}
$$

**Pełna funkcja celu:**
$$
\min  \sum_{z \in Z} \sum_{m \in M} \sum_{p \in P} c_{z,m} \cdot x_{z,m,p} + \sum_{m \in M} \sum_{s \in S} \sum_{p \in P} t_{m,s} \cdot y_{m,s,p} + K_{M1}^{1} \cdot u_{M1}^{1} + K_{M1}^{2} \cdot u_{M1}^{2} + K_{M2}^{0} \cdot u_{M2}^{0} + K_{M2}^{1} \cdot u_{M2}^{1} + K_{M2}^{2} \cdot u_{M2}^{2} + K_{M3}^{moduł} \cdot n_{M3}
$$
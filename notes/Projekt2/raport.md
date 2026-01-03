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

----------------------Do usunięcia poniżej----------------------
# Polecenie
Niech będą dane dwa zakłady wytwórcze W1 i W2. Zakład W1 może wytwarzać maksymalnie 41 jednostek produktu P1 i
105 jednostek produktu P2, a zakład W2 34 jednostek produktu P1 i 116 jednostek produktu P2. Transport produktów od
wytwórców do punktów sprzedaży detalicznej odbywa się poprzez magazyny hurtowe. Każdego dnia rano produkty są
przewożone do magazynów a następnie rozwożone z magazynów do punktów sprzedaży.
Oba produkty są przechowywane razem w tych samych magazynach hurtowych. Istnieje magazyn M1 o
pojemności 94 jednostek, który może zostać pozostawiony bez zmian lub być powiększony do pojemności 109 jednostek.
Magazyn M2 może nie być budowany (pojemność 0), może być budowany jako magazyn o pojemności 88 jednostek albo o
pojemności 109 jednostek. Magazyn M3 ma natomiast budowę modułową i może mieć pojemność będącą wielokrotnością
pojemności jednego modułu. Dzienne koszty operacyjne magazynów zależą jedynie od ich wielkości, a nie od ilości
faktycznie składowanych produktów. Koszty te wynoszą odpowiednio
0 tys. zł dla magazynu o pojemności 0 jednostek
348 tys. zł dla magazynu 1 o pojemności 94 jednostek
440 tys. zł dla magazynu 1 o pojemności 109 jednostek
324 tys. zł dla magazynu 2 o pojemności 88 jednostek
512 tys. zł dla magazynu 2 o pojemności 109 jednostek
Ponieważ magazyn 3 ma budowę modułową, koszt operacyjny zależy od liczby modułów z jakiej się składa. Każdy moduł
może pomieścić 14 jednostek produktów. Dzienny koszt operacyjny jednego modułu wynosi 18 tys. zł.
Z magazynów produkty są transportowane do czterech punktów sprzedaży detalicznej: S1, S2, S3, S4. Zapotrzebowanie brj
(r=1,2; j=1,2,3,4) na poszczególne produkty określa poniższa tabela
brj S1 S2 S3 S4
P1 18 12 15 16
P2 38 46 53 51
Produkty nie są policzalne (np. cement), czyli mogą być dowolnie dzielone pomiędzy magazyny i odbiorców.
Należy ustalić ilości produktów transportowanych na poszczególnych trasach oraz optymalne wielkości magazynów tak, aby
zagwarantować minimalny dzienny koszt dystrybucji (transportu i magazynowania) produktów.
Jednostkowe koszty transportu są identyczne dla obu produktów. Poniższe tabele podają wyrażone w tys. zł wartości
jednostkowych kosztów transportu od wytwórców do magazynów cki (k=1,2; i=1,2,3) oraz od magazynów do punktów
sprzedaży tij (i=1,2,3; j=1,2,3,4)
cki M1 M2 M3 tij S1 S2 S3 S4
W1 5 2 4 M1 15 3 3 4
W2 7 4 5 M2 4 10 5 5
M3 5 5 5 16
1. Sformułować model programowania mieszanego liniowego-całkowitoliczbowego. Model powinien zostać zawarty w
sprawozdaniu z wykonania projektu. Należy zdefiniować i opisać wszystkie zmienne występujące w modelu. Funkcja
celu oraz ograniczenia (grupy ograniczeń) muszą zostać dokładnie opisane: funkcja każdego z nich, rola poszczególnych
jego składników itp. Opis modelu musi być czytelny, wyczerpujący i wskazujący na zrozumienie zagadnienia.
Sprawdzający powinien na jego podstawie móc ocenić intencje autora.
2. Sformułować model w postaci do rozwiązania z wykorzystaniem wybranego narzędzia implementacji, np. AMPL,
AIMMS.
3. Rozwiązać model, a wynik (wartość funkcji celu oraz wartości zmiennych) przedstawić w sprawozdaniu


## Dane z polecenia do wykorzystania w modelu
### Produkcja
| Zakład | P1 | P2 |
|--------|----|----|
| W1     | 41 |105 |
| W2     | 34 |116 |
### Magazyny
| Magazyn | Pojemność | Koszt operacyjny (tys. zł) |
|---------|-----------|----------------------------|
| M1      | 94        | 348                        |
| M1      | 109       | 440                        |
| M2      | 88        | 324                        |
| M2      | 109       | 512                        |
| M3      | 14*n      | 18*n                       |
### Zapotrzebowanie
| Produkt | S1 | S2 | S3 | S4 |
|---------|----|----|----|----|
| P1      | 18 | 12 | 15 | 16 |
| P2      | 38 | 46 | 53 | 51 |
### Koszty transportu (tys. zł)
| c_ki        | M1 | M2 | M3 |
|-------------|----|----|----|
| W1          | 5  | 2  | 4  |
| W2          | 7  | 4  | 5  |

| t_ij        | S1 | S2 | S3 | S4 |
|-------------|----|----|----|----|
| M1          | 15 | 3  | 3  | 4  |
| M2          | 4  | 10 | 5  | 5  |
| M3          | 5  | 5  | 5  | 16 |



----------------------Usunąć powyżej----------------------

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
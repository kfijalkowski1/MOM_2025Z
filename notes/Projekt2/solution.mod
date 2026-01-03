
reset;

# Zbiory
set PRODUCTS;
set FACTORIES;
set WAREHOUSES;
set CUSTOMERS;

# Parametry
param PRODUCTION{FACTORIES, PRODUCTS};
param DEMAND{CUSTOMERS, PRODUCTS};
param COST_FACTORY_WAREHOUSE{FACTORIES, WAREHOUSES};
param COST_WAREHOUSE_CUSTOMER{WAREHOUSES, CUSTOMERS};

# Pojemności i koszty magazynów
param Q_M1_1;
param Q_M1_2;
param Q_M2_0;
param Q_M2_1;
param Q_M2_2;
param Q_M3_MODULE;

param K_M1_1;
param K_M1_2;
param K_M2_0;
param K_M2_1;
param K_M2_2;
param K_M3_MODULE;

# Wczytanie danych
data data.dat;

# Zmienne decyzyjne
var x{FACTORIES, WAREHOUSES, PRODUCTS} >= 0;  # Transport zakład -> magazyn
var y{WAREHOUSES, CUSTOMERS, PRODUCTS} >= 0;  # Transport magazyn -> odbiorca

# Zmienne binarne wyboru konfiguracji magazynów
var u_M1_1 binary;
var u_M1_2 binary;
var u_M2_0 binary;
var u_M2_1 binary;
var u_M2_2 binary;

# Liczba modułów magazynu M3
var n_M3 integer >= 0;

# Ograniczenia produkcyjne
subject to production_constraint{z in FACTORIES, p in PRODUCTS}:
    sum{m in WAREHOUSES} x[z, m, p] <= PRODUCTION[z, p];

# Wybór dokładnie jednej konfiguracji dla M1
subject to warehouse_M1_config:
    u_M1_1 + u_M1_2 = 1;

# Wybór dokładnie jednej konfiguracji dla M2
subject to warehouse_M2_config:
    u_M2_0 + u_M2_1 + u_M2_2 = 1;

# Ograniczenia pojemności magazynu M1
subject to capacity_M1:
    sum{z in FACTORIES, p in PRODUCTS} x[z, 'M1', p] <= Q_M1_1 * u_M1_1 + Q_M1_2 * u_M1_2;

# Ograniczenia pojemności magazynu M2
subject to capacity_M2:
    sum{z in FACTORIES, p in PRODUCTS} x[z, 'M2', p] <= Q_M2_0 * u_M2_0 + Q_M2_1 * u_M2_1 + Q_M2_2 * u_M2_2;

# Ograniczenia pojemności magazynu M3
subject to capacity_M3:
    sum{z in FACTORIES, p in PRODUCTS} x[z, 'M3', p] <= Q_M3_MODULE * n_M3;

# Ograniczenia bilansowe - produkty wpływające = wypływające
subject to flow_balance{m in WAREHOUSES, p in PRODUCTS}:
    sum{z in FACTORIES} x[z, m, p] = sum{s in CUSTOMERS} y[m, s, p];

# Ograniczenia zapotrzebowania
subject to demand_constraint{s in CUSTOMERS, p in PRODUCTS}:
    sum{m in WAREHOUSES} y[m, s, p] = DEMAND[s, p];

# Funkcja celu - minimalizacja całkowitego kosztu
minimize total_cost:
    # Koszty transportu zakład -> magazyn
    sum{z in FACTORIES, m in WAREHOUSES, p in PRODUCTS} COST_FACTORY_WAREHOUSE[z, m] * x[z, m, p]
    # Koszty transportu magazyn -> odbiorca
    + sum{m in WAREHOUSES, s in CUSTOMERS, p in PRODUCTS} COST_WAREHOUSE_CUSTOMER[m, s] * y[m, s, p]
    # Koszty operacyjne magazynów
    + K_M1_1 * u_M1_1 + K_M1_2 * u_M1_2
    + K_M2_0 * u_M2_0 + K_M2_1 * u_M2_1 + K_M2_2 * u_M2_2
    + K_M3_MODULE * n_M3;

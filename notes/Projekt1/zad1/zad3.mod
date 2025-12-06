reset;

# Zbiory
set POINTS;

# Parametry
param baseline{POINTS};  # plan bazowy
param w_max;  # waga maksymalnego odchylenia
param w_sum;  # waga sumy odchyleń

# Dane
data zad3.dat;

# Zmienne decyzyjne
var x{i in POINTS} >= 0, integer;  # planowana sprzedaż
var r_plus{i in POINTS} >= 0;  # względne odchylenie dodatnie
var r_minus{i in POINTS} >= 0;  # względne odchylenie ujemne
var r{i in POINTS} >= 0;  # bezwzględne względne odchylenie
var R >= 0;  # maksimum względnych odchyleń

# Ograniczenia

subject to total_sales:
    sum{i in POINTS} x[i] = sum{i in POINTS} baseline[i];

subject to constraint_1_3_8:
    x[1] + x[3] + x[8] >= 1.12 * (baseline[1] + baseline[3] + baseline[8]);

subject to constraint_3_5:
    x[3] + x[5] <= 0.93 * (baseline[3] + baseline[5]);

subject to constraint_3_vs_7:
    x[3] >= 0.8 * x[7];

subject to deviation_definition{i in POINTS}:
    r_plus[i] - r_minus[i] = (x[i] - baseline[i]) / baseline[i];

subject to absolute_deviation{i in POINTS}:
    r[i] = r_plus[i] + r_minus[i];

subject to max_deviation{i in POINTS}:
    R >= r[i];

# Funkcja celu
minimize total_cost:
    w_max * R + w_sum * sum{i in POINTS} r[i];

option solver cplex;
solve;

printf "\n=== ROZWIĄZANIE ===\n";
printf "\nPlanowana sprzedaż:\n";
for {i in POINTS} {
    printf "Punkt %d: %d (bazowo: %d, zmiana: %+d)\n", 
        i, x[i], baseline[i], x[i] - baseline[i];
}

printf "\nWzględne odchylenia:\n";
for {i in POINTS} {
    printf "Punkt %d: %.4f (%.2f%%)\n", 
        i, r[i], r[i] * 100;
}

printf "\nMaksymalne odchylenie względne R: %.4f (%.2f%%)\n", R, R * 100;
printf "Całkowity koszt funkcji celu: %.4f\n", total_cost;

printf "\n=== WERYFIKACJA OGRANICZEŃ ===\n";
printf "Suma sprzedaży: %d (bazowa: %d)\n", 
    sum{i in POINTS} x[i], sum{i in POINTS} baseline[i];
printf "Punkty 1,3,8: %d >= %g ✓\n", 
    x[1] + x[3] + x[8], 1.12 * (baseline[1] + baseline[3] + baseline[8]);
printf "Punkty 3,5: %d <= %g ✓\n", 
    x[3] + x[5], 0.93 * (baseline[3] + baseline[5]);
printf "Punkt 3 vs 7: %d >= %g (80%% z %d) ✓\n", 
    x[3], 0.8 * x[7], x[7];

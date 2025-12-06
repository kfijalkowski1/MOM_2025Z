# Zadanie 2.3 — Minimalizacja terminu realizacji puli projektów (makespan)
# Model przypisania z minimalizacją maksymalnego czasu realizacji.

set T;  # Zespoły
set P;  # Projekty

param t {T, P} >= 0;           # Czasy realizacji i przez j (miesiące)
param allowed {T, P} binary;   # 1 jeśli zespół i może realizować projekt j, 0 wpp.

var x {T, P} binary;           # x[i,j] = 1 jeśli i realizuje j
var C >= 0;                    # Makespan (maksymalny czas spośród przydzielonych projektów)

minimize Makespan: C;

# Każdy zespół realizuje dokładnie jeden projekt
s.t. TeamAssignment {i in T}: sum {j in P} x[i,j] = 1;

# Każdy projekt jest realizowany przez dokładnie jeden zespół
s.t. ProjectAssignment {j in P}: sum {i in T} x[i,j] = 1;

# Kompetencje: wykluczenie niedozwolonych przypisań
s.t. Competence {i in T, j in P}: x[i,j] <= allowed[i,j];

# Definicja makespanu: C >= czas przypisanego zespołu dla każdego projektu
s.t. MakespanDef {j in P}: C >= sum {i in T} t[i,j] * x[i,j];

# Opcjonalnie: można wymusić, by C był równy max, przez minimalizację i te ograniczenia wystarczają.

# Raport
data zad2.dat;

solve;

printf "\nOptymalne C (makespan): %g\n", C;
printf "\nPrzydziały (i -> j):\n";
for {i in T, j in P} {
  if x[i,j] > 0.5 then printf "%s -> %s (czas=%g)\n", i, j, t[i,j];
}

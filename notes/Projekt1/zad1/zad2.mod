# Zadanie 2.3 — Minimalizacja terminu realizacji puli projektów (makespan)

set T; 
set P; 

param t {T, P} >= 0;           
param allowed {T, P} binary;   

var x {T, P} binary;           
var C >= 0;                    

minimize Makespan: C;

# Ograniczenia
subject to TeamAssignment {i in T}: sum {j in P} x[i,j] = 1;
subject to ProjectAssignment {j in P}: sum {i in T} x[i,j] = 1;

subject to Competence {i in T, j in P}: x[i,j] <= allowed[i,j];

subject to MakespanDef {j in P}: C >= sum {i in T} t[i,j] * x[i,j];

# Dane
data zad2.dat;

solve;

# Wyniki
printf "\nOptymalne C (makespan): %g\n", C;
printf "\nPrzydziały (i -> j):\n";
for {i in T, j in P} {
  if x[i,j] > 0.5 then printf "%s -> %s (czas=%g)\n", i, j, t[i,j];
}

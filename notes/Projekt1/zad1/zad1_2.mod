# Max-flow to plants model (without plant demand sink)

set NODES;
set ARCS within {NODES,NODES};
set PLANTS within NODES;

param u{ARCS} >= 0;  # capacities

var x{ARCS} >= 0;     # flows on arcs

param s symbolic;     # source node name (super-source)

# Objective: maximize total flow delivered to plants
maximize TotalFlow:
        sum{(i,j) in ARCS: j in PLANTS} x[i,j];

# Capacity constraints
s.t. Cap{(i,j) in ARCS}: x[i,j] <= u[i,j];

# Flow conservation at intermediate nodes (non-source, non-plants)
s.t. Balance{j in NODES: j <> s and not (j in PLANTS)}:
        sum{(i,j2) in ARCS: j2 = j} x[i,j2]
    = sum{(j2,k) in ARCS: j2 = j} x[j2,k];

# Output and solve handled by executor.py

reset;

set NODES;
set INTERMEDIATE_NODES;

param Z_F;
param Z_G;
param Z_H;

param W_A;
param W_B;
param W_C;

param COST{f in NODES, t in NODES};
param CAPACITY{f in NODES, t in NODES};

data zad1.dat;

var flow{f in NODES, t in NODES} >= 0;

subject to capacity_constraint{f in NODES, t in NODES}:
	flow[f, t] <= CAPACITY[f, t];

subject to demand_F:
	sum{i in NODES} flow[i, "F"] = Z_F;

subject to demand_G:
	sum{i in NODES} flow[i, "G"] = Z_G;

subject to demand_H:
	sum{i in NODES} flow[i, "H"] = Z_H;

subject to flow_conservation{j in INTERMEDIATE_NODES}:
	sum{i in NODES} flow[i, j] = sum{k in NODES} flow[j, k];

subject to mine_capacity_A:
	sum{j in NODES} flow["A", j] <= W_A;

subject to mine_capacity_B:
	sum{j in NODES} flow["B", j] <= W_B;

subject to mine_capacity_C:
	sum{j in NODES} flow["C", j] <= W_C;

minimize total_cost:
	sum{f in NODES, t in NODES} COST[f, t] * flow[f, t];

option solver cplex;
solve;

display flow;
display total_cost;

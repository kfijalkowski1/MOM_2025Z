from amplpy import AMPL
ampl = AMPL()

ampl.option["solver"] = "highs"
ampl.reset()
ampl.read("zad3.mod")
# ampl.read_data("zad2.dat")
# ampl.solve()
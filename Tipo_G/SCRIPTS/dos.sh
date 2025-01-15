# ============ Fe ================================
python3 suma_pdos.py -o scf.bifeo3.out -p Fe_DOS -s "*(Fe*"  # Total
python3 suma_pdos.py -o scf.bifeo3.out -p Fe_DOS_s -s "*(Fe*(s)"  # Orbital s
python3 suma_pdos.py -o scf.bifeo3.out -p Fe_DOS_p -s "*(Fe*(p)"  # Orbital p
python3 suma_pdos.py -o scf.bifeo3.out -p Fe_DOS_d -s "*(Fe*(d)"  # Orbital d

# ============ O ================================
python3 suma_pdos.py -o scf.bifeo3.out -p O_DOS -s "*(O)*"  # Total
python3 suma_pdos.py -o scf.bifeo3.out -p O_DOS_s -s "*(O)*(s)"  # Orbital s
python3 suma_pdos.py -o scf.bifeo3.out -p O_DOS_p -s "*(O)*(p)"  # Orbital p

# ============ Bi ================================
python3 suma_pdos.py -o scf.bifeo3.out -p Bi_DOS -s "*(Bi)*"  # Total
python3 suma_pdos.py -o scf.bifeo3.out -p Bi_DOS_s -s "*(Bi)*(s)"  # Orbital s
python3 suma_pdos.py -o scf.bifeo3.out -p Bi_DOS_p -s "*(Bi)*(p)"  # Orbital p
python3 suma_pdos.py -o scf.bifeo3.out -p Bi_DOS_d -s "*(Bi)*(d)"  # Orbital d


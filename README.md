# Asynchronous-FIFO
-> Designed a Robust 64*8 Dual Clock Asynchronous FIFO with two clock domains: one for read and one for write.
-> Two flop synchronizer for tackling metastability due to CDC. Gray code pointers were used handling the problem as binary pointer addresses may cause the address value to change after the system comes out to a stable state from metastable state.

# Architecture
<img width="917" height="372" alt="image" src="https://github.com/user-attachments/assets/1fdfc4e7-2267-4a3c-9468-3b4c133a4b2f" />

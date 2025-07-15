# AHB BUS Protocol

> Developed at the Centre for Heterogeneous and Intelligent Processing Systems  
> A high-performance AMBA-based bus protocol for system-on-chip communication

## 🔧 Overview

The **Advanced High-Performance Bus (AHB)** is part of the AMBA protocol suite. It supports multiple bus masters and slaves, enabling high-speed memory and peripheral access in modern SoCs.

### 📌 Key Components

- **Masters (Managers):** Initiate read/write operations.
- **Slaves (Subordinates):** Respond to the master's transactions.
- **Decoder:** Maps addresses to the corresponding slave devices.
- **Multiplexor:** Routes outputs from slaves back to the master.

![image_alt](https://github.com/santoshmokashi86/AHB-Protocol/blob/main/AHB_overview.png?raw=true)

---

## 🚦 Manager (Master) Interface

### 🔻 Input Signals

- `HREADY`: Indicates the current transfer is complete.
- `HRESP`: Response status of transfer.
- `HRDATA`: Data read from the subordinate.
- `HRESETn`: Active-low reset.
- `HCLK`: Clock signal.

### 🔺 Output Signals

- `HADDR`: Address for the transfer.
- `HWDATA`: Data to be written.
- `HWRITE`: Transfer type (read/write).
- `HSIZE`: Transfer size.
- `HBURST`: Burst type/length.
- `HTRANS`: Transfer type.
- `HPROT`: Protection level.
- `HMASTLOCK`: Locked sequence indicator.

![image_alt](https://github.com/santoshmokashi86/AHB-Protocol/blob/main/master.png?raw=true)
---

## 📥 Subordinate (Slave) Interface

### 🔻 Input Signals

- `HSEL_x`: Slave select signal.
- `HADDR`, `HWDATA`, `HWRITE`, `HSIZE`, `HBURST`, `HTRANS`, `HPROT`, `HMASTLOCK`

### 🔺 Output Signals

- `HREADY_x`: Transfer completion.
- `HRESP_x`: Transfer response.
- `HRDATA_x`: Read data.

![image_alt](https://github.com/santoshmokashi86/AHB-Protocol/blob/main/subordinate.png?raw=true)
---

##  Decoder Signals

### 🔻 Input
- `HADDR`

### 🔺 Output
- `HSEL_x`: Slave selection
- `HMUXSEL_x`: Read-mux enable

---

## 🔀 Multiplexor Signals

### 🔻 Input
- `HREADY_x`, `HRESP_x`, `HRDATA_x`

### 🔺 Output
- `HREADY`, `HRESP`, `HRDATA`

---
## Overall Block Diagram 

![image_alt](https://github.com/santoshmokashi86/AHB-Protocol/blob/main/Overall_arch.png?raw=true)



---

## 🧪 Transfer Types and States

| Transfer Type | Description |
|---------------|-------------|
| Simple Read/Write | Basic transfer without wait |
| 1/2 Wait State | Transfer delayed by 1 or 2 cycles |
| Error State | Transfer with an error response |
| Burst Transfer | Multiple sequential beats |
| Idle State | No operation cycle |
| Busy State | Master is not ready for transfer |



---

## 🔁 Burst Modes in AHB

### INCR (Incremental)
- Sequential addresses
- Common in linear data movement

### WRAP (Wrapping)
- Wraps around cache-line boundary (16, 32, 64 bytes)
- Ensures alignment for cache efficiency

**Wrap boundary = Number of beats × Beat size**



---

## 📏 Aligned vs Unaligned Addresses

- **Aligned:** Address starts at the cache line boundary (e.g. 0x00, 0x40).
- **Unaligned:** Starts at arbitrary location (e.g. 0x38).

> **WRAP** burst ensures aligned access, improving CPU performance and reducing stalls.  
> Recommended for cache-line-based memory systems.

---

## 📸 Transfer Visuals


---

## 🙏 Acknowledgements

Thanks to the instructors and team at the  
**Centre for Heterogeneous and Intelligent Processing Systems**  

---

## 📚 License

This project is open-source under the MIT License.

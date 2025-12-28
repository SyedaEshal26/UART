## **UART Design (Verilog)**

---

### **1. INTRODUCTION TO UART**

---

This project implements a **UART (Universal Asynchronous Receiver/Transmitter)** using **Verilog HDL**.
UART is a widely used protocol for **serial communication** between digital systems. It converts parallel data from the processor into serial form for transmission and converts received serial data back into parallel form.

The project demonstrates a complete UART design including **transmitter, receiver, baud rate generator**, and a **top-level integration module**, along with a testbench for verification.

It is intended for learning **serial communication, digital design, and Verilog HDL implementation** through simulation.

---

### **2. PROJECT STRUCTURE**

---

**UART Design**

```
UART/
├── Design/
│   ├── baud_gen.v
│   ├── uart_rx.v
│   ├── uart_tx.v
│   ├── uart_top.v
├── Testbench/
│   └── uart_tb.v
└── README.md
```

---

### **3. MODULES**

---

#### **1. uart_tx.v (UART Transmitter)**

This module implements the **UART transmitter**.

* Converts parallel input data into serial output.
* Handles **start, data, parity (optional), and stop bits**.
* Controlled by baud rate signals from the baud generator.

---

#### **2. uart_rx.v (UART Receiver)**

This module implements the **UART receiver**.

* Receives serial data and converts it into parallel output.
* Detects **start and stop bits** to correctly sample incoming data.
* Works synchronously with the transmitter baud rate.

---

#### **3. baud_gen.v (Baud Rate Generator)**

This module generates the **baud rate clock** for UART communication.

* Produces timing signals required for transmitter and receiver.
* Supports common UART baud rates.
* Ensures proper synchronization between TX and RX.

---

#### **4. uart_top.v (Top-Level UART Module)**

This module integrates the **UART transmitter, receiver, and baud generator**.

* Connects TX and RX with the baud generator.
* Provides a single interface for UART operation.
* Can be instantiated in larger digital systems.

---

#### **5. uart_tb.v (Testbench)**

This module is the **testbench** for UART design.

* Generates clock and test signals.
* Sends test data to transmitter.
* Monitors received data to verify correct operation.
* Used for simulation and debugging.

---

## **4. GETTING STARTED**

---

```
git clone https://github.com/SyedaEshal26/UART.git
cd UART
```

---

## **5. USAGE**

---

1. Open **ModelSim / Quartus Prime / Vivado**.
2. Create a new project.
3. Add all Verilog files from **Design** and **Testbench** folders.
4. Compile the design.
5. Run the testbench (*uart_tb.v*).
6. Observe transmitted and received data waveforms.

---

## **6. CONTRIBUTING**

---

If you would like to contribute to this project, please fork the repository and submit a pull request.

---


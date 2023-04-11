# Digital Signal Repeater
A Signal repeater built in SystemVerilog that hasn't been synthesized (but should be able to I hope) as I do not own an FPGA or equipment to test it.

Functions:
Generate a signal that is approximately identical to the input signal (same frequency and phase)

Limitations (theoretical and estimated, haven't spent time analysing the system):
- Only works with signals with ~50% duty cycle
- The input signal's period should not equal or exceed 2*N_BIT times of the base clock period
- The output signal always has a delay of 1 cycle off the base clock signal
- Haven't accounted for setup and hold times (assumed the signals are perfect)

Summary of how this works:

There are 2 modules in the system.
  - Phase Frequency Detector
  - Signal generator
  
The PFD compares returns the frequency value of the main input signal by comparing it to the base clock frequency, using a counter.
It detects the lead-lag of the two input signals (main and feedback).
It also returns the difference between the two signals, by using counters again.

The signal generator generates and approximate frequency that matches the frequency value from the PFD. (Approximate because it is digital and is synchronous to the base clock frequency)
It will attempt to correct its phase by delaying or speeding the signal using info from the PFD.

Sample results using pll_d_test.sv where freq_in is the input signal and freq_sync is the output signal:
![image](https://user-images.githubusercontent.com/99904618/231065873-97bb34b0-ff60-4592-a1c9-671f09b54b70.png)

To do soon:
  Have it generate a different frequency to the input and still be in phase (like an actual PLL)


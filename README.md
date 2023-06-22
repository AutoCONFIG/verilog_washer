# 基于Verilog HDL硬件描述语言的洗衣机控制电路
The realization of washing machine controller with verilog
## 使用方式
* 添加到Modelsim工程中，并执行仿真代码；
## 项目简述
* 本项目工程简单，适用于Verilog HDL学习和教学。
* 关键代码由状态机实现，具体状态可查阅代码（S0-S6 && M0-M3）。
* 输入控制信号为select、emergency，rst，start，clk，分别为洗衣机模式选择，紧急模式急停，复位，启动洗衣机，时钟。
* 行为级代码。
* testbench代码已完善，可直接仿真运行。

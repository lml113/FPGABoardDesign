# FPGABoardDesign
## FPGA开发板设计（自制FPGA开发板）
FPGA芯片：EP4CE10F17C8N  
开发板功能：
1. 流水灯
2. 按键
3. 数码管
4. 串口（ch340）
5. 蜂鸣器
6. 百兆网通信（芯片：RTL8201CP）
7. VGA（RGB888）(芯片：SDA7123)
8. LCD（电路有问题，需要特定的转接板）
9. SDRAM(256MB内存)
10. 摄像头接口  

扩展模块：
1. USB转百兆网：可直接用于USB连接网线。
2. SDRAM模块
3. LCD驱动模块（转接板）
4. VGA模块（可实现RGB888）
5. AD/DA模块（AD9280/AD9708，对应正点原子的AD/DA模块）
6. 千兆网模块（还未测试）

## FPGA代码只有一些，不全！！！ 
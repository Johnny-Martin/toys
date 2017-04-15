#ifndef MYCONFIG_H
#define MYCONFIG_H

/* **************************************************************** */
/* **************************************************************** */
// 可随便改
/* **************************************************************** */
/* **************************************************************** */

// Define this to set a custom name for your generic Mendel,
// 
#define MY_CUSTOM_MENDEL_NAME "MARK 350"







/* **************************************************************** */
/* **************************************************************** */
// 需自己测量改动的
/* **************************************************************** */
/* **************************************************************** */

// Center-to-center distance of the holes in the diagonal push rods.
// 碳杆长度，从一端球中心到另一端球中心的距离(用于调整打印长宽，如增加此值1下一行数值约加0.25，用于维持喷头直线移动)
// 此值调大,将会尺寸减小
#define MY_DELTA_DIAGONAL_ROD 418//430//351.5//215.78 // 215.5//217mm

// Horizontal offset from middle of printer to smooth rod center.
// 打印头到滑杆水平距离(喷头平移时如是凹凸不平地移动，可调此值,中间低调小)
#define MY_DELTA_SMOOTH_ROD_OFFSET 289.5//265.5 //248.5 //251.7 mm

// Horizontal offset of the universal joints on the end effector.
// 效应器球中心和打印头的水平距离
#define MY_DELTA_EFFECTOR_OFFSET 34 //39 //35 mm

// Horizontal offset of the universal joints on the carriages.
// 滑车球中心到滑杆水平距离
#define MY_DELTA_CARRIAGE_OFFSET 17.5//0 // mm 17//6.5 20.2

// Print surface diameter/2 minus unreachable space (avoid collisions with vertical towers).
// 打印半径？
#define MY_DELTA_PRINTABLE_RADIUS 175

// these are the offsets to the probe relative to the extruder tip (Hotend - Probe)//Ztanzheng
// 自动调平探针xyz的偏移
#define MY_X_PROBE_OFFSET_FROM_EXTRUDER 0
#define MY_Y_PROBE_OFFSET_FROM_EXTRUDER -30
#define MY_Z_PROBE_OFFSET_FROM_EXTRUDER -1.56 //-7.6

// For deltabots this means top and center of the Cartesian print volume.
// xyz轴Home位置
#define MY_MANUAL_X_HOME_POS 0
#define MY_MANUAL_Y_HOME_POS 0
#define MY_MANUAL_Z_HOME_POS 570//499//499.95 //502.05//221.3//211  60 227.2  jhead 234.3// For delta: Distance between nozzle and print surface after homing.

// 回Home的速度控制，速度单位:毫米/秒
// 这个参数建议改改，原来的数值是200，你装好一按HOME，滑车就会高速撞到顶部（或底部，步进装反了），改小点滑车的速度就慢点安全点
#define MY_HOMING_FEEDRATE_SPEED 40 // set the homing speeds (mm/second)





/* **************************************************************** */
/* **************************************************************** */
// 一般不需要改动的
/* **************************************************************** */
/* **************************************************************** */

// 串口通讯速率，一般不动，除非你想装wifi串口或蓝牙串口模块
#define MY_BAUDRATE 250000

// xyz三个步进设置，直接用，不改了
#define MY_XYZ_PULLEY_TEETH 16
#define MY_DEFAULT_AXIS_STEPS_PER_UNIT_E  158
#define MY_DEFAULT_MAX_FEEDRATE          {999, 999, 999, 999}    // (mm/sec)


#endif //__MYCONFIG_H



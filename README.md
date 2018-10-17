# MZCalendarKit
日历控件
功能：
1，启动时显示当月日期
2，可以查看上一个月和下一个月的日期
3，可以进行日期选择
4，历史日期不可以选择
5，特殊需求：日期下面显示小红点

实现思路：
1，用UICollectionView进行布局
2，根据日期获取当前月份的总天数
3，计算当前月份的第一天是周几
4，数据填充

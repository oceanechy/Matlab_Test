clear all
f=9e8; %发射信号频率
v=0; %移动台速度，静止情况为 0
c=3e8; %电磁波速度，光速
r0=3000; %移动台距离基站初始距离
d=15000; %基站距离反射墙的距离
t1=0:0.00000000005:0.00000002; %时间维度
E1=cos(2*pi*f*((1-v/c).*t1-r0/c))./(r0+v.*t1); %直射径信号
E2=cos(2*pi*f*((1+v/c).*t1+(r0-2*d)/c))./(2*d-r0-v*t1); %反射径信号
figure
plot(t1,E1,t1,E2,'-g',t1,E1-E2,'-r') %画出直射径、反射径和总的接收信号
legend('直射径信号','反射径信号','移动台接收的合成信号')
figure
plot(t1,E1-E2) %移动台接收信号
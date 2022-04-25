clear all;
% ���������ź�
n = 0:511%��������Ϊ512
f1=0.1;
f2=0.3;
N = 30; %�����˲����Ľ���Ϊ30
w = zeros(N,512);%���˲����ĳ�ʼֵ����Ϊ0
en = zeros(512,1);%����ʼ�������Ϊ0
xN=zeros(N,512);%xNΪ�����źŵ�NΪ���������źŹ�512�����������nȡֵ���Դﵽ512����ΪN*512�׾���
%���������˲����Ĳ���

xn= 10*10*sin(2*pi*f1*n+pi/3)+2*sin(2*pi*f2*n+pi/4);;%xnΪf1=0.1��f2=0.3�����źŵ���
xs = randn(1,512);%����һ��1��512��С�������źţ�����Ϊ[0,1]
%���������ź�
fn = xs+xn;%xs+xn�õ������ź�fn
fn = fn';%�������ź���������ת��Ϊ������
dn = xn';%�������ź���������ת��Ϊ������
R=fn*fn';
fe = max(eig(R));%�������fn������ؾ�����������ֵfe
u = 1/(2*fe);%u<1/Rmax����,RΪ����ؾ�������ֵ
%����LMS�㷨ʵ���˲�
for k = 30:512    %Ҫ��֤������ʱ����ź���Ч������ʵ�ʵĵ�������ֻ�У�482���Σ�
   %�������ź��ӳ٣�ʹ���˲�����ÿ����ͷ��������
    for i=1:30
        xN(i,k)=fn(k+1-i);
    end
    y = w(:,k-1).'*xN(:,k);  %������˲��������
    en(k) = dn(k)-y;   %�ó�����źţ�dnΪ�����ź�ת�ü�Ϊxn��
    w(:,k) = w(:,k-1)+u*en(k)*xN(:,k);%���������˲�����ϵ��
end
%�˲��������̶��󣬵ó������Ż��˲����˲��������ź�
for k = 30:512
    %�������ź��ӳ٣�ʹ���˲�����ÿ����ͷ��������
    for i=1:30
        xN(i,k)=fn(k+1-i);
    end
    yn(k) = w(:,k).'*xN(:,k);%������ź�yn
end
    

figure(1);
subplot(2,1,1);
grid;%��ʾ����
plot(n,xn);
title("�����ź�");
subplot(2,1,2);
grid;%��ʾ����
plot(xs);
title("�������");
figure(2);
subplot(2,1,1);
grid;
plot(fn);%���������˲����ź�
title('�����˲������ź�');
subplot(2,1,2);
grid;
plot(yn);%���ƾ����˲����˲����ź�
title('�˲�����ź�');
figure(3);
grid;
plot(n,xn,'red',n,yn,'blue',n,en,'yellow');%���������źţ�����źţ�����ź�
legend('�˲����������ź�','�˲���������ź�','����ź�');
title('�����źŵıȽ�');
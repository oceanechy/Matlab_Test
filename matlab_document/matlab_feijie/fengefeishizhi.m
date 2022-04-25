clear all;
clc;
tic
for q =1:1
    str1 = num2str(q);
    %jpg���ݸ�ʽ�Ĵ洢·��
    str2 = 'I:\LIDC_feijie\0001-0050\LIDC-IDRI-000';
    str3 ='\*.jpg';
    str4 ='\';
    %�ָ�÷�ʵ�ʺ��ͼƬ�洢·��
    str5='I:\LIDC_feijie\0001-0050_fenge\000';
    str_imagedir = strcat(str2,str1,str3);
    str_dirname = strcat(str2,str1,str4);
    str_write= strcat(str5,str1,str4);
    %disp(str_imagedir)
    %disp(str_dirname)
    %disp(str_write)7
    imagelist = dir(str_imagedir);

    for i = 1:length(imagelist)
        name = imagelist(i).name;
        dirname = [str_dirname,name];
%B=imread(dirname);%��ȡԭͼ��
% B=rgb2gray(A);%��ԭͼ��ת��Ϊ�Ҷ�ͼ��
    A=imread(dirname);
    B=rgb2gray(A);
%subplot(2,2,1),imshow(B,[]),title('DICOMͼ�������ʾ');
% figure,imshow(B),title('ͼ�������ʾ');
%====================================================
    min(min(B));
    max(max(B));
    t=graythresh(B);%������ֵt
    C=im2bw(B,t);%������ֵ��ֵ��ͼ��
% figure(),imshow(C,[]),title('��ʾ��ֵ��ͼ��');
% C=bwareaopen(C,6000);%ȥ�����С��T�Ĳ��֣����ܣ���%%%%%%%%%�ڷ�ʵ�ʱȽϴ��ʱ�򣬶��Ҳ���������ֶι��죬���Ϊ10000

    D=imfill(C,4,'holes');%�Զ�ֵ�����ͼ������ʵ��

% figure(),imshow(D,[]),title('��ʾ����ʵ��ͼ��');
    E=D-C;%�õ���ʵ�ʵ�ͼ��E
% figure(),imshow(E,[]),title('��ʾ��ʵ�ʵ�ͼ��');
    F=imfill(E,8,'holes');%����ʵ�ʿն�
%  FMask=bwareaopen(F,1000);%ȥ�����С��T�Ĳ��֣����ܣ���%%%%%%%%%�ڷ�ʵ�ʱȽϴ��ʱ�򣬶��Ҳ���������ֶι��죬���Ϊ4600
    FMask=bwareaopen(F,6000);%ȥ�����С��T�Ĳ��֣����ܣ���%%%%%%%%%�ڷ�ʵ�ʱȽϴ��ʱ�򣬶��Ҳ���������ֶι��죬���Ϊ4600
%  figure(),imshow(FMask,[]),title('��ʾ����');%�õ���Ĥ

%-------------------------�ֿ����ҷ�----------------------------------------
    r_ball=90;%�ɱ�ģ�ȡֵΪ10/15,ԽСԽϸ��
    se_ball=strel('ball',r_ball,10);%��Բ��뾶10���߶�10
    r_disk=ceil(r_ball/6);%Բ��r_ball/6�õ����ڻ����������ӽ�������ceilȡ��
        if r_disk==0;
            r_disk=1;%��СΪ1
        end
    se_erode=strel('disk',r_disk,0); %Բ�ΰ뾶
    mask=imopen(FMask,1);%������
% figure(),imshow(mask,[]);

    L=bwlabel(FMask);   %��ѧ��̬�ؽ��������������㣬�������Զ�ֵͼ���ǣ���ͼ��ֳɶ������
%stat = regionprops(FMask);%,����ͼ������������������ͨ��objectΪ��ֵͼ��
    [row,col]=size(B);
%im2bw��Convert image to binary image, based on threshold
%im2bwĬ��threshold0.5���õ�512*512�վ���
    mask_leftlung=im2bw(zeros(row,col));%�����Ĥ
    mask_rightlung=im2bw(zeros(row,col));%�ҷ���Ĥ
        for i=1:row
            for j=1:col
                if L(i,j)==1 %��������
                    mask_leftlung(i,j)=1;% �ֿ����ҷΣ����ǰ�ɫ��
                end
                if L(i,j)==2
                    mask_rightlung(i,j)=1;
                end
            end
        end

% figure(),imshow(mask_leftlung,[]);title('���������ʾ')
% figure(),imshow(mask_rightlung,[]);title('�ҷ�������ʾ')

%----------------------������޲�-------------------------------------------
    object1=1-mask_leftlung; %��η���
% figure();imshow(object1,[]);title('��η������ʾ')
    object2=imopen(object1,se_ball);%����������Բ��뾶30���߶�10
% figure();imshow(object2,[]);title('�������ģ����Ӱͼ��ʾ')   %�õ��������ģ����Ӱͼ
    leftmask1=1-object2;%���ģ����Ӱͼ  
% figure();imshow(leftmask1,[]);title('���ģ����Ӱͼ��ʾ')

    leftmask2=im2bw(leftmask1,0.5);%������ֵ0.5��ͼ�����ɶ�ֵͼ��
%figure();imshow(leftmask2,[]);title('���������ֵͼ����ʾ')
%%�õ���������Ķ�ֵͼ��֧������ȥ�ˣ���ڵ�ë��Ҳ��������ڱ�С������ν������޲�
    leftmask3=imfill(leftmask2,'hole');  %������ʵ�ʿն�
% figure();imshow(leftmask3,[]),title('������ʵ�ʺ���ʾ'); %ֻ����������ʵ�ʣ��õ���ƽ�������ͼ��  
    leftmask4=imerode(leftmask3,se_erode);%��ʴ��β������ν�ڴ��˵㣬ƽ������
% figure();imshow(leftmask4,[]),title('leftlungmask');%�õ�ƽ��Ч��ͼ��

%---------------------���ؿն�----------------------------------------------
    ConvHull=bwconvhull(leftmask4,'object');%�����������͹��
%figure();imshow(ConvHull,[]),title('͹��ͼ��');
    DIF_ConvHull=ConvHull-leftmask4;%������ȱ�ڲ���ȡ����
%figure();imshow(DIF_ConvHull,[]),title('�����ԭͼ��ֵͼ��');
    BW1 = bwconncomp(DIF_ConvHull);%������ͨ��������͹��
    stats = regionprops(BW1, 'Area','Eccentricity');%���ÿ����ͨ��������������
    idx = find([stats.Area] > 80 & [stats.Eccentricity] < 0.8); 
% % % % BW2 = ismember(labelmatrix(BW1), idx);%ȡ������Ҫ�������
% % % % figure();imshow(BW2,[]),title('�������Ҫ���Ĳ�����ʾ');
% % % % leftmask5=BW2+leftmask4;%������Ҫ������򡰲��������������
%figure();imshow(leftmask5,[]),title('��ʾ���յ��������');
%---------------------���ҷ��޲�--------------------------------------------
    object1=1-mask_rightlung; %��ת�ҷ�����
    %figure();imshow(object1,[]);title('�ҷη������ʾ')
    object2=imopen(object1,se_ball);%������
 %figure();imshow(object2,[]);title('�����ҷ�ģ����Ӱͼ��ʾ')   %�õ������ҷ�ģ����Ӱͼ
    rightmask1=1-object2;%�õ��ҷ�ģ����Ĥ����ת������ʵ��Ϊ��ɫ
 %figure();imshow(rightmask1,[]);title('�ҷ�ģ����Ӱͼ��ʾ')

    rightmask2=im2bw(rightmask1,0.5);%�ҷ�ת��Ϊ��ֵͼ��
 %figure();imshow(rightmask2,[]);title('�ҷ�������ֵͼ����ʾ')
    rightmask3=imfill(rightmask2,'hole');%����ҷ�ʵ�ʿն�
 %figure();imshow(rightmask3,[]),title('����ҷ�ʵ�ʺ���ʾ');
    rightmask4=imerode(rightmask3,se_erode);%��ʴ������ƽ������
%  figure();imshow(rightmask4,[]),title('rightlungmask');
 
% % %  lungmask=im2bw(leftmask5+rightmask4);%�����ҷκϲ����õ�ȫ����Ĥ
    lungmask=im2bw(leftmask4+rightmask4);%�����ҷκϲ����õ�ȫ����Ĥ
    lung=immultiply(lungmask,B);%����,�õ����ǻҶ�ֵ��0��max-min+1�ĻҶ�ͼ��
 %dicomwrite(lung,'E:\1_��ҵ���\images_CT\S60\I00');%dicomwrite()������lung����Դͼ����ȡ�����ķ�ʵ�ʣ�ͼ�񱣴�Ϊdicom�ļ���ʽ�������´�ʹ��
 %subplot(2,2,2),imshow(lung,[]),title('��ȡ�ķ�ʵ��');
 %figure;imshow(lung,[]),title('��ȡ�ķ�ʵ��');
%name = + name;
    feishizhi = [str_write,name];
    imwrite(lung,feishizhi);
%break
    end
end    

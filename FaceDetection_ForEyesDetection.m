function [aa]=FaceDetection_ForEyesDetection(I,iteration)
%%%%% Reading of a RGB image
%clc;        close all;      clear
%data_number = 42;
%for iteration=1:data_number
 % eval(['I=imread(''Image',num2str(iteration,'%03d'),'.jpg''' ');']);

%I=imread('Image008.jpg');
%I2=rgb2gray(I);
level = graythresh(I);
BW=im2bw(I,level);
%figure('visible','off')
%subplot(1,2,1)
%imshow(BW) ;colorbar; title('Original')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% minimisation of background portion

[n1 n2]=size(BW);
r=floor(n1/10);
c=floor(n2/10);
x1=1;x2=r;
s=r*c;

for i=1:10
    y1=1;y2=c;
    for j=1:10
        if (y2<=c || y2>=9*c) || (x1==1 || x2==r*10)
            loc=find(BW(x1:x2, y1:y2)==0);
            [o p]=size(loc);
            pr=o*100/s;
            if pr<=100
                BW(x1:x2, y1:y2)=0;
                r1=x1;r2=x2;s1=y1;s2=y2;
                pr1=0;
            end
           % imshow(BW);
        end
            y1=y1+c;
            y2=y2+c;
    end
    
 x1=x1+r;
 x2=x2+r;
end
% subplot(1,2,2)
%  imshow(BW);colorbar; title('minimize background')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% detection of face object

L = bwlabel(BW,8);
BB  = regionprops(L, 'BoundingBox');
BB1=struct2cell(BB);
BB2=cell2mat(BB1);

[s1 s2]=size(BB2);
mx=0;
for k=3:4:s2-1
    p=BB2(1,k)*BB2(1,k+1);
    if p>mx & (BB2(1,k)/BB2(1,k+1))<1.8
        mx=p;
        j=k;
    end
end
%figure('visible','off'),imshow(I);
%hold on;
%rectangle('Position',[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)],'EdgeColor','r' );
aa=imcrop(uint8(I),[BB2(1,j-2),BB2(1,j-1),BB2(1,j),BB2(1,j+1)]);
aa = imresize(aa,[280,180]);
%Result = Detect_Eyes(aa);
%figure('visible','off');
%imshow(aa);colorbar;title('face-extracting')
disp(sprintf('FaceDetection_ForEyesDetection'));
%imwrite(aa,['Image',num2str(iteration,'%03d'),'.jpg']);



imwrite(aa,strcat('D:\Documents\Laboratory\Research\new_step\EigenFace\ResultImage\CropFace\',['Image',num2str(iteration,'%03d'),'.jpg']));





end

%imwrite(aa,['Image',num2str(iteration+50,'%03d'),'.jpg']);
%end
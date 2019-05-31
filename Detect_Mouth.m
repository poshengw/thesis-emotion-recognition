function [result_figure]=Detect_Mouth(I)

I = FD(I);
% srcDir = 'C:\Users\michael\Desktop\facial-expression recognition\OpenSource\open source\Using\Work now\opensource_itself\Facial Exp Projects\EigenFace\Train\detectFaceParts20140113\';
% fList = ls([srcDir '*.jpg']);

% for iteration=1:42
%   fName = fList(iteration,:);
%   I = imread(fName);
    
l = size(I,1);
w = size(I,2);

mouth_wide = w*(2/3);
mouth_length = l*(3/10);
x = 0 + w*(1/6);
y = 0 + w*(8/10);
newimg = imcrop(I, [x y mouth_wide mouth_length]);
% original_newimg = newimg;
I2=double(newimg);
C=255*imadjust(I2/255,[0.3;1],[0;1]);

hsv= rgb2hsv(C);

Hue = hsv(:,:,1);
Saturation=hsv(:,:,2);


H=size(I2,1);
W=size(I2,2);

%%
% S = UsingGraythresh(Hue);
%%
S=zeros(H,W);
[SkinIndexRow,SkinIndexCol] =find(0.04313<= Hue & 0.3098 >= Hue);
for p=1:length(SkinIndexRow)
    S(SkinIndexRow(p),SkinIndexCol(p))=1;
end
%%
m_S = size(S);
S(m_S(1)-7:m_S(1),:) = 0;
SN=zeros(H,W);
for i=1:H-5
    for j=1:W-5
        localSum=sum(sum(S(i:i+4, j:j+4)));
        SN(i:i+5, j:j+5)=(localSum>20);
    end
end

%%
Iedge=edge(uint8(SN));
SE = strel('square',9);
SN_edge = (imdilate(Iedge,SE));
SN_fill = imfill(SN_edge,'holes');
[L,lenRegions] = bwlabel(SN_fill,4); %connecting 

AllDat  = regionprops(L,'BoundingBox','FilledArea');
AreaDat = cat(1, AllDat.FilledArea);
[maxArea, maxAreaInd] = max(AreaDat);

FaceDat = AllDat(maxAreaInd);
FaceBB = [FaceDat.BoundingBox(1),FaceDat.BoundingBox(2),...
    FaceDat.BoundingBox(3)-1,FaceDat.BoundingBox(4)-1];

%aa=imcrop(rgb2gray(uint8(I2)).*uint8(SN_fill),FaceBB);

result_figure=imcrop(rgb2gray(uint8(newimg)),FaceBB);
%%imshow(bb)
disp(sprintf('Through Detect Mouth'));
% imwrite(bb,['Image',num2str(iteration+100,'%03d'),'.jpg']);
end
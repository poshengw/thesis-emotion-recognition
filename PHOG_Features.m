function[P]=PHOG_Features(I)


%I = imread('01.jpg');
bin = 8;
angle = 360;
L = 3;

%% Create Describ Matrix

% make sure the image is gray
if size(I,3)==3         
    Img = rgb2gray(I);
else
    Img = I;
end

% Canny Edge
EdgeImage = edge(Img,'canny');
% Gradient
[GradientX,GradientY] = gradient(double(Img));
Magnitude = sqrt((GradientX.*GradientX)+(GradientY.*GradientY));
YX = GradientY./GradientX;
if angle ==180
    TanAngle = (atan(YX)+ (pi/2))*180/pi;
end
if angle ==360
    TanAngle = ((atan2(GradientY,GradientX)+pi)*180)/pi;
end


[connection,n] = bwlabel(EdgeImage);
Width = size(EdgeImage,2);
Length = size(EdgeImage,1);
HisAngle = zeros(Length,Width);
HisMagnitude = zeros(Length,Width);


SepAngle = angle/bin;

for i=1:n
    [posY,posX] = find(connection==i);
   for j=1:size(posY,1)
       pos_x = posX(j,1);
       pos_y = posY(j,1);
       
       ClassAngle = ceil(TanAngle(pos_y,pos_x)/SepAngle);
      % if Magnitude(pos_y,pos_x)>0
           HisAngle(pos_y,pos_x) = ClassAngle;
           HisMagnitude(pos_y,pos_x) = Magnitude(pos_y,pos_x);
       %end
   end
end
       
PlotHist = reshape(HisAngle,1,Length*Width);
%hist(PlotHist,0:bin);
%AngleClassResult= hist(PlotHist,0:bin);

%% Compute Pyramid Histogram of Oriented


P = [];
% Level 0

for b=1:bin
    ind = HisAngle==b;
    P = [P;sum(HisMagnitude(ind))];
    %figure(1)
   % bar(P);
end

cella=1;
for level = 1:L
    x = fix(size(HisAngle,2)/(2^level));
    y = fix(size(HisAngle,1)/(2^level));
    xx=0;
    yy=0;
    while xx+x<=size(HisAngle,2)
        while yy+y<=size(HisAngle,1)
            HisAngle_cella=[];
            HisMagnitude_cella = [];
            
            HisAngle_cella = HisAngle(yy+1:yy+y,xx+1:xx+x);
            HisMagnitude_cella = HisMagnitude(yy+1:yy+y,xx+1:xx+x);
             
             for b=1:bin
                 ind = HisAngle_cella==b;
                 P = [P;sum(HisMagnitude_cella(ind))];
             end
             yy=yy+y;
        end
        cella=cella+1;
        yy=0;
        xx=xx+x;
    end
   % figure(level+1);
  %  bar(P)
end
%% Normolize 
if sum(P)~=0
    P = P/sum(P);
end

end
%%

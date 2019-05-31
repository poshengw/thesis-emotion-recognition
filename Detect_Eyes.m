function [result_figure,I2]=Detect_Eyes(II,iteration)


I2 = FaceDetection_ForEyesDetection(II,iteration);


Detector = vision.CascadeObjectDetector('EyePairBig');
Detector.MinSize = [11 45];
%srcDir ='C:\Users\michael\Desktop\facial-expression recognition\OpenSource\open source\Using\Work now\opensource_itself\Facial Exp Projects\EigenFace\Train\';
%fList = ls([srcDir '*.jpg']);

%for i=1:42
   % fName = fList(i,:);
    % bodyDetector.MergeThreshold = 10;
    
    bb = step(Detector, I2);
    IFace = 0*I2;
    AArea=zeros();
    
    if size(bb,1)>1
      for a = 1:size(bb,1)
      AArea(a) = bb(a,3)*bb(a,4);
      end
       max_area = max(AArea);
       rw = find(AArea==max_area);
       bb = bb(rw,:);
    end
  
%     bb(1:2)= bb(1:2) + ones(1,2)*(-20);
%     bb(3:4)= bb(3:4) + ones(1,2)*(30);
%     yRange = bb(1,1):bb(1,1)+bb(1,3);
%     xRange = bb(1,2):bb(1,2)+bb(1,4);
      
    bb(1:2)= bb(1:2) + ones(1,2)*(-20);
    bb(3:4)= bb(3:4) + ones(1,2)*(30);

    yRange = bb(1,1):bb(1,1)+bb(1,3);
    xRange = bb(1,2):bb(1,2)+bb(1,4);
    
    max_yRange = max(size(I2,2));
    over_y_max = find(yRange>max_yRange);
    yRange(over_y_max) = size(I2,2);
  
     min_yRange = 1;
    over_y_min = find(yRange<min_yRange);
    yRange(over_y_min) = 1;
    
       
    max_xRange = max(size(I2,1));
    over_x_max = find(xRange>max_xRange);
    xRange(over_x_max) = size(I2,1);
    
     min_xRange = 1;
    over_x_min = find(xRange<min_xRange);
    xRange(over_x_min) = 1;
    
    new_bb = [yRange(1),xRange(1),yRange(end)-yRange(1),xRange(end)-xRange(1)];
    
    IFace(xRange,yRange,:) = I2(xRange,yRange,:);
    %r_figure = rgb2gray(IFace);
    r_figure = IFace;
    result_figure=imcrop(r_figure, new_bb);
    assignin('base','bb',bb);
    disp(sprintf('Through Detect_Eyes'));
    
    
   imwrite(result_figure,strcat('C:\Users\michael\Desktop\Auto_JapanDatabsed\ResultImage\CropEyes\',['Image',num2str(iteration,'%03d'),'.jpg']));
    
    
end
    %IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
    %figure(i)
   % imshow(IFace);
   % title('Detected faces');
    
 %   imwrite(IFace,['Image',num2str(i+50,'%03d'),'.jpg']);
%end
%
%   bodyDetector = vision.CascadeObjectDetector('UpperBody');
%    bodyDetector.MinSize = [60 60];
%    bodyDetector.MergeThreshold = 10;
%      I2 = imread('visionteam.jpg');
%    bboxBody = step(bodyDetector, I2);
%     IBody = insertObjectAnnotation(I2, 'rectangle',bboxBody,'Upper Body');
%    figure, imshow(IBody), title('Detected upper bodies');
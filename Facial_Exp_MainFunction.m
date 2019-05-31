clc;    close all;   clear;
strTrainPath = 'C:\Users\michael\Desktop\new_step\EigenFace\ImageDataBase\IndMan\3_Add_Both_Ambtuity\Train';
strLabelFile = 'LabelFile_Nov_TF.txt';
strTestPath = 'C:\Users\michael\Desktop\new_step\EigenFace\ImageDataBase\IndMan\3_Add_Both_Ambtuity\Test';



fid=fopen(strLabelFile);
imageLabel=textscan(fid,'%s %s','whitespace',',');
fclose(fid);

NeutralImages=[];
for i=1:length(imageLabel{1,1})
    if (strcmp(lower(imageLabel{1,2}{i,1}),'neutral'))
        NeutralImages=[NeutralImages,i];
    end 
end
if (length(NeutralImages)==0)
    disp('ERROR: Neutral Expression is not available in training');
    return;
end

structTestImages = dir(strTestPath);
numImage = length(imageLabel{1,1});  % Total Observations: Number of Images in training set
lenTest = length(structTestImages);

if (lenTest==0)
    disp('Error:Invalid Test Folder');
    return;
end

TrainImages='';
for i = 1:numImage
	TrainImages{i,1} = strcat(strTrainPath,'\',imageLabel{1,1}(i));
end

j=0;
for i = 3:lenTest
     if ((~structTestImages(i).isdir))
         if  (structTestImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             TestImages{j,1} = [strTestPath,'\',structTestImages(i).name];
         end
     end
end
numTestImage = j; % Number of Test Images
clear ('structTestImages','fid','i','j');pack






imageSize = [280,180];          % All Images are resized into a common size

%% ################# Load Train Data & Preprocess  ########################
%% Loading training images & preparing for PCA by subtracting mean

img = zeros(imageSize(1)*imageSize(2),numImage);
writ_num=1;
for i = 1:numImage
    % Detect_Face 
    [Faces_crop] = FaceDetection(imresize(imread(cell2mat(TrainImages{i,1})),[375,300]));
    aa = imresize(Faces_crop,imageSize);
    % Detect_Eyes
    %Eyes_crop,Faces_crop] = FaceDetection(imresize(imread(cell2mat(TrainImages{i,1})),[375,300]));
    %aa = imresize(Eyes_crop,imageSize);
        
    imwrite(aa,['Train_Image',num2str(writ_num,'%03d'),'.jpg']);
    %imwrite(Faces_crop,['Train_Image',num2str(writ_num+100,'%03d'),'.jpg']);
    writ_num = writ_num+1;
    
    img(:,i) = aa(:);
    disp(sprintf('Loading Train Image # %d',i));
end
meanImage = mean(img,2);        
                 
img = (img - meanImage*ones(1,numImage))';      % img is the input to PCA
%% ########################################################################

%% ################# Low Dimension Face Space Construction ################
[C,S,L]=princomp(img,'econ');                   % Performing PCA Here
EigenRange = [1:30];   % Defines which Eigenvalues will be selected
C = C(:,EigenRange);
%% ########################################################################


%% ############# Load Test Data and project on Face Space #################
img = zeros(imageSize(1)*imageSize(2),numTestImage);
writ_num=1;
for i = 1:numTestImage
    % Detect_Face 
    [Faces_crop] = FaceDetection(imresize(imread(cell2mat(TrainImages{i,1})),[375,300]));
    aa = imresize(Faces_crop,imageSize);
    % Detect_Eyes
   % [Eyes_crop,Faces_crop] = FaceDetection(imresize(imread(TestImages{i,1}),[375,300]));
   % aa = imresize(Eyes_crop,imageSize);
    
    imwrite(aa,['Test_Image',num2str(writ_num,'%03d'),'.jpg']);
   % imwrite(Faces_crop,['Test_Image',num2str(writ_num+100,'%03d'),'.jpg']);
    writ_num = writ_num+1;
    
    img(:,i) = aa(:);
    disp(sprintf('Loading Test Image # %d',i));
end
meanImage = mean(img,2);        
img = (img - meanImage*ones(1,numTestImage))';
Projected_Test = img*C;
%% ########################################################################


%% ################# Calculation of Distance from Neutral ##################
meanNutral = mean(S(NeutralImages,EigenRange)',2);
for Dat2Project = 1:numTestImage
    TestImage = Projected_Test(Dat2Project,:);
    % Picking the image #Dat2Project
 
    Eucl_Dist(Dat2Project) = sqrt((TestImage'-meanNutral)'*(TestImage' ...
        -meanNutral));
        % Here, the distance between the expression under test and
        % the mean neutral expressions is being calculated
end
%Eucl_Dist = Eucl_Dist/max(Eucl_Dist);
%% ########################################################################

%% ################# Calculation of other Distances #######################
Other_Dist = zeros(numTestImage,numImage);
for Dat2Project = 1:numTestImage
    TestImage = Projected_Test(Dat2Project,:);
    % Picking the image #Dat2Project
    for i = 1:numImage
        Other_Dist(Dat2Project,i) = sqrt((TestImage'-S(i,EigenRange)')' ...
            *(TestImage'-S(i,EigenRange)'));
    end
end
[Min_Dist,Min_Dist_pos] = min(Other_Dist,[],2);
Min_Dist_pos_for_text = Min_Dist_pos;
%%  Confusion Matrix ########################################################################

for pp = 1:size(Min_Dist_pos,1)  %compare with training data
    if Min_Dist_pos(pp)>=1 && Min_Dist_pos(pp)<=11
        Min_Dist_pos(pp) = 1;
    else if Min_Dist_pos(pp)>=12 && Min_Dist_pos(pp)<=19
            Min_Dist_pos(pp) = 2;
        else if Min_Dist_pos(pp)>=20 && Min_Dist_pos(pp)<=32
              Min_Dist_pos(pp) = 3;
            else if Min_Dist_pos(pp)>=33 && Min_Dist_pos(pp)<=42
               Min_Dist_pos(pp) = 4;
                else if Min_Dist_pos(pp)>=43 && Min_Dist_pos(pp)<=52
                  Min_Dist_pos(pp) = 5;
               end
            end
          end
        end
    end
end

g1 = Min_Dist_pos';
g2=zeros(1,49)';   % test data
g2(1:10) = 1;   %11
g2(11:17) = 2;  %5
g2(18:30) = 3;  %9
g2(31:39) = 4;  %8
g2(40:49) = 5;  %7
[ConfusingMatrix,order] = confusionmat(g1,g2);
 
accuracy = zeros();
for su=1:size(ConfusingMatrix,1)
accuracy(su) = ConfusingMatrix(su,su)/sum(ConfusingMatrix(:,su));
end
Total_Accuracy = sum(diag(ConfusingMatrix))/numTestImage;
ComG1G2 = [g2';g1];

test_happy = Min_Dist_pos(1:8);
test_disguist = Min_Dist_pos(9:12);
test_anger = Min_Dist_pos(13:19);
test_sad = Min_Dist_pos(20:25);
test_neutral = Min_Dist_pos(26:30);

assignin('base','ConMatrix',ConfusingMatrix);
assignin('base','g1',g1);
assignin('base','g2',g2);
assignin('base','accuracy',accuracy);
assignin('base','Total_Accuracy',Total_Accuracy);
assignin('base','test_happy',test_happy);
assignin('base','test_disguist',test_disguist);
assignin('base','test_anger',test_anger);
assignin('base','test_sad',test_sad);
assignin('base','test_neutral',test_neutral);
assignin('base','ComG1G2',ComG1G2);






%% ########################## Display Result ##############################
fid = fopen('Results.txt','w');
fprintf(fid,'//Test Image,Distance From Neutral, Expression,Best Match\r\n');

for i = 1:numTestImage
    b = find(TestImages{i,1}=='\');
    Test_Image = TestImages{i,1}(b(end)+1:end);
    Dist_frm_Neutral = Eucl_Dist(i);
    Best_Match = cell2mat(imageLabel{1,1}(Min_Dist_pos_for_text(i)));
    Expr = cell2mat(imageLabel{1,2}(Min_Dist_pos_for_text(i)));
    fprintf(fid,'%s,%0.0f,%s,%s\r\n',Test_Image,Dist_frm_Neutral,Expr,Best_Match);
end
fclose(fid);
%% ########################################################################
isSucceed = 1;
disp('Done')
disp('Output File = .\Results.txt');
Willexit = input('Press Enter to Quit ...','s');
%%end
clc;    close all;   clear;

Happy_Path = 'C:\Users\michael\Desktop\Auto_JapanDatabsed\AutoImage\Happy';
Disguist_Path = 'C:\Users\michael\Desktop\Auto_JapanDatabsed\AutoImage\Disgust';
Anger_Path = 'C:\Users\michael\Desktop\Auto_JapanDatabsed\AutoImage\Anger';
Sad_Path = 'C:\Users\michael\Desktop\Auto_JapanDatabsed\AutoImage\Sad';
Neutral_Path = 'C:\Users\michael\Desktop\Auto_JapanDatabsed\AutoImage\Netural';

%%  All Happy
j=0;
structHappyImages = dir(Happy_Path);
lenTest = length(structHappyImages);
for i = 3:lenTest
     if ((~structHappyImages(i).isdir))
         if  (structHappyImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             HappyImages{j,1} = [Happy_Path,'\',structHappyImages(i).name];
         end
     end
end
Num_Happy = length(HappyImages);
Ra_Happy =  randperm(Num_Happy);
%% All Disguist
j=0;
structDisguistImages = dir(Disguist_Path);
lenTest = length(structDisguistImages);
for i = 3:lenTest
     if ((~structDisguistImages(i).isdir))
         if  (structDisguistImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             DisguistImages{j,1} = [Disguist_Path,'\',structDisguistImages(i).name];
         end
     end
end
Num_Disguist = length(DisguistImages);
Ra_Disguist =  randperm(Num_Disguist);
%% All Anger
j=0;
structAngerImages = dir(Anger_Path);
lenTest = length(structAngerImages);
for i = 3:lenTest
     if ((~structAngerImages(i).isdir))
         if  (structAngerImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             AngerImages{j,1} = [Anger_Path,'\',structAngerImages(i).name];
         end
     end
end
Num_Anger = length(AngerImages);
Ra_Anger =  randperm(Num_Anger);
%% All Sad
j=0;
structSadImages = dir(Sad_Path);
lenTest = length(structSadImages);
for i = 3:lenTest
     if ((~structSadImages(i).isdir))
         if  (structSadImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             SadImages{j,1} = [Sad_Path ,'\',structSadImages(i).name];
         end
     end
end
Num_Sad = length(SadImages);
Ra_Sad =  randperm(Num_Sad);
%% All Neutral 
j=0;
structNeutralImages = dir(Neutral_Path);
lenTest = length(structNeutralImages);
for i = 3:lenTest
     if ((~structNeutralImages(i).isdir))
         if  (structNeutralImages(i).name(end-3:end)=='.jpg')
             j=j+1;
             NeutralImages{j,1} = [Neutral_Path,'\',structNeutralImages(i).name];
         end
     end
end
Num_Neutral = length(NeutralImages);
Ra_Neutral =  randperm(Num_Neutral);
%%  Create Train and Test
Train = '';
Test = '';
j=0;
k=0;
for i=1:ceil(Num_Happy/2)
    j=j+1;
    Train{j,1} = HappyImages{Ra_Happy(i),1} ;
end
for i=ceil(Num_Happy/2)+1:Num_Happy
    k=k+1;
    Test{k,1} = HappyImages{Ra_Happy(i),1} ;
end

for i=1:ceil(Num_Disguist/2)
    j=j+1;
    Train{j,1} = DisguistImages{Ra_Disguist(i),1} ;
end
for i=ceil(Num_Disguist/2)+1:Num_Disguist
    k=k+1;
    Test{k,1} = DisguistImages{Ra_Disguist(i),1} ;
end

for i=1:ceil(Num_Anger/2)
    j=j+1;
    Train{j,1} = AngerImages{Ra_Anger(i),1} ;
end
for i=ceil(Num_Anger/2)+1:Num_Anger
    k=k+1;
    Test{k,1} = AngerImages{Ra_Anger(i),1};
end

for i=1:ceil(Num_Sad/2)
    j=j+1;
    Train{j,1} = SadImages{Ra_Sad(i),1} ;
end
for i=ceil(Num_Sad/2)+1:Num_Sad
    k=k+1;
    Test{k,1} = SadImages{Ra_Sad(i),1};
end

for i=1:ceil(Num_Neutral/2)
    j=j+1;
    Train{j,1} = NeutralImages{Ra_Neutral(i),1} ;
end
for i=ceil(Num_Neutral/2)+1:Num_Neutral
    k=k+1;
    Test{k,1} = NeutralImages{Ra_Neutral(i),1};
end

%% #################   Load Train Data ################# %%
%% Loading Training Images & Preparing for PCA by Subtracting Mean
%imageSize = [280,180]; % Face Size  
%imageSize = [64,167];  % Eyes Size

Num_Train = length(Train);
%img = zeros(imageSize(1)*imageSize(2),Num_Train);
%img = zeros(imageSize(1)*imageSize(2)*48,Num_Train);

bin = 8;
L=0:3;
PHOGesc = zeros( bin*sum(4.^L),Num_Train);
winSize = 9;
%LPQdesc = zeros((280-2*fix(winSize/2))*(180-2*fix(winSize/2)),Num_Train); % Use Whole Face
%LPQdesc = zeros((64-2*fix(winSize/2))*(167-2*fix(winSize/2)),Num_Train); % Use Only Eyes 
LPQdesc = zeros(1024,Num_Train); 

decorr =0;
freqestim=1;
mode ='nh';
for i = 1:Num_Train
      %% Use PHOG and LPQ Features Whole Face 
      %%%%%%%%%% 
         %[Face_crop] = FaceDetection(imresize(imread(Train{i,1}),[375,300]),i);
         %imageSize = [280,180];
         %aa = imresize(Face_crop,imageSize);
         %%img(:,i)=anna_phog(aa,bin,360,3,[1;280;1;180]);
         %PHOGesc(:,i) = PHOG_Features(aa);
         %LPQdesc(:,i) = LPQ_Features(aa,winSize,decorr,freqestim,mode);
         %img = [PHOGesc;LPQdesc];
         %img = [LPQdesc];
         %img = [PHOGesc];
      %####
      %% Use PHOG and LPQ Features only Eyes
      %%%%%%%%%%
        [Eyes_crop] = Detect_Eyes(imresize(imread(Train{i,1}),[375,300]),i);
        imageSize = [64,168];
        aa = imresize(Eyes_crop,imageSize);
       %img(:,i)=anna_phog(aa,bin,360,3,[1;64;1;167]);
        PHOGesc(:,i) = PHOG_Features(aa);
        LPQdesc(:,i) = LPQ_Features_DeFour(aa,winSize,decorr,freqestim,mode);
        img = [PHOGesc;LPQdesc];
        %img = [LPQdesc];
        %img = [PHOGesc];
       %%    
        disp(sprintf('Loading Train Image # %d',i));
        imwrite(aa,strcat('C:\Users\michael\Desktop\Auto_JapanDatabsed\ResultImage\PCA_Input\',['Image',num2str(i,'%03d'),'.jpg']));

      %%%%%%%%%%
      %%%  Use Face as input  
      %%% [Faces_crop] = FaceDetection(imresize(imread(Train{i,1}),[375,300]));
      %%%  aa = imresize(Faces_crop,imageSize);
      %%%%%%%%%%
      
      %%%%%%%%%%   1. img size// 2. mean eigenface 
      %Use Eyes as input
      %%[Eyes_crop] = Detect_Eyes(imresize(imread(Train{i,1}),[375,300]),i);
      %%aa = imresize(Eyes_crop,imageSize);
      %%img(:,i) = aa(:);
      %%disp(sprintf('Loading Train Image # %d',i));
      %%imwrite(aa,strcat('D:\Documents\Laboratory\Research\new_step\EigenFace\ResultImage\PCA_Input\',['Image',num2str(i,'%03d'),'.jpg']));
      %%%%%%%%%%

      %%%%%%%%%%%
      %%% Use Eyes and filter bank as input
      %%%[Eyes_crop] = Detect_Eyes(imresize(imread(Train{i,1}),[375,300]));
      %%%aa = imresize(Eyes_crop,imageSize);
      %%%ImageAfterFilterBank =  FilterBank(aa);
      %%%img(:,i) = ImageAfterFilterBank(:);
      %%% disp(sprintf('Loading Train Image # %d',i))
      %%%%%%%%%%%
end
img = img';
%meanImage = mean(img,2);  
%img = (img - meanImage*ones(1,Num_Train))';      % img is the input to PCA
%% ################# Impliment PCA ################ %%
[C,S,L]=princomp(img,'econ');                   % Performing PCA Here
%[C,S,L]=princomp(img);
contribution = cumsum(L)./sum(L);
cont = find(contribution>=0.95);
EigenRange = [1:cont(1)];                            % Defines which Eigenvalues will be selected
C = C(:,EigenRange);
%% ############# Load Test Data and project on Face Space  #############%%
Num_Test = length(Test);
%img = zeros(imageSize(1)*imageSize(2),Num_Test);
%img = zeros(imageSize(1)*imageSize(2)*48,Num_Test);
bin = 8;
L=0:3;
PHOGesc = zeros( bin*sum(4.^L),Num_Test);
winSize = 9;
%LPQdesc = zeros((280-2*fix(winSize/2))*(180-2*fix(winSize/2)),Num_Test);  % Whole Face
%LPQdesc = zeros((64-2*fix(winSize/2))*(167-2*fix(winSize/2)),Num_Test);   % Eyes only 
LPQdesc = zeros(1024,Num_Test); 
decorr =0;
freqestim=1;
mode ='nh';

for i = 1:Num_Test 
      %% Use PHOG and LPQ Features Whole Face
      %%%%%%%%%% 
      % [Face_crop] = FaceDetection(imresize(imread(Test{i,1}),[375,300]),i);
      % imageSize = [280,180];
      % aa = imresize(Face_crop,imageSize);
      %%img(:,i)=anna_phog(aa,bin,360,3,[1;280;1;180]);
      % PHOGesc(:,i) = PHOG_Features(aa);
      % LPQdesc(:,i) = LPQ_Features(aa,winSize,decorr,freqestim,mode);
      % img=[PHOGesc;LPQdesc];
      %img = [LPQdesc];
      %img = [PHOGesc];
      %% Use PHOG and LPQ Features Only Eyes 
      %%%%%%%%%% 
      [Eyes_crop] = Detect_Eyes(imresize(imread(Test{i,1}),[375,300]),i);
      imageSize = [64,168];
      aa = imresize(Eyes_crop,imageSize);
      %img(:,i)=anna_phog(aa,bin,360,3,[1;64;1;167]);
      PHOGesc(:,i) = PHOG_Features(aa);
      LPQdesc(:,i) = LPQ_Features_DeFour(aa,winSize,decorr,freqestim,mode);
      img=[PHOGesc;LPQdesc];
      %img = [LPQdesc];
      %img = [PHOGesc];
      %%
      disp(sprintf('Loading Test Image # %d',i));
      imwrite(aa,strcat('C:\Users\michael\Desktop\Auto_JapanDatabsed\ResultImage\PCA_Input\',['Image',num2str(i+100,'%03d'),'.jpg']));


    %%%%%%%%%
    %%%% Use face input    
    %%% [Faces_crop] = FaceDetection(imresize(imread(Test{i,1}),[375,300]));
    %%% aa = imresize(Faces_crop,imageSize);
    %%%%%%%%%
    
    %%%%%%%%
    %%%%Use Eyes input
    %%%[Eyes_crop] = Detect_Eyes(imresize(imread(Test{i,1}),[375,300]),i+100);
    %%%aa = imresize(Eyes_crop,imageSize);
    %%%img(:,i) = aa(:);
    %%%imwrite(aa,strcat('D:\Documents\Laboratory\Research\new_step\EigenFace\ResultImage\PCA_Input\',['Image',num2str(i+100,'%03d'),'.jpg']));
    %%%%%%%% 

    %%%%%%%%
    %%%Use Eyes and filter bank
    %%%[Eyes_crop] = Detect_Eyes(imresize(imread(Test{i,1}),[375,300]));
    %%%aa = imresize(Eyes_crop,imageSize);
    %%%ImageAfterFilterBank =  FilterBank(aa);
    %%%img(:,i) = ImageAfterFilterBank(:);
    %%%disp(sprintf('Loading Test Image # %d',i))
    %%%%%%%%
end
meanImage = mean(img,2);        
img = (img - meanImage*ones(1,Num_Test))';
%img = img';
Projected_Test = img*C;
%% #################  Calculate the Distance ##################%%
Distance = zeros(Num_Test,Num_Train);
for Dat2Project = 1:Num_Test
    TestImage = Projected_Test(Dat2Project,:);
    for i = 1:Num_Train
        Distance(Dat2Project,i) = sqrt((TestImage'-S(i,EigenRange)')'*(TestImage'-S(i,EigenRange)'));
    end
end
[Min_Dist,Min_Dist_pos] = min(Distance,[],2);
MinDistPosition = Min_Dist_pos;
%% #################  Confustion  Matrix ##################%%

Num_Train_Happy = ceil(Num_Happy/2);
Num_Test_Happy = Num_Happy - Num_Train_Happy;
Num_Train_Disguist = ceil(Num_Disguist/2);
Num_Test_Disguist = Num_Disguist - Num_Train_Disguist; 
Num_Train_Anger = ceil(Num_Anger/2);
Num_Test_Anger = Num_Anger - Num_Train_Anger;
Num_Train_Sad = ceil(Num_Sad/2);
Num_Test_Sad = Num_Sad - Num_Train_Sad; 
Num_Train_Neutral = ceil(Num_Neutral/2);
Num_Test_Neutral = Num_Neutral - Num_Train_Neutral; 
for pp = 1:size(Min_Dist_pos,1)  %compare with training data
   if Min_Dist_pos(pp)>=1 && Min_Dist_pos(pp)<=Num_Train_Happy
       Min_Dist_pos(pp) = 1;
   else if  Min_Dist_pos(pp)>= (1+Num_Train_Happy) && Min_Dist_pos(pp)<=Num_Train_Happy+Num_Train_Disguist
            Min_Dist_pos(pp) = 2;
       else if Min_Dist_pos(pp)>= Num_Train_Happy+Num_Train_Disguist+1 &&  Min_Dist_pos(pp)<= Num_Train_Happy+Num_Train_Disguist+Num_Train_Anger
                Min_Dist_pos(pp) = 3;
           else if Min_Dist_pos(pp)>=Num_Train_Happy+Num_Train_Disguist+Num_Train_Anger+1 &&  Min_Dist_pos(pp)<= Num_Train_Happy+Num_Train_Disguist+Num_Train_Anger+Num_Train_Sad
                   Min_Dist_pos(pp) = 4;
              else if Min_Dist_pos(pp)>=Num_Train_Happy+Num_Train_Disguist+Num_Train_Anger+Num_Train_Sad+1 &&  Min_Dist_pos(pp)<=Num_Train_Happy+Num_Train_Disguist+Num_Train_Anger+Num_Train_Sad+Num_Train_Neutral
                       Min_Dist_pos(pp) = 5;
                  end
               end
           end
       end
   end
end          

g1 = Min_Dist_pos';
tt = [Num_Test_Happy Num_Test_Disguist Num_Test_Anger Num_Test_Sad Num_Test_Neutral];
c=1;
a=0;
g2=zeros(1,Num_Test)';
for i=1:5
    g2(a+1:a+tt(i))=c;
    c=c+1;
    a=a+tt(i);
end
[ConfusingMatrix,order] = confusionmat(g1,g2);
accuracy = zeros();

%% Accuracy of Each Expression 
for su=1:size(ConfusingMatrix,1)
accuracy(su) = ConfusingMatrix(su,su)/sum(ConfusingMatrix(:,su));
end

%% Totay Accuracy
Total_Accuracy = sum(diag(ConfusingMatrix))/Num_Test;
%% Compare the result (Row1: Test Result// Row2:The closed image from each of the Test image// Row3: What it is supposed to be )

Analysis = [g1;MinDistPosition';g2'];


function ImageAfterFilterBank = FilterBank(OriginalImage)

OriginalImage = double(OriginalImage);
OriginalImage = OriginalImage(:,:,1);

F=makeLMfilters;
[~,~,num_filters] = size(F);

ImageAfterFilterBank = zeros(size(OriginalImage,1)*size(OriginalImage,2),num_filters);
for i=1:num_filters
responses = conv2(OriginalImage,F(:,:,i),'same');
responses =  abs(responses);
ImageAfterFilterBank(:,i) = responses(:);
end

%ImageAfterFilterBank(:,1) = X(:);


end
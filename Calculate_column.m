function [S] = Calculate_column(C)

num_zero=zeros();
for i=1:size(C,2)
   e = find(C(:,i)~=0);
   num_zero(i) = length(e);
   
   if(num_zero(i) < size(C,1)*(1/3))
    C(:,i) = 0;
   end
end

S = C;


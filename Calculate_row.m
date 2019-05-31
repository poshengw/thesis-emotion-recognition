function [S] = Calculate_row(C)
num_zero_ee=zeros();
for j=1:size(C,1)
        ee = find(C(j,:)~=0);
        num_zero_ee(j) = length(ee);
        if(num_zero_ee(j) < size(C,2)*(85/100) )
        C(j,:) = 0;
        end
end
        



S = C;
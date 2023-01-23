function B = ReverseMatrix(A)

%Reverse a matrix

for j=1:size(A,1)
    
 B(j,:)=A(size(A,1)-j+1,:);   
    
    
end



end


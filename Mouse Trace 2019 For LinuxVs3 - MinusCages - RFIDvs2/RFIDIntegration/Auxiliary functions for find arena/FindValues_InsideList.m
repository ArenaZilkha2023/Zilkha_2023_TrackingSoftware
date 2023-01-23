function  Imouse=FindValues_InsideList(List,values_for_evaluation)
%find values inside a list

%Arrange variables
valuesaux=(values_for_evaluation)';%this is converted into a row
Listaux=repmat(List,1,length(valuesaux)); %List is a column
valuesaux=repmat(valuesaux,length(List),1);

%Now compare each column with each column
[row,col,v]=find(Listaux==valuesaux);

Imouse=row;

end
function centroids=Segmentation(BW,cluster)
     %Apply watershed protocol     
         %Separate the cluster
            D=-bwdist(~BW);
            L=watershed(D,8);%use the larger connectivity of 8
            BW(L==0)=0;
            
            %Calculate properties
             s=regionprops(BW,'centroid','Area');
             centroids=cat(1, s.Centroid);
       
             %% --Sometimes the watershed segments more than necessary-we will refine knowing the number of clusters
            %%--BY ASSUMING TWO CLUSTERS-
             
         
                
                if size(centroids,1)>cluster %there are more centroids that must be
                 [idx,C]=kmeans(centroids,cluster);   
                    
                  clear centroids
                  centroids=C;
                    
                end
                
                
      %If the size is 1 no more separation---ADD FOR THE FUTURE          
                
          
            
             
             
             
             
             
             
             
             

       

end
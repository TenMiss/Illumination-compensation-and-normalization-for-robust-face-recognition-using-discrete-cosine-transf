%% This function produces the zigzag coordinates
%function output = do_zigzag(X);
clear all
close all
clc
X = magic(10); 
%init operations
h = 1;
v = 1;
vmin = 1;
hmin = 1;
vmax = size(X, 1);
hmax = size(X, 2);
i = 1;
output = zeros(2, vmax * hmax);


%do the zigzag
while ((v <= vmax) & (h <= hmax))    
    if (mod(h + v, 2) == 0)                 
        if (v == vmin)       
            output(:,i) = [v;h];        
            if (h == hmax)
	      v = v + 1;
	    else
              h = h + 1;
            end;
            i = i + 1;
        elseif ((h == hmax) & (v < vmax))   
            output(:,i) = [v;h];  
            v = v + 1;
            i = i + 1;
        elseif ((v > vmin) & (h < hmax))    
            output(:,i) = [v;h];  
            v = v - 1;
            h = h + 1;
            i = i + 1;
        end       
    else                                    
       if ((v == vmax) & (h <= hmax))       
            output(:,i) = [v;h];  
            h = h + 1;
            i = i + 1;        
       elseif (h == hmin)                   
            output(:,i) = [v;h];  
            if (v == vmax)
	      h = h + 1;
	    else
              v = v + 1;
            end;
            i = i + 1;
       elseif ((v < vmax) & (h > hmin))     
            output(:,i) = [v;h];  
            v = v + 1;
            h = h - 1;
            i = i + 1;
       end
    end
    if ((v == vmax) & (h == hmax))          
        output(:,i) = [v;h];  
        break
    end

end
output
u =1;
a = zeros(size(X))
for j = 1:length(output)
    rb = output(1,j);
    cb = output(2,j);
    a(rb,cb)= u
    u = u +1;
    pause
end



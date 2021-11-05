function beta = compare(img)
     img = im2double(img);
     IMG = fliplr(img);
     [h, w] = size(img);
     sigma = var(reshape(img, [], 1), 1);
     beta = zeros(h, w);
     for i = 2:h-1
         for j = 2:w-1
             temp = IMG(i-1:i+1, j-1:j+1);
             Temp = img(i-1:i+1, j-1:j+1);
             M = (mean(mean(temp))-mean(mean(Temp))).^2;
             beta(i, j) = exp(-M/(2*sigma));
         end
     end
     
end
 
 
     
% function omap = heatmap_overlay( img , heatmap, colorfun )
function [salmap,img_thresholded] = heatmap_overlay( img , heatmap, rate, colorfun )

%
% originally part of GBVS code by Jonathan Harel
% http://www.klab.caltech.edu/~harel/share/gbvs.php
%
% special thanks to Alex G. Huth for readability of this code.
%

% img = image on which to overlay heatmap
% heatmap = the heatmap
% (optional) colorfunc .. this can be 'jet' , or 'hot' , or 'flag'


if ( strcmp(class(img),'char') == 1 ) img = imread(img); end
if ( strcmp(class(img),'uint8') == 1 ) img = double(img)/255; end

szh = size(heatmap);
szi = size(img);

if ( (szh(1)~=szi(1)) | (szh(2)~=szi(2)) )
  heatmap = imresize( heatmap , [ szi(1) szi(2) ] , 'bicubic' );
end
  
if ( size(img,3) == 1 )
  img = repmat(img,[1 1 3]);
end
  
if ( nargin == 3 )
    colorfun = 'jet';
end
colorfunc = eval(sprintf('%s(50)',colorfun));

heatmap = double(heatmap) / max(heatmap(:));
% omap = 0.8*(1-repmat(heatmap.^0.8,[1 1 3])).*double(img)/max(double(img(:))) + repmat(heatmap.^0.8,[1 1 3]).* shiftdim(reshape( interp2(1:3,1:50,colorfunc,1:3,1+49*reshape( heatmap , [ prod(size(heatmap))  1 ] ))',[ 3 size(heatmap) ]),1);
% omap = real(omap);

%====有显著性区域map得到的显著性区域
% rate=80;
 salmap=repmat( heatmap >= prctile(heatmap(:),rate) , [ 1 1 size(img,3) ] ); 
%salmap=repmat( heatmap >=mean(mean(heatmap(:))*rate) , [ 1 1 size(img,3) ] );  

% img_thresholded = img .* repmat( heatmap >= prctile(heatmap(:),rate) , [ 1 1 size(img,3) ] );  
img_thresholded = img .* double(salmap);  

clear img;
clear heatmap;


function [smap,salmap,img_threshold]= show_imgnmap2( img , smap ,rate )

%
% originally part of GBVS code by Jonathan Harel
% http://www.klab.caltech.edu/~harel/share/gbvs.php
%

smap = mat2gray( imresize(smap,[size(img,1) size(img,2)]) );
[salmap,img_threshold]=heatmap_overlay( img , smap, rate);
% imtool(img_threshold);
function [labels]=SLICOdemo(img,para)
%======================================================================
%SLICO demo
% Copyright (C) 2015 Ecole Polytechnique Federale de Lausanne
% File created by Radhakrishna Achanta
% Please also read the copyright notice in the file slicmex.c 
%======================================================================
%Input:
%[1] 8 bit images (color or grayscale)
%[2] Number of required superpixels (optional, default is 200)
%
%Ouputs are:
%[1] labels (in raster scan order)
%[2] number of labels in the image (same as the number of returned
%superpixels
%
%NOTES:
%[1] number of returned superpixels may be different from the input
%number of superpixels.
%[2] you must compile the C file using mex slicmex.c before using the code
%below
%----------------------------------------------------------------------
% How is SLICO different from SLIC?
%----------------------------------------------------------------------
% 1. SLICO does not need compactness factor as input. It is calculated
% automatically
% 2. The automatic value adapts to the content of the superpixel. So,
% SLICO is better suited for texture and non-texture regions
% 3. The advantages 1 and 2 come at the cost of slightly poor boundary
% adherences to regions.
% 4. This is also a very small computational overhead (but speed remains
% almost as fast as SLIC.
% 5. There is a small memory overhead too w.r.t. SLIC.
% 6. Overall, the advantages are likely to outweigh the small disadvantages
% for most applications of superpixels.
%======================================================================
%img = imread('someimage.jpg');
[labels, numlabels] = slicomex(img,para);%numlabels is the same as number of superpixels
M=max(labels(:));
IMG=img;
[h,w,p]=size(img);
if(p==1)
    for k=0:M
    I=zeros(h,w);
    I(labels==k)=255;
    E=edge(I);
    IMG(E==1)=255;
    end
else
    for k=0:M
    I=zeros(h,w);
    I(labels==k)=255;
    E=edge(I);
    I1=IMG(:,:,1);
    I1(E==1)=255;
    I2=IMG(:,:,2);
    I2(E==1)=0;
    I3=IMG(:,:,3);
    I3(E==1)=0;
    IMG=cat(3,I1,I2,I3);
    end
end
% imshow(IMG);


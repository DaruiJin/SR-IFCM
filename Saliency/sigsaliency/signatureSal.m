function outMap = signatureSal( img , param )

%
%  inputs:
%     img    : either matrix of intensities or filename
%     param  : optional parameters, should have fields as set in default_signature_param
%
%  output
%     outMap : a saliency map for the image
%
%
%  This algorithm is described in the following paper:
%  "Image Signature: Highlighting sparse salient regions", by Xiaodi Hou, Jonathan Harel, and Christof Koch.
%  IEEE Transactions on Pattern Analysis and Machine Intelligence, 2011.
%
%  Coding by Xiaodi Hou and Jonathan Harel, 2011
%
%  License: Code may be copied & used for any purposes as long as the use is acknowledged and cited.
%

% read in file if img is filename
if ( strcmp(class(img),'char') == 1 ) img = imread(img); end

% convert to double if image is uint8
if ( strcmp(class(img),'uint8') == 1 ) img = double(img)/255; end

if ( ~exist( 'param' , 'var' ) )
    param = default_signature_param;
end

img = imresize(img, param.mapWidth/size(img, 2));

numChannels = size( img , 3  );

if ( numChannels == 3 )
    
    if ( isequal( lower(param.colorChannels) , 'lab' ) )
        
        labT = makecform('srgb2lab');
        tImg = applycform(img, labT);
        
    elseif ( isequal( lower(param.colorChannels) , 'rgb' ) )
        
        tImg = img;
        
    elseif ( isequal( lower(param.colorChannels) , 'dkl' ) )
        
        tImg = rgb2dkl( img );
        
    end
    
else
    
    tImg = img;
    
end

cSalMap = zeros(size(img));


[h,w,d]=size(tImg);
ch=round(h/3);
cw=round(w/3);

for i = 1:numChannels
    
    %-----对数值进行约束------
    dctimg=dct2(tImg(:,:,i));   %dct变换
    %-----DCT的符号信息与相位信息结合
    %     ----中间位置的值
    dvalue=dctimg(ch,cw);
    %     ----对dct进行筛选------
    T=abs(dvalue);
    dctimg(abs(dctimg)<T)=0;
    cSalMap(:,:,i) = idct2(sign(dctimg)).^2;
    %       cSalMap(:,:,i) = idct2(sign(dct2(tImg(:,:,i)))).^2;
    
    
end

outMap = mean(cSalMap, 3);


if ( param.blurSigma > 0 )
    kSize = size(outMap,2) * param.blurSigma;
    %    outMap = imfilter(outMap, fspecial('gaussian', round([kSize, kSize]*4), kSize));
    
    SE = strel('disk', round(kSize*3));
    outMap=imdilate(outMap,SE);
    
end

if ( param.resizeToInput )
    outMap = imresize( outMap , [ size(img,1) size(img,2) ] );
end

outMap = mynorm( outMap , param );

clear param;
clear SE;
clear cSalMap;
clear dctimg;
clear tImg;
clear img;
function [imgcut, num, position, diffsmap] = saliency(IMG)
    rIMG = IMG;
    if (numel(size(IMG))==3)
        IMG = rgb2gray(IMG);
    end
    rate = 90;
    addpath(genpath('.\sigsaliency\'));
    [~, diffimg] = findpeaks_local(IMG);
    diffimg = double(diffimg)./max(max(double(diffimg))+1);
    gimg = gradientImg(diffimg);
    diffimg = 0.5*(double(diffimg)+double(gimg));
    difflabMap = signatureSal(diffimg);
    [diffsmap, ~, ~]=show_imgnmap2(diffimg, difflabMap, rate);
    level = graythresh(diffsmap);
    BW = im2bw(diffsmap, level);
    BW = bwareaopen(BW, 300);
    [L, num] = bwlabel(BW, 4);
    status = regionprops(L, 'basic');
    imgcut = cell(1, num);
    position = zeros(num, 4);
    mask = [-30, -30, 60, 60];
    % mask=0;
    for k = 1:num
        rec = round(status(k).BoundingBox+mask);
        rec(1, 1) = max(rec(1, 1), 1);
        rec(1, 2) = max(rec(1, 2), 1);
        J = imcrop(rIMG, round(rec));
        [JH, JW] = size(J);
        if (JH*JW>1000)
            position(k, :) = round(rec);
            J = uint8(J);
            imgcut{1, k} = J;
        else
            continue;
        end
    end
    
end


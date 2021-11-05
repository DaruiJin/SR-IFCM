function [initT, diffimg] = findpeaks_local(img, ~)
    img = uint8(img);
    hh = imhist(img);  %图像直方图
    %-----直方图平滑
    windowSize = 7;
    fh = filter(ones(1, windowSize)/windowSize, 1, hh);

    meanH = mean(fh);
    meanI = mean(mean(img));
    stdI = std2(double(img));
    %----搜索局部极大值
    [pks, locs] = findpeaks(fh, 'MINPEAKHEIGHT', meanH);
    % 大于均值的局部极值
    ind = find(locs>meanI-0.25*stdI & locs<256-meanI);

    if isempty(ind)  %若不存在大于均值的局部极值，则选均值
        lind = round(meanI)+1;
    else
        mpks = pks(ind);
        %----大于均值的局部极值的最大值
        maxpk = mean(mpks);
        mpind = mpks>=maxpk;
        mind = ind(mpind);
        lind = locs(mind);
    end

    mind = round(mean(lind));

    maxind=find(fh==max(max(fh)));

    %------进行判断，背景之间，以及目标之间的灰度差异不会过大------
    distF = mind-meanI;  %大于均值的最小的灰度局部极值与均值的距离
    distB = meanI-maxind;  %均值与背景最小灰度值 直方图局部极值之间的距离
    if distF>distB
        mind = round(meanI+1);
    end

    dh = diff(fh);
    k = round(mean(mind))+1;
    while(mean(dh(k: k+1))<-10)  %利用连续5个的平均值做判断
        k = k+1;
    end
    initT = k-1;
    if initT<maxind
        initT = round(mean(maxind));
    end

    diffimg = img-round(mean(initT));
    diffimg(diffimg<0)=0;
    
end


function [initT, diffimg] = findpeaks_local(img, ~)
    img = uint8(img);
    hh = imhist(img);  %ͼ��ֱ��ͼ
    %-----ֱ��ͼƽ��
    windowSize = 7;
    fh = filter(ones(1, windowSize)/windowSize, 1, hh);

    meanH = mean(fh);
    meanI = mean(mean(img));
    stdI = std2(double(img));
    %----�����ֲ�����ֵ
    [pks, locs] = findpeaks(fh, 'MINPEAKHEIGHT', meanH);
    % ���ھ�ֵ�ľֲ���ֵ
    ind = find(locs>meanI-0.25*stdI & locs<256-meanI);

    if isempty(ind)  %�������ڴ��ھ�ֵ�ľֲ���ֵ����ѡ��ֵ
        lind = round(meanI)+1;
    else
        mpks = pks(ind);
        %----���ھ�ֵ�ľֲ���ֵ�����ֵ
        maxpk = mean(mpks);
        mpind = mpks>=maxpk;
        mind = ind(mpind);
        lind = locs(mind);
    end

    mind = round(mean(lind));

    maxind=find(fh==max(max(fh)));

    %------�����жϣ�����֮�䣬�Լ�Ŀ��֮��ĻҶȲ��첻�����------
    distF = mind-meanI;  %���ھ�ֵ����С�ĻҶȾֲ���ֵ���ֵ�ľ���
    distB = meanI-maxind;  %��ֵ�뱳����С�Ҷ�ֵ ֱ��ͼ�ֲ���ֵ֮��ľ���
    if distF>distB
        mind = round(meanI+1);
    end

    dh = diff(fh);
    k = round(mean(mind))+1;
    while(mean(dh(k: k+1))<-10)  %��������5����ƽ��ֵ���ж�
        k = k+1;
    end
    initT = k-1;
    if initT<maxind
        initT = round(mean(maxind));
    end

    diffimg = img-round(mean(initT));
    diffimg(diffimg<0)=0;
    
end


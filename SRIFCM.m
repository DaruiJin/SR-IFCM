function [Result, U, loss] = SRIFCM(img, C, spn)
    addpath('.\SymmetryViaRegistration-master\');
    [h1, w1, ~] = size(img);
    ladma = 2.5;
    [p,q] = RunMe(img);
    M = round((p(2, 1)+q(2, 1))/2);
    rad = min(M-1, w1-M);
    M1 = M;
    Result = zeros(h1, w1);


    IMG = img(:, M-rad: M+rad, :);
    [labels] = SLICOdemo(IMG, spn);
    if (numel(size(IMG))==3)
        IMG = rgb2gray(IMG);
    end
    minx = min(min(IMG));
    maxx = max(max(IMG));
    Uimg = (IMG-minx)./(maxx-minx);
    nonUimg = (1-Uimg)./(1+ladma*Uimg);
    Piimg = 1 - Uimg - nonUimg;

    [h, w] = size(IMG);
    RIMG = zeros(h, w);
    for k = 0:max(max(labels))
        temp = IMG(labels==k);
        m_value = mean(mean(temp));
        RIMG(labels==k) = m_value;
    end
    
    minR = min(min(RIMG));
    maxR = max(max(RIMG));
    URimg = (RIMG-minR)./(maxR-minR);
    nonURimg = (1-URimg)./(1+ladma*URimg);
    PiRimg = 1 - URimg - nonURimg;
    sigma = var(reshape(IMG, [], 1), 1);
    alpha = exp(-(IMG-RIMG).^2./(2*sigma));

    M = round(w/2);
    level = graythresh(IMG);
    temp1 = IMG(round(min(p(1, 1),q(1, 1))):round(max(p(1, 1),q(1, 1))),:);
    N = size(temp1, 1);
    col = zeros(N, 1);
    for k = 1:N
        ctemp = temp1(k,:);
        [~, co] = find(ctemp>level);
        if (numel(co)==0)
            col(k, 1)=0;
        else
            col(k, 1) = max(co)-min(co);
        end
    end
    a1 = max(col);
    if (numel(a1)==0)
        a1 = 0;
    end
    a = (a1+20)/2;
    Cer = round((p(1,1)+q(1,1))/2);
    temp2 = IMG(:,M);
    [row, ~] = find(temp2>level);
    b1 = (max(row)-min(row))/2;
    if (numel(b1)==0)
        b1 = 0;
    end
    b = b1+10;
    sym = compare(IMG);
    sym(sym<0.5) = 0;
    
    map = zeros(h,w);
    for i = 1:h
        for j = 1:w
            pl = ((i-Cer)/b).^2+((j-M)/a)^2;
            if (pl>1)
                map(i, j) = 0.2;
            else
                map(i, j) = exp(-((i-Cer)^2/(2*b^2)+(j-M)^2/(2*a^2)));
            end
        end
    end

    mask = ones(7, 7)./49;
    MUimg = imfilter(fliplr(Uimg), mask, 'replicate', 'corr');
    MnonUimg = imfilter(fliplr(nonUimg), mask, 'replicate', 'corr');
    MPiimg = imfilter(fliplr(Piimg), mask, 'replicate', 'corr');

    [UF, Vu, Vv, Vp] = IFCM(reshape(Uimg, [], 1), reshape(nonUimg, [], 1), reshape(Piimg, [], 1), C);
    [~, cidx] = sort(Vu);
    Vu = Vu(cidx, :);
    Vv = Vv(cidx, :);
    Vp = Vp(cidx, :);
    UF = UF(cidx, :);
    U = zeros(h, w, C);
    for k = 1:C
        U(:, :, k) = reshape(UF(k, :), [h, w]);
    end
    m = 2;

    t = 0;
    loss = [];
    while (t<100)
        W = weight(IMG, U, sym, labels, map);

        D = zeros(h, w, C);
        for k = 1:C
            D(:, :, k) = (Uimg-Vu(k, 1)).^2+(nonUimg-Vv(k, 1)).^2+(Piimg-Vp(k, 1)).^2+alpha.*((URimg-Vu(k, 1)).^2+(nonURimg-Vv(k, 1)).^2+(PiRimg-Vp(k, 1)).^2)+sym.*((MUimg-Vu(k, 1)).^2+(MnonUimg-Vv(k, 1)).^2+(MPiimg-Vp(k, 1)).^2);
        end

        Up = 1./(W.*D+eps);
        U = Up./(repmat(sum(Up, 3), [1, 1, C]));

        Vup = W.*(U.^m).*repmat(Uimg+alpha.*URimg+sym.*MUimg, [1, 1, C]);
        Vud = W.*(U.^m).*repmat(1+alpha+sym, [1, 1, C]);
        Vu_new = sum(sum(Vup, 1), 2)./sum(sum(Vud, 1), 2);

        Vvp = W.*(U.^m).*repmat(nonUimg+alpha.*nonURimg+sym.*MnonUimg, [1, 1, C]);
        Vv_new = sum(sum(Vvp, 1), 2)./sum(sum(Vud, 1), 2);

        Vpp = W.*(U.^m).*repmat(Piimg+alpha.*PiRimg+sym.*MPiimg, [1, 1, C]);
        Vp_new = sum(sum(Vpp, 1), 2)./sum(sum(Vud, 1), 2);

        VTu1 = zeros(C, 1);
        VTu2 = zeros(C, 1);
        VTu3 = zeros(C, 1);
        for k = 1:C
            VTu1(k, 1) = Vu_new(1, 1, k);
            VTu2(k, 1) = Vv_new(1, 1, k);
            VTu3(k, 1) = Vp_new(1, 1, k);
        end

        diff = sqrt(((VTu1-Vu).^2+(VTu2-Vv).^2+(VTu3-Vp).^2)/3);
        EPS = max(diff(:));
        if (EPS<0.0001) && (t==30)
            break;
        else
        if (t==30)
            break
        end
            for k = 1:C
                Vu(k, 1) = Vu_new(1, 1, k);
                Vv(k, 1) = Vv_new(1, 1, k);
                Vp(k, 1) = Vp_new(1, 1, k);
            end
        end
        loss(t+1) = sum(sum(sum(W.*U.^2.*D)));
        t = t + 1;
    end
    [~, cidx] = sort(VTu1);
    U = U(:, :, cidx);
    [~, label] = max(U, [], 3);
    I = zeros(h, w);
    I(label==C) = 255;
    result = uint8(I);
    result = imfill(result, 'holes');
    result = process(result);
    Result(:, M1-rad: M1+rad) = result;
    
end
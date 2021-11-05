function IMG = process(IMG)
    IMG = bwareaopen(IMG, 3000);
    [m, n] = size(IMG);
    [L, num] = bwlabel(IMG, 8);
    status = regionprops(L,'basic');

    for k = 1:num
        [r, c] = find(L==k);
        rc = find(L==k);
        rmin = min(r);
        rmax = max(r);
        cmin = min(c);
        cmax = max(c);
        if (rmin==1||rmax==m||cmax==n||cmin==1)
            IMG(rc) = 0;
        end
    end

    [L, num] = bwlabel(IMG, 8);
    status = regionprops(L, 'basic');

    for k = 1:num
        reg = round(status(k).BoundingBox);
        height = reg(1, 4);
        width = reg(1, 3);
        ratio = 1/(width/height);
        lreg = find(L==k);
        if (ratio>5||ratio<1)
            IMG(lreg)=0;
        end
    end

end
    
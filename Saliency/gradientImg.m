function gimg = gradientImg(diffimg)
%计算图像的梯度图像，并且进行归一化
    [gx, gy] = gradient(double(diffimg));
    gimg = sqrt(gx.*gx+gy.*gy);
    gimg = imfill(gimg, 'holes');

    meang = mean(mean(gimg));
    gimg(gimg<meang) = 0;
    gimg = double(gimg)./max(max(double(gimg))+1);
end
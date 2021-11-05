function gimg = gradientImg(diffimg)
%����ͼ����ݶ�ͼ�񣬲��ҽ��й�һ��
    [gx, gy] = gradient(double(diffimg));
    gimg = sqrt(gx.*gx+gy.*gy);
    gimg = imfill(gimg, 'holes');

    meang = mean(mean(gimg));
    gimg(gimg<meang) = 0;
    gimg = double(gimg)./max(max(double(gimg))+1);
end
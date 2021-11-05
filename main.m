clear;
clc;
addpath('.\Saliency\');
addpath('.\utils\');


img_root = '.\data';
img_list = dir(fullfile(img_root, '*.jpg'));

time_start = tic;

for i = 1:length(img_list)
    IMG = imread(fullfile(img_root, img_list(i).name));
    [imgcut, num, Pos, diffsmap] = saliency(IMG);  % saliency mapping
    
    if (numel(size(IMG))==3)
        [h, w] = size(rgb2gray(IMG));
    else
        [h, w] = size(IMG);
    end
    
    output = zeros(h, w);
    for k = 1:num
        img = imgcut{1, k};
        img = im2double(img);
        [result, U, loss] = SRIFCM(img, 4, 200);
        BS = min((Pos(k, 2)+Pos(k, 4)), h);
        RS = min((Pos(k, 1)+Pos(k, 3)), w);
        output(Pos(k, 2): BS, Pos(k, 1): RS) = result * 255;
        fprintf('\n')
    end
    
    figure
    imshow(uint8(output))
    savepath = fullfile('.\result', img_list(i).name);
    imwrite(output, savepath);
end

toc(time_start)
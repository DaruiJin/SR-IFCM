function W = weight(IMG, U, sym, labels, map)
    [h, w] = size(IMG);
    [~, L] = max(U, [], 3);
    [~, ~, C] = size(U);
    RL = zeros(h, w, C);
    RU = zeros(h, w, C);

    W1 = (1-exp(-(1-RU)));

    sal = (map+sym)/2;
    mask = ones(3,3)/9;
    mIMG = imfilter(IMG, mask, 'replicate', 'corr');
    W2 = zeros(h, w, C);
    for k = 1:C
        if (k~=C)
            W2(:, :, k) = (sal+(1-exp(-mIMG)))/2;
        else
            W2(:, :, k) = ((1-sal)+exp(-mIMG))/2;
        end
    end
    % W = W1;% TEST
    W = W1+W2;
    W = W./(repmat(sum(W, 3), [1, 1, C]));








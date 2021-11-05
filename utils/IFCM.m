function [U, Vu, Vv, Vpi] = IFCM(Uimg, NonUimg, Piimg, C)
    N = size(Uimg, 1);
    U = rand(C, N);
    Usum = sum(U);
    U = U./(repmat(Usum, [C, 1]));
    D = zeros(C, N);

    max_iter = 200;
    iter_thr = 1e-5;
    m = 2;

    for k = 1:max_iter
        Vu = (U.^m*Uimg)./sum(U.^m,2);
        Vv = (U.^m*NonUimg)./sum(U.^m,2);
        Vpi = (U.^m*Piimg)./sum(U.^m,2);

        for kk = 1:C
            D(kk, :) = ((Uimg-Vu(kk, 1)).^2+(NonUimg-Vv(kk, 1)).^2+(Piimg-Vpi(kk, 1)).^2)';
        end
        U_new = (1./D)./(repmat(sum(1./D), [C, 1]));

        diff = abs(U_new-U);
        if (max(max(diff))<iter_thr)
            break;
        else
            U = U_new;
        end
        fprintf('The iteration number = %d', k);
        fprintf('\n');
    end
    
end

        
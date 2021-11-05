function Iout = imtoolred_save(IGray, yarray, xarray)
    Iout = cat(3, IGray, IGray, IGray);
    Ir = IGray; Ig = Ir; Ib = Ir;
    for i = 1:numel(xarray)
        Ir(yarray(i), xarray(i)) = 255; Ig(yarray(i), xarray(i)) = 0; Ib(yarray(i), xarray(i)) = 0;
    end
    Iout(:, :, 1) = Ir; Iout(:, :, 2) = Ig; Iout(:, :, 3) = Ib;

end
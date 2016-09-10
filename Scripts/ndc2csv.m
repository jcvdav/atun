clear
close
clc

xlim = [720, 2520];
ylim = [1200, 2160];

for i = 2005:2014
    for j = 1:12
        img_in = ['Datos/Oc/Imagenes/',num2str(i), '_', num2str(j),'.nc'];
        img = subset(img_in, xlim, ylim);
        
        [r,c] = size(img);
        img2 = zeros(r,c+2);
        
        img2(:,1) = i;
        img2(:,2) = j;
        img2(:,3:end) = img;
        
        img_out = ['Datos/Oc/Imagenes/',num2str(i), '_', num2str(j),'.csv'];
        csvwrite(img_out, img2)
        disp(img_out)
    end
end
clear
close
clc

xlim = [720, 2520];
ylim = [1200, 2160];

for i = 2003:2014
    for j = 1:12
        img_in = ['Datos/Oc/imagenes/',num2str(i), '/', num2str(j),'.nc'];
        img = subset(img_dir, xlim, ylim);
        
        [r,c] = size(img);
        img2 = zeros(r,c+2);
        
        img2(:,1) = i;
        img2(:,2) = j;
        img2(:,3:end) = img;
        
        img_out = ['Datos/Oc/imagenes/',num2str(i), '/', num2str(j),'.csv'];
        csvwrite('Test2.csv', img2)
    end
end
function [ caracts ] = getCaracts( )

    file = 'caracters/joc_de_caracters.jpg';
    im = imread(file);
    
    level = graythresh(im);
    im_bin = im2bw(im, level);
    im_bin = 1-im_bin;
    [L, n] = bwlabel (im_bin);
    numCaracts = 7;
    props = regionprops(L, 'BoundingBox', 'Eccentricity', 'EulerNumber', 'Extent', 'Area', 'Perimeter');
    caracts = zeros(n, numCaracts);
    for i = 1 : n
        % Histogram
        im_crop = imcrop(im, props(i).BoundingBox);
        hist = getHistogram(im_crop);

        p = props(i).Perimeter;
        caracts(i,:) = [
            props(i).Eccentricity,
            props(i).EulerNumber,
            props(i).Extent,
            p*p / props(i).Area,
            hist
            ];
    end    
end


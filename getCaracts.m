function [ caracts ] = getCaracts( )
    
    files = dir(['trainset/' '*.png']);
   
    numCaracts = 4;
    N = 30*length(files);
    caracts = zeros(N, numCaracts);
    
    for file = 1 : 1 %length(files)
        im = imread(fullfile('trainset', files(file).name));
    
        level = graythresh(im);
        im_bin = im2bw(im, level);
        im_bin = 1-im_bin;
        [L, n] = bwlabel (im_bin);
        
        props = regionprops(L, 'BoundingBox', 'Eccentricity', 'EulerNumber', 'Extent', 'Area', 'Perimeter');
        
        for i = 1 : n
            % Histogram
            im_crop = imcrop(im, props(i).BoundingBox);
            

            p = props(i).Perimeter;
            caracts(i,:) = [
                props(i).Eccentricity,
                props(i).EulerNumber,
                props(i).Extent,
                p*p / props(i).Area
                ];
        end    
    end
end


function [ caracts ] = getCaracts( )
    % Set to 1 to train with all the trainset data, 0 otherwise.
    allTrainset = 0;
    
    if allTrainset
        files = dir(['trainset/' '*.png']);
        N = 30*length(files);
    else
        files = dir(['trainset/original.png']);
        N = 30;
    end

    numCaracts = 5;
    caracts = zeros(N, numCaracts);
    
    for file = 1 : 1 %length(files)
        im = imread(fullfile('trainset', files(file).name));
        files(file).name
    
        level = graythresh(im);
        im_bin = im2bw(im, level);
        im_bin = 1-im_bin;
        [L, n] = bwlabel (im_bin);
        
        props = regionprops(L, 'BoundingBox', 'Eccentricity', 'EulerNumber', 'Extent', 'Area', 'Perimeter');
        corners = corner(im_bin);
        
        for i = 1 : n
            p = props(i).Perimeter;
            caracts(i,:) = [
                props(i).Eccentricity,
                props(i).EulerNumber,
                props(i).Extent,
                p*p / props(i).Area,
                length(corners)
                ];
        end    
    end
end


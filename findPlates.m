function [ plates ] = findPlates( im )
% Finds the possible plates in the image
% Returns an array, containing the different plates described as a
% rectangle: [upper_left_x upper_left_y width height]
    plates = [];
    
    plates
    
    level = graythresh(im)*1.1;
    im_bin = im2bw(im, level);
    im_bin = imclearborder(im_bin);
    im_bin = bwfill(im_bin, 'holes');
    im_opened = imopen(im_bin, strel('square', 10));

    % LABELING

    % Label cells.
    [L, n] = bwlabel (im_opened);
    props = regionprops(L, 'Extent');
    for i = 1 : n
        if props(i).Extent < 0.65
            im_opened(L==i) = 0;
        end
    end
    
    [L, n] = bwlabel (im_opened);
    props = regionprops(L, 'BoundingBox', 'Perimeter', 'Area');
    for j = 1 : n
        p = props(j).Perimeter;
        a = props(j).Area;
        ratio = p*p/a;
        if ratio > 25.0 && ratio < 29.0
            plates(end+1) = props(j).BoundingBox;
        end     
    end
end


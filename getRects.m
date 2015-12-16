function [ rects ] = getRects( im )
% TODO: Get the letters by searching for regions with a height between
% ~60% and 80% of the plate.

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    level = graythresh(im)*1.1;  % In 1.1 we trust.
    im_bin = im2bw(im, level);
    
    im_bin = 1 - im_bin;
    im_bin = imclearborder(im_bin);
    rects = [];
    
    % LABELING
    % Label cells.
    [L, n] = bwlabel (im_bin);
    props = regionprops(L, 'BoundingBox', 'Eccentricity', 'EulerNumber', 'Extent', 'Area', 'Perimeter');
    hold on;
    % figure, imshow(im);
    for i = 1 : n
        p = props(i).Perimeter;
        a = props(i).Area;
        ratio = p*p/a;
        area = props(i).Area;
        if ratio > 22.0 && ratio < 80.0
            % rectangle('Position', props(i).BoundingBox, 'EdgeColor','red')
            rects(end+1).BoundingBox = props(i).BoundingBox(1:4);
            rects(end).Eccentricity = props(i).Eccentricity;
            rects(end).Extent = props(i).Extent;
            rects(end).EulerNumber = props(i).EulerNumber;
            rects(end).Ratio = ratio;
        end
    end
    hold off;
end


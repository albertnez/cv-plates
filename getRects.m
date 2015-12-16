function [ rects ] = getRects( im )
    im_height = size(im, 1)

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
    for i = 1 : n
        p = props(i).Perimeter;
        a = props(i).Area;
        ratio = p*p/a;
        area = props(i).Area;
        height = props(i).BoundingBox(4);
        % TODO make the height ratio more precise.
        if props(i).Extent < 0.80 && ratio > 18.5 && ratio < 85.0 && height/im_height < 0.9 && height/im_height > 0.3
            % rectangle('Position', props(i).BoundingBox, 'EdgeColor','red')
            rects(end+1).BoundingBox = props(i).BoundingBox(1:4);
            rects(end).Eccentricity = props(i).Eccentricity;
            rects(end).Extent = props(i).Extent;
            rects(end).EulerNumber = props(i).EulerNumber;
            rects(end).Ratio = ratio;
        else
            ratio
            height/im_height
        end
    end
    hold off;
end


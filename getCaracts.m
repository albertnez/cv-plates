function [ caracts ] = getCaracts( )
    % Set to 1 to train with all the trainset data, 0 otherwise.
    allTrainset = 1;
    
    if allTrainset
        files = dir(['trainset/' '*.png']);
        N = 30*length(files);
    else
        files = dir(['trainset/original.png']);
        N = 30;
    end

    for file = 1 : length(files)
        im = imread(fullfile('trainset', files(file).name));
    
        level = graythresh(im);
        im_bin = im2bw(im, level);
        im_bin = 1-im_bin;
        [L, n] = bwlabel (im_bin);
        
        props = regionprops(L, 'BoundingBox', 'Eccentricity', 'EulerNumber', 'Extent', 'Area', 'Perimeter');
        
        for i = 1 : n
            im_caract = imcrop(im_bin, props(i).BoundingBox);
            im_gray = imcrop(im, props(i).BoundingBox);
            polar = getPolar(im_caract);
            corners = corner(im_gray, 'MinimumEigenvalue');
            p = props(i).Perimeter;

            % TO ADD MAYBE:
            %{
            length(corners)...
            polar
            %}

            caracts((file-1)*30 + i,:) = [props(i).EulerNumber, getMeans(im_caract, 10)];
            %{
            caracts((file-1)*30 + i,:) = [...
                props(i).EulerNumber...
                props(i).Extent...
                p*p / props(i).Area...
                length(corners)...
                ];
            %}

        end    
    end
end


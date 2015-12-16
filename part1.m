close all
clear all

files = dir(['matricules/' '*.jpg']);


for file = 1 : 1 %length(files)
    im = imread(fullfile('matricules', files(file).name));

    % Binarization of our image.
    level = graythresh(im)*1.1;

    im_bin = im2bw(im, level);
    im_bin = imclearborder(im_bin);
    im_bin = bwfill(im_bin, 'holes');
    % Some initial opening.
    im_opened = imopen(im_bin, strel('square', 10));
    %imshowpair(im_bin, im_opened, 'montage');
    figure, imshow(im)

    % LABELING

    % Label cells.
    [L, n] = bwlabel (im_opened);
    props = regionprops(L, 'Extent');
    % Filter those rectangles that do not fit as a plate.
    for i = 1 : n
        if props(i).Extent < 0.65
            im_opened(L==i) = 0;
        end
    end
    %figure, imshowpair(im_bin, im_opened, 'montage');
    
    hold on
    [L, n] = bwlabel (im_opened);
    props = regionprops(L, 'BoundingBox', 'Perimeter', 'Area');
    plates = [];
    % Now, find and save the actual plates.
    for j = 1 : n
        p = props(j).Perimeter;
        a = props(j).Area;
        ratio = p*p/a;
        if ratio > 25.0 && ratio < 29.0
            props(j).BoundingBox;
            % Surround letters in plate
            rectangle('Position', props(j).BoundingBox, 'EdgeColor','r');
            plates(end+1,1:4) = props(j).BoundingBox(1:4);
            %plot(props(j).BoundingBox(:,1), props(j).BoundingBox(:,2), 'LineWidth', 3, 'Color', 'r')
        %else rectangle('Position', props(j).BoundingBox, 'FaceColor','r')
        end     
    end
    hold off;
    
    % PART 2
    % Drawing.
    for j = 1:size(plates,1)
        im_crop = imcrop(im, plates(j,:));
        % figure, imshow(im_crop);
        rects = getRects(im_crop);

        plateId = '';
        for i = 1:size(rects,2)
            im_caract = imcrop(im_bin, rects(i).BoundingBox);
            rects(i).BoundingBox(1) = rects(i).BoundingBox(1) + plates(j,1);
            rects(i).BoundingBox(2) = rects(i).BoundingBox(2) + plates(j,2);
            rectangle('Position', rects(i).BoundingBox, 'EdgeColor', 'r');
            corners = corner(im_caract);
            
            % polar = getPolar(im_caract);

            sampling(i,:) = [
                rects(i).Eccentricity,
                rects(i).EulerNumber,
                rects(i).Extent,
                rects(i).Ratio,
                length(corners)
            ];
        end
        % Classify caracters.
        training = getCaracts();
        %training(end+1) = training(1);
        groups = ['0'; '1'; '2'; '3'; '4'; '5'; '6'; '7'; '8'; '9'; 
            'B'; 'C'; 'D'; 'F'; 'G'; 'H'; 'J'; 'K'; 'L'; 'M'; 'N';
            'P'; 'R'; 'S'; 'T'; 'V'; 'W'; 'X'; 'Y'; 'Z';];
        %cl = c10lassify(sampling, training, groups);
        B = TreeBagger(15, training, groups);
       %  prediction = predict(B, sampling)
        
        [id, score] = predict(B, sampling);
        % Test each character. Replace by '*' if not enough confidence
        for c = 1:size(id,1)
            s = max(score(c,:));
            if s < 0.45
                id{c} = '*';
            end
        end
        % Show image with plate id as title.
        figure('Name', char(id)), imshow(im_crop);
    end
end

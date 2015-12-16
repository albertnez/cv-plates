function [ values ] = getPolar( im )
    size(im)

    B=bwboundaries(im,'noholes');
    if size(B) == 0
        values = [0, 0, 0]
        return
    end
    contour=B{1};
    N=size(contour,1);

    
    %polar signature
    centroid=[mean(contour(:,1)) mean(contour(:,2))];
    polar(1:360)=-1;
    for i=1:N
        X=contour(i,2)-centroid(2);
        Y=contour(i,1)-centroid(1);
        angle = round(atan2d(Y,X));
        if angle < 360
            angle = angle+360;
        end
        angle=mod(angle,360)+1;
        distance=sqrt(X*X+Y*Y);
        if polar(angle) == -1 || distance < polar(angle)
            polar(angle)=distance;
        end
    end
    polar=polar./max(polar);  % Normalize.
    filteredPolar = [];
    for i = 1:360
        if polar(i) >= 0
            filteredPolar(end+1) = polar(i);
        end
    end
    values = prctile(filteredPolar, [0, 25, 50, 75, 100]);
end


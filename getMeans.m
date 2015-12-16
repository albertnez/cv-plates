function [ means ] = getMeans( im, sz )
    [rows, cols] = size(im);
    per_row = fix(rows / sz);
    per_col = fix(cols / sz);
    mod_row = mod(rows, sz);
    mod_col = mod(cols, sz);

    means = zeros(sz, sz);
    for i = 1:sz
        starti = 1 + (i-1)*per_row + min(mod_row,i-1);
        endi = starti + (per_row-1);
        if i <= mod_row
            endi = endi + 1;
        end
        for j = 1:sz
            startj = 1 + (j-1)*per_col + min(mod_col,j-1);
            endj = startj + (per_col-1);
            if j <= mod_col
                endj = endj + 1;
            end
            means(i,j) = mean(mean(im(starti:endi,startj:endj)));
        end
    end
    mx = max(max(means));
    if mx > 0
        means./max(max(means));
    end
    t = means(:)';
    means = t;


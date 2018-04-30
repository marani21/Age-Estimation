% 
[age_list,~]=datevec(datenum(wiki.photo_taken,7,1)-wiki.dob);
n = 10;
values = [];
ages = [];
file_names = [];
for j = 0:99

    if(j<10)
        d = strcat('0', num2str(j));
    else
       d = num2str(j); 
    end
    sprintf('training-safe/%s',d)
    files = dir(fullfile(sprintf('training-safe/%s',d)));
    images = cell(length(files), 1);



    for i = 1:length(files)
        %images{i} = feature_ex(strcat('training/',files(i).name));
        if(length(files(i).name) > 3)
            sprintf('training-safe/%s/%s',d, files(i).name)
            %[I, success, nr, val] = feature_ex(sprintf('training-best/%s/%s',d, files(i).name));
            [I, success, nr, val] = edge_image(sprintf('training-best/%s/%s',d, files(i).name));
            [value, success] = get_wrinkle_value(sprintf('training-safe/%s/%s',d, files(i).name));
            %success
            %nr
            images{i} = I;
            if(success)
                fprintf('SUCCESS');
                index = find(strcmp(wiki.full_path, sprintf('%s/%s',d, files(i).name))==1);
                age = age_list(index);
                index
                age_list(index)
                values = [values value];
                ages = [ages age];
                name =  sprintf('%s/%s',d, files(i).name);
                file_names = [file_names name];
                %imwrite(images{i}, sprintf('tmp/%s.jpg',files(i).name));
                %imwrite(images{i},sprintf('tmp/%s_%s.jpg',d, files(i).name));
                imwrite(images{i},sprintf('tmp/canny/%s_%s.jpg',d, files(i).name));
            end
        end
    end
end
[value, success] = get_wrinkle_value('test/174001_1961-08-27_2009.jpg');
if(success == 1)
    values_sum = [values value];
    vvalues = values_sum';
    [centers, U] = fcm(vvalues, n);
    test_Pij = U(:, length(U));
    %U(:,length(U)) = [];
    %montage(images);
    [maxm, maxind] = max(U(:, 1:146));
    mmaxm = maxm';

    averages = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    for i=1:n
        i
        iindexes = find(maxind == i);
        group_ages = ages(iindexes);
        group_ages
        averages(i) = sum(group_ages)/length(iindexes);
    end
    suma = 0;
    for i=1:n
        suma = suma + (test_Pij(i)*averages(i));
    end
    value
    suma
end


[age_list,~]=datevec(datenum(wiki.photo_taken,7,1)-wiki.dob);
n = 15;
values = [];
ages = [];
file_names = [];
for j = 0:99

    if(j<10)
        d = strcat('0', num2str(j));
    else
       d = num2str(j); 
    end
    sprintf('training-best/%s',d)
    files = dir(fullfile(sprintf('training-best/%s',d)));
    images = cell(length(files), 1);



    for i = 1:length(files)
        %images{i} = feature_ex(strcat('training/',files(i).name));
        if(length(files(i).name) > 3)
            sprintf('training-best/%s/%s',d, files(i).name)
            %[I, success, nr, val] = feature_ex(sprintf('training-best/%s/%s',d, files(i).name));
            [value, success] = get_wrinkle_value(sprintf('training-best/%s/%s',d, files(i).name));
            %success
            %nr
            %images{i} = I;
            if(success)
                fprintf('SUCCESS');
                index = find(strcmp(wiki.full_path, sprintf('%s/%s',d, files(i).name))==1);
                age = age_list(index);
                values = [values value];
                ages = [ages age];
                name =  sprintf('%s/%s',d, files(i).name);
                file_names = [file_names name];
                %imwrite(images{i}, sprintf('tmp/%s.jpg',files(i).name));
            end
        end
    end
end
values = values';
[centers, U] = fcm(values, n);
%montage(images);
[maxm, maxind] = max(U);
maxm = maxm';

averages = [0,0,0,0,0,0,0,0,0,0];
for i=1:n
    i
    iindexes = find(maxind == i);
    group_ages = ages(iindexes);
    averages(i) = sum(group_ages)/length(iindexes);
end

[value, success] = get_wrinkle_value('test/344124_1956-04-12_2009.jpg');
test_values = [values' value];
[test_centers, test_U] = fcm(test_values', n);
test_Pij = test_U(:, 184);
suma = 0;
for i=1:n
    suma = suma + (test_Pij(i)*averages(i));
end

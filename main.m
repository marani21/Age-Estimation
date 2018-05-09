%Number of clusters
n = 20;
[age_list,~]=datevec(datenum(wiki.photo_taken,7,1)-wiki.dob);
%Training set
[values, ages, file_names] = get_training_values();

results = [];


for j = 0:99
    if(j<10)
       dir_name = strcat('0', num2str(j));
    else
       dir_name = num2str(j); 
    end

    %Test set
    test_files = dir(fullfile(sprintf('test/%s',dir_name)));
    for i = 1:length(test_files)
        if(length(test_files(i).name) > 3)
            sprintf('test/%s/%s', dir_name, test_files(i).name)
            [image, value, success] = get_wrinkle_value(sprintf('test/%s/%s', dir_name, test_files(i).name));
            if(success == 1)
                success
                values_sum = [values value];
                values_sum_v = values_sum';

                %Fuzzy C-means clustering on training data set + test image
                [centers, U] = fcm(values_sum_v, n);

                %Column with test image membership values
                test_Pij = U(:, length(U));

                %Get clusters which training data belong to
                pre_last_index = length(U) - 1;
                [maxm, maxind] = max(U(:, 1:pre_last_index));
                maxm_v = maxm';

                averages = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
                for k=1:n
                    
                    iindexes = find(maxind == k);
                    group_ages = ages(iindexes);
                    %group_ages
                    averages(k) = sum(group_ages)/length(iindexes);
                end
                suma = 0;
                for k=1:n
                    suma = suma + (test_Pij(k)*averages(k));
                end
                index = find(strcmp(wiki.full_path, sprintf('%s/%s',dir_name, test_files(i).name))==1);
                age = age_list(index);
                %value
                %suma
                suma = round(suma);
                error = abs(age - suma);
                name = sprintf('%s_%s', dir_name, test_files(i).name);
                c = {suma, age, value, error, name};
                results = [results; c];
            end
        end
    end
end

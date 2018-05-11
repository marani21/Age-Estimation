%Number of clusters
n = 15;

%Training set
%[values, ages, file_names] = get_training_values2();

results = [];


%Test set
test_files = dir(fullfile('test-ideal'));
for i = 1:length(test_files)
    if(length(test_files(i).name) > 3)
        [image, value, success] = get_wrinkle_value(sprintf('test-ideal/%s', test_files(i).name));
        if(success == 1)
            test_files(i).name
            values_sum = [values value];
            values_sum_v = values_sum';

            %Fuzzy C-means clustering on training data set + test image
            opts = [nan;nan;nan;0];
            [centers, U] = fcm(values_sum_v, n, opts);

            %Column with test image membership values
            test_Pij = U(:, length(U));
            if(strcmp(test_files(i).name,'TSFBfemale72-2neutral.bmp')==1)
                w = test_Pij;
            end
            %Get clusters which training data belong to
            pre_last_index = length(U) - 1;
            [maxm, maxind] = max(U(:, 1:pre_last_index));
            maxm_v = maxm';

            averages = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
            for k=1:n

                iindexes = find(maxind == k);
                group_ages = ages(iindexes);
                group_ages
                averages(k) = sum(group_ages)/length(iindexes);
            end
            suma = 0;
            for k=1:n
                suma = suma + (test_Pij(k)*averages(k));
            end
            index = find(strcmp(lab.names, test_files(i).name)==1);
            age = lab.ages(index);
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


%Number of clusters
n = 14;
e = zeros(length(thresholds));
for j = 1:1
    error_sum = 0;
    t = thresholds(j, :);
    j
    %Training set
%      [values, ages, file_names] = get_training_values2(t);
%      valuesv = values';
     results = [];

    %FCM
    opts = [2.1;nan;nan;0];
    [centers, U] = fcm(values_sum_v, n, opts);
    
    %Getting maximum membership value for each element of trainig set
    [maxm, maxind] = max(U);
    maxm_v = maxm';

    %Average ages of grouped trainig set
    averages = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    for k=1:n

        iindexes = find(maxind == k);
        group_ages = ages(iindexes);
        group_ages
        averages(k) = sum(group_ages)/length(iindexes);
    end
    
    %Test set
    test_files = dir(fullfile('test-ideal'));
    for i = 1:length(test_files)
        if(length(test_files(i).name) > 3)
            [image, value, success] = get_wrinkle_value(sprintf('test-ideal/%s', test_files(i).name), t);
            if(success == 1)
                test_files(i).name
                test_value = value;
                
                %Getting distanec between centers and test value.
                test_Pij = ones(n, 1);
                for p = 1 : n
                    s = 0;
                    for  r = 1 : n
                        s = s + power(abs(value - centers(p))/abs(value - centers(r)),2);
                    end
                    %test_Pij(p) = 1/power((s), 2);
                    test_Pij(p) = 1/s;
                end
                
                suma = 0;
                for k=1:n
                    suma = suma + (test_Pij(k)*averages(k));
                end
                
                index = find(strcmp(lab.names, test_files(i).name)==1);
                age = lab.ages(index);

                suma = round(suma);
                error = abs(age - suma);
                name = sprintf('%s', test_files(i).name);
                c = {suma, age, value, error, name};
                results = [results; c];
                
%                  if(isnan(error))
%                      error = 0;
%                  end
                error_sum = error_sum + error;
            end
        end
    end
    
    e(j) = error_sum;
end


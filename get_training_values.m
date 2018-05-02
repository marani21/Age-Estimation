function [values, ages] = get_training_values()
    load('wiki');
    [age_list,~]=datevec(datenum(wiki.photo_taken,7,1)-wiki.dob);
    values = [];
    ages = [];
    for j = 0:99

        if(j<10)
           dir_name = strcat('0', num2str(j));
        else
           dir_name = num2str(j); 
        end
        sprintf('training-safe/%s',dir_name)
        files = dir(fullfile(sprintf('training-safe/%s',dir_name)));
        images = cell(length(files), 1);

        for i = 1:length(files)
            %images{i} = feature_ex(strcat('training/',files(i).name));
            if(length(files(i).name) > 3)
                %sprintf('training-safe/%s/%s',dir_name, files(i).name)
                %[I, success, nr, value] = feature_ex(sprintf('training-safe/%s/%s',dir_name, files(i).name));

                [I, value, success] = get_wrinkle_value(sprintf('training-safe/%s/%s',dir_name, files(i).name));
                images{i} = I;
                if(success)
                    fprintf('SUCCESS');
                    index = find(strcmp(wiki.full_path, sprintf('%s/%s',dir_name, files(i).name))==1);
                    age = age_list(index);
                    %index
                    age_list(index)
                    values = [values value];
                    ages = [ages age];
                    %name =  sprintf('%s/%s',dir_name, files(i).name);
                    %file_names = [file_names; name];
                    %imwrite(images{i},sprintf('tmp/%s_%s.jpg',dir_name, files(i).name));
                    %imwrite(images{i},sprintf('tmp/canny/%s_%s.jpg',dir_name, files(i).name));
                end
            end
        end
        
    end
end
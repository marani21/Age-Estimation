function [values, ages, file_names] = get_training_values(t)
    lab = load('aging-lab');
    values = [];
    ages = [];
    file_names = [];

    files = dir('training-ideal');
    images = cell(length(files), 1);
    
    %dir_name = sprintf('%s_%s', round(t(1),2), round(t(2),2));
     dir_name = 'adaptiveNew_gamma_test1_1_10_adapthisteq_ray_clip_all_000001_adaptiveTreshMatlab_all_more';
%     mkdir('tmp/canny/new_test', dir_name);
%     mkdir('tmp/gamma/new_test', dir_name);
    for i = 1:length(files)
        %images{i} = feature_ex(strcat('training/',files(i).name));
        if(length(files(i).name) > 3)
            %sprintf('training-ideal/%s/%s',dir_name, files(i).name)
            %[I, success, nr, value] = feature_ex(sprintf('training-ideal/%s',files(i).name));

            [Ic, value, success] = get_wrinkle_value(sprintf('training-ideal/%s', files(i).name),t);
            %images{i} = I;
            if(success)
                fprintf('SUCCESS');
                index = find(strcmp(lab.names, files(i).name)==1);
                age = lab.ages(index);
                values = [values value];
                ages = [ages age];
                name =  files(i).name;
                c = {name};
                file_names = [file_names; c];
%                 imwrite(I,sprintf('tmp/gamma/new_test/%s/%s',dir_name, files(i).name));
%                 imwrite(Ic,sprintf('tmp/canny/new_test/%s/%s', dir_name, files(i).name));
            end
        end
    end   
end
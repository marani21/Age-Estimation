function ill_test()

i1 = imread('training-safe/02/24594902_1984-05-14_2012.jpg');
i1 = rgb2gray(i1);

i2 = imread('training-safe/02/23551102_1984-07-03_2012.jpg');
i2 = rgb2gray(i2);

c1 = gammacorrection(i1, 1);
c2 = gammacorrection(i2, 1);
i1_eq = imadjust(i1,[],[], c1);
i2_eq = imadjust(i2,[],[], c2);

imwrite(i1_eq,'illumination_test/24594902_1984-05-14_2012_eq.jpg')
imwrite(i2_eq,'illumination_test/23551102_1984-07-03_2012_eq.jpg')

%imshowpair(i1, i1_eq,'montage')
[Ic1, value1, success1] = get_wrinkle_value('illumination_test/24594902_1984-05-14_2012.jpg');
[Ic1_eq, value1_eq, success1_eq] = get_wrinkle_value('illumination_test/24594902_1984-05-14_2012_eq.jpg');
value1
value1_eq

[Ic2, value2, success2] = get_wrinkle_value('illumination_test/23551102_1984-07-03_2012.jpg');
[Ic2_eq, value2_eq, success2_eq] = get_wrinkle_value('illumination_test/23551102_1984-07-03_2012_eq.jpg');
value2
value2_eq
% 
% images = [i1; i2];
% figure
% imshow(images);
% 
% images_eq = [i1_eq; i2_eq];
% figure
% imshow(images_eq);
end
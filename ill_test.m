function ill_test()

i1 = imread('illumination_test/24594902_1984-05-14_2012.jpg');

i2 = imread('illumination_test/23551102_1984-07-03_2012.jpg');

i3 = imread('illumination_test/malpa.jpg');
i3 = rgb2gray(i3);

i4 = imread('illumination_test/lena.jpg');
i4 = rgb2gray(i4);

c1 = gammacorrection(i1, 1);
c2 = gammacorrection(i2, 1);
c3 = gammacorrection(i3, 1);
c4 = gammacorrection(i4, 1);
i1_eq = imadjust(i1,[],[], c1);
i2_eq = imadjust(i2,[],[], c2);
i3_eq = imadjust(i3,[],[], c3);
i4_eq = imadjust(i4,[],[], c4);
% figure
% imhist(i1)
% figure
% imhist(i1_eq)
imwrite(i1_eq,'illumination_test/24594902_1984-05-14_2012_eq.jpg')
imwrite(i2_eq,'illumination_test/23551102_1984-07-03_2012_eq.jpg')
imwrite(i3_eq,'illumination_test/malpa_eq.jpg')
imwrite(i4_eq,'illumination_test/lena_eq.jpg')
%imshowpair(i1, i1_eq,'montage')
% [Ic1, value1, success1] = get_wrinkle_value('illumination_test/24594902_1984-05-14_2012.jpg');
% [Ic1_eq, value1_eq, success1_eq] = get_wrinkle_value('illumination_test/24594902_1984-05-14_2012_eq.jpg');
% value1
% value1_eq
% 
% [Ic2, value2, success2] = get_wrinkle_value('illumination_test/23551102_1984-07-03_2012.jpg');
% [Ic2_eq, value2_eq, success2_eq] = get_wrinkle_value('illumination_test/23551102_1984-07-03_2012_eq.jpg');
% value2
% value2_eq
% % 
% images = [i1; i2];
% figure
% imshow(images);
% 
% images_eq = [i1_eq; i2_eq];
% figure
% imshow(images_eq);
end
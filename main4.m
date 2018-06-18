%I = imread('training-ideal2/JWfemale81-3neutral.bmp');
I = imread('training-ideal2/85JWfemale85-2neutral.bmp');
%I = imread('training-ideal2/22TMBfemale22-2neutral.bmp');
%I3 = imread('training-ideal2/85JWfemale85-2neutral.bmp');
I3 = imread('training-ideal2/22WWfemale22-3neutral.bmp');
I4 = imread('training-ideal2/EMWmale22-2neutral.bmp');
I5 = imread('training-ideal2/EMWfemale23neutral.bmp');

I = rgb2gray(I);
I3 = rgb2gray(I3);
I4 = rgb2gray(I4);
I5 = rgb2gray(I5);

FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
Face = step(FaceDetect,I);
I=imcrop(I,Face);
[width,height]=size(I);
x = width/height;
I = imresize(I, [190 190*x]);

FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
Face = step(FaceDetect,I3);
I3=imcrop(I3,Face);
FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
Face = step(FaceDetect,I4);
I4=imcrop(I4,Face);
FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
Face = step(FaceDetect,I5);
I5=imcrop(I5,Face);


% figure('Name', 'WWfemale22')
% imhist(I)
% figure('Name', 'JWfemale85')
% imhist(I3)
% figure('Name', 'EMWmale22')
% imhist(I4)
% figure('Name', 'EMWfemale23')
% imhist(I5)
%27TMBfemale27neutral - kopia
%22WWfemale22-3neutral
%85JWfemale85-2neutral
%EMWmale22-2neutral
%EMWfemale23neutral
% I = rgb2gray(I);
% FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
% Face = step(FaceDetect,I);
% 
% I=imcrop(I,Face);
% %imshow(I)
% [width,height]=size(I);
% x = width/height;
% I = imresize(I, [190 190*x]);
% % t = thresholds(1, :);
% %t = [0.01 0.15];
% %[IM_OTSU,opt_td] = otsu(I);
% opt_td
% % figure
% % imshow(I)
% % figure
% % imhist(I)
% 
IC = imread('training-ideal2/czolo_biala_22.bmp');

x = IC;
x = double(x);
average_br = mean2(x)/255;
average_br


%average_br = 0.52;
correction = gammacorrection(I, 1);
I = imadjust(I,[],[], correction);
%I = imgaussfilt(I, 0.8);
I = adapthisteq(I, 'clipLimit',0.0000001,'Distribution','rayleigh');
%I = adapthisteq(I3, 'clipLimit',0.000001,'Distribution','rayleigh', 'Alpha', 2);
[counts,binLocations] = imhist(I);

[M,ind] = max(counts);

% figure('Name', 'After 85')
% imhist(I)
% figure('Name', 'fff')
% imshow(I)
%sum = 0;
% for i=148:208
% c = average_br * 255;
% center = round(c);
% center = center - 40;
% il = center-20;
% ih = center + 20;

center = ind;
center
il = center-20;
ih = center + 20;


for i=il:ih
    sum = sum + counts(i);
end
sum
th = sum*2.5/(40*10000);
th
tl = th/2;
tl
% figure
% imhist(I)

[~, treshOut]= edge(I, 'Canny');
tt = treshOut*0.7;
tt(1) = tt(1) * 1;
tt
I = edge(I,'Canny',tt);
% 
% figure
% imhist(I)
figure
imshow(I)
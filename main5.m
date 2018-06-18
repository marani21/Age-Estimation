I = imread('training-ideal2/22WWfemale22-3neutral.bmp');
IG = rgb2gray(I);
FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
Face = step(FaceDetect,IG);

I=imcrop(I,Face);
IG = imcrop(IG,Face);


[width,height]=size(IG);
x = width/height;
I = imresize(I, [190 190*x]);

[rn, cn, z] = size(I);

for i=1:rn
    i
    for j=1:cn
        rgb = impixel(I, i, j);
        hsv = rgb2hsv(I);
        
        b = rgb(3)/255;
        s = hsv(2);
        
        if(b-s) < 0
            %I = insertShape(I,'FilledCircle',[i j 2], 'Color', 'red');
            I(i, j, 1) = 255;
            I(i, j, 2) = 0;
            I(i, j, 3) = 0;
        end
    end
end
imshow(I);
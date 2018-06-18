function [Image, value, success] = get_wrinkle_value(file, threshold)
value = 0;
success = true;
I = imread(file);
Image = I;

if size(I,3)==3
    I = rgb2gray(I);
end
%fprintf('START');
 
%To detect Face
FaceDetect = vision.CascadeObjectDetector('FrontalFaceLBP');
Face = step(FaceDetect,I);
s = size(Face);
if(s(1) ~= 1) 
    success = false;
    nr = 16;
    return;
end

%Face cropping
I=imcrop(I,Face);


[width,height]=size(I);
x = width/height;
I = imresize(I, [190 190*x]);


MouthDetect = vision.CascadeObjectDetector('Mouth');
MouthDetect.MinSize = [40 25];
Mouth = step(MouthDetect,I);
%----------------------------------------------%
%To detect Eyes
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
EyeDetect.UseROI = true;
roi = [1 1 190 90];
%EyeDetect.MinSize = [emh emw];
Eyes=step(EyeDetect,I, roi);
s = size(Eyes);
if(s(1) ~= 1) 
    success = false;
    nr = 41;
    return;
end
EyesT = Eyes;
EyesT(1) = Eyes(1) + 0.2*Eyes(3);
EyesT(3) = Eyes(3)*0.6;

%d - distance between eyes
d =  EyesT(3);

%right eye center
rec = [EyesT(1) EyesT(2) + 0.5*EyesT(4)];
%left eye center
lec = [EyesT(1)+d EyesT(2) + 0.5*EyesT(4)];

%----------------------------------------------%
lroi = [1 1 95 90];
LeftEyeDetect = vision.CascadeObjectDetector('LeftEye');
LeftEyeDetect.UseROI = true;
LeftEye=step(LeftEyeDetect,I, lroi);
%LeftEye
s = size(LeftEye);
if(s(1) ~= 1) 
    success = false;
    nr = 68;
    return;
end

rroi = [95 1 95 90];
RightEyeDetect = vision.CascadeObjectDetector('RightEye');
RightEyeDetect.UseROI = true;
RightEye=step(RightEyeDetect,I, rroi);
%RightEye
s = size(RightEye);
if(s(1) ~= 1) 
    success = false;
    nr = 80;
    return;
end
%----------------------------------------------%
NoseDetect = vision.CascadeObjectDetector('Nose');
NoseDetect.MergeThreshold = 30;
%NoseDetect.UseROI = true;
%NoseDetect.MinSize = [40 40];
%NoseDetect.MaxSize = [70 70];
roi = [1 90 190 75];
Nose=step(NoseDetect,I);
s = size(Nose);
if(s(1) ~= 1) 
    success = false;
    nr = 98;
    return;
end
%Nose=Nose(1,:);
%nose right 
xnr = Nose(1) + Nose(3)*0.25;
%nose  left
xnl = Nose(1) + Nose(3)*0.75;

%nose center
nc = [Nose(1)+Nose(3)/2 Nose(2)+Nose(4)/2];

%corners = detectMinEigenFeatures(I, 'ROI', Nose);
%corners = corners.selectStrongest(8);

%----------------------------------------------%
%forehead
Forehead = [rec(1) rec(2)-0.9*d d 0.5*d];

%forehead low center
flc = [Forehead(1) + Forehead(3)/2 Forehead(2)+Forehead(4)];
%----------------------------------------------%
%Chicks

ch_x1 = LeftEye(1);
ch_x2 = Nose(1) + Nose(3);
ch_y1 = LeftEye(2) + LeftEye(4);
ch_y2 = RightEye(2) + RightEye(4);
ch_w1 = (Nose(1) - Eyes(1));% * 0.8;
ch_w2 = (RightEye(1) + RightEye(3)) - ch_x2;
ch_h1 = (nc(2) - ch_y1)*1.2;  %0.8 na 1.2
ch_h2 = nc(2) - ch_y2;

%poprawki
%sr_w = 0.2 * ch_w2;
%ch_w2 = ch_w2 * 0.8;
ch_h2 = ch_h2 * 1.2;

%ch_x2 = ch_x2 + sr_w;


LeftChick = [ch_x1 ch_y1 ch_w1 ch_h1];
RightChick = [ch_x2 ch_y2 ch_w2 ch_h2];

%----------------------------------------------%
%Temples

x1 = LeftEye(1) - ch_w1/2;
x2 = RightEye(1) + RightEye(3);
y1 = LeftEye(2) + 1/3*LeftEye(4); %1/2 na 1/3
y2 = RightEye(2) + 1/3*RightEye(4); %1/2 na 1/3
h1 = (ch_y1 + 1/2*ch_h1) - y1;
h2 = (ch_y2 + 1/2*ch_h2) - y2;
w1 = 1/2 * ch_w1;
w2 = 1/2 * ch_w2;

LeftTemple = [x1 y1 w1 h1];
RightTemple = [x2 y2 w2 h2];
%----------------------------------------------%
%Drawing
%I = insertShape(I,'rectangle',Mouth, 'Color', 'blue');
%I = insertShape(I,'rectangle', Eyes , 'Color', 'blue');
%I = insertShape(I,'rectangle', LeftEye , 'Color', 'yellow');
%I = insertShape(I,'rectangle', RightEye , 'Color', 'green');
%I = insertShape(I,'rectangle',lroi, 'Color', 'yellow');
%I = insertShape(I,'rectangle',rroi, 'Color', 'yellow');
% for i = 1:length(corners)
%     I = insertShape(I,'circle', [corners.Location(i, 1) corners.Location(i, 2) 1], 'Color', 'yellow');
% end

%I = insertShape(I,'rectangle',Nose, 'Color', 'blue');
%I = insertShape(I,'circle',[nc(1) nc(2) 2], 'Color', 'red');
% 
%I = insertShape(I,'rectangle',Forehead, 'Color', 'red');
%I = insertShape(I,'circle',[flc(1) flc(2) 2], 'Color', 'red');
% 
%I = insertShape(I,'circle',[rec(1) rec(2) 2], 'Color', 'red');
%I = insertShape(I,'circle',[lec(1) rec(2) 2], 'Color', 'red');
% 
% 
% 
le_endx = LeftEye(1)+LeftEye(3);
betweenl = RightEye(1) - le_endx;

%BEyes = [xnr Forehead(2)+Forehead(4) xnl-xnr 0.4*d];

BEyes = [le_endx+betweenl/5 Forehead(2)+Forehead(4) (3/5)*betweenl 0.4*d];
%I = insertShape(I,'rectangle',BEyes, 'Color', 'red');
% 
%I = insertShape(I,'rectangle',LeftChick, 'Color', 'red');
%I = insertShape(I,'rectangle',RightChick, 'Color', 'red');
% 
% 
%I = insertShape(I,'rectangle',LeftTemple, 'Color', 'red');
%I = insertShape(I,'rectangle',RightTemple, 'Color', 'red');

%--------------------------------------------
%I = imgaussfilt(I, 1.2);


correction = gammacorrection(I, 1);
I = imadjust(I,[],[], correction);
I = adapthisteq(I, 'clipLimit',0.000001,'Distribution','rayleigh');
IF = imcrop(I, Forehead);
x = IF;
x = double(x);
average_br = mean2(x)/255;
average_br
[counts,binLocations] = imhist(I);
% figure
% % imshow(I)
% imhist(I)
sum1 = 0;
% c = average_br * 255;
% center = round(c);
% center = center - 40;
% center


% [M,ind] = max(counts);
% center = ind;
% center
% il = center-10;
% ih = center+10;
% for i=il:ih
%     sum1 = sum1 + counts(i);
% end
% th = sum1*2/(20*10000);
% tl = th/2;
% %I = imgaussfilt(I,1.5);
% %0.0005
% 
% %h = ones(5,5)/25;
% %I = imfilter(I,h);
% tl 
% th
[~, treshOut]= edge(I, 'Canny');
tt = treshOut*0.7;
tt(1) = tt(1) * 1;
I = edge(I,'Canny',tt);



%------------------------
[forehead_count] = imhist(imcrop(I,Forehead));
[byes_count] = imhist(imcrop(I,BEyes));
[left_chick_count] = imhist(imcrop(I,LeftChick));
[right_chick_count] = imhist(imcrop(I,RightChick));
[left_temple_count] = imhist(imcrop(I,LeftTemple));
[right_temple_count] = imhist(imcrop(I,RightTemple));
v = [0, 0, 0, 0, 0, 0];
v(1) = forehead_count(2)/(forehead_count(1)+forehead_count(2));
v(2) = byes_count(2)/(byes_count(1)+byes_count(2));
v(3) = left_chick_count(2)/(left_chick_count(1)+left_chick_count(2));
v(4) = right_chick_count(2)/(right_chick_count(1)+right_chick_count(2));
v(5) = left_temple_count(2)/(left_temple_count(1)+left_temple_count(2));
v(6) = right_temple_count(2)/(right_temple_count(1)+right_temple_count(2));


value = sum(v);
%------------------------
%figure,
%imshow(I);   
%hold on;
%rectangle('Position',Face,'EdgeColor','b');

%plot(rec(1), rec(2), 'ro', 'MarkerSize', 2);
%plot(lec(1), lec(2), 'ro', 'MarkerSize', 2);



%rectangle('Position',Forhead,'EdgeColor','r');

%rectangle('Position',Nose,'EdgeColor','b');
%rectangle('Position',Eyes,'EdgeColor','b');

%between eyes
% BEyes = [xnr Forhead(2)+Forhead(4) xnl-xnr 0.4*d];
% plot(xnr, Forhead(2) + Forhead(4), 'ro', 'MarkerSize', 4);
% plot(xnl, Forhead(2) + Forhead(4), 'ro', 'MarkerSize', 4);
% 
% rectangle('Position',BEyes,'EdgeColor','r');
%fprintf('END');
Image = I;

end
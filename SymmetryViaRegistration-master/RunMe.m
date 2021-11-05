function [p,q]=RunMe(Image)

[angles, midPoints, segLengths] = symmetryViaRegistration2D(Image);

ag = angles(1);
mp = midPoints(:,1);
sl = segLengths(1);
p = mp+sl/2*[cos(ag); sin(ag)];
q = mp-sl/2*[cos(ag); sin(ag)];
Image = insertShape(Image,'line',[p(2) p(1) q(2) q(1)],'LineWidth',3,'Color','red');
figure(9)
imshow(Image);


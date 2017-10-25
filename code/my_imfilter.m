function output = my_imfilter(image, filter)
% This function is intended to behave like the built in function imfilter()
% See 'help imfilter' or 'help conv2'. While terms like "filtering" and
% "convolution" might be used interchangeably, and they are indeed nearly
% the same thing, there is a difference:
% from 'help filter2'
%    2-D correlation is related to 2-D convolution by a 180 degree rotation
%    of the filter matrix.
% Your function should work for color images. Simply filter each color
% channel independently.
% Your function should work for filters of any width and height
% combination, as long as the width and height are odd (e.g. 1, 7, 9). This
% restriction makes it unambigious which pixel in the filter is the center
% pixel.
% Boundary handling can be tricky. The filter can't be centered on pixels
% at the image boundary without parts of the filter being out of bounds. If
% you look at 'help conv2' and 'help imfilter' you see that they have
% several options to deal with boundaries. You should simply recreate the
% default behavior of imfilter -- pad the input image with zeros, and
% return a filtered image which matches the input resolution. A better
% approach is to mirror the image content over the boundaries for padding.
% % Uncomment if you want to simply call imfilter so you can see the desired
% % behavior. When you write your actual solution, you can't use imfilter,
% % filter2, conv2, etc. Simply loop over all the pixels and do the actual
% % computation. It might be slow.
% output = imfilter(image, filter);

%%%%%%%%%%%%%%%%
% Your code here
%%%%%%%%%%%%%%%%
% RGB channel
R(:,:) = double(image(:,:,1));
G(:,:) = double(image(:,:,2));
B(:,:) = double(image(:,:,3));
[height, width, channel] = size(image);
%filter size
[filter_h, filter_w] = size(filter);

R_filter_space = zeros(2*filter_h -2 + height,2*filter_w - 2 + width);
G_filter_space = zeros(2*filter_h -2 + height,2*filter_w - 2 + width);
B_filter_space = zeros(2*filter_h -2 + height,2*filter_w - 2 + width);
R_filter_space (filter_h:filter_h + height-1,filter_w:filter_w + width-1) = R;
G_filter_space (filter_h:filter_h + height-1,filter_w:filter_w + width-1) = G;
B_filter_space (filter_h:filter_h + height-1,filter_w:filter_w + width-1) = B;

%Create space to store the results
R_filter_result = zeros(filter_h -1 + height,filter_w - 1 + width);
G_filter_result = zeros(filter_h -1 + height,filter_w - 1 + width);
B_filter_result = zeros(filter_h -1 + height,filter_w - 1 + width); 
 
%Flip the filter
filter_flip = fliplr(flipud(filter));

%Calculating
 for x = 1: filter_w + width - 1
     for y = 1: filter_h + height - 1;
         R_filter_result(y,x) = sum(sum(filter_flip .* R_filter_space(y:y+filter_h-1,x:x+filter_w-1))); 
         G_filter_result(y,x) = sum(sum(filter_flip .* G_filter_space(y:y+filter_h-1,x:x+filter_w-1))); 
         B_filter_result(y,x) = sum(sum(filter_flip .* B_filter_space(y:y+filter_h-1,x:x+filter_w-1))); 
     end
 end
 %truncation to get same resolution as input
 delete_x = floor(filter_w/2);
 delete_y = floor(filter_h/2);
 

  output = zeros(height:width:3);
  output(:,:,1) = R_filter_result(delete_y+1:delete_y+height,delete_x+1:delete_x+width);
  output(:,:,2) = G_filter_result(delete_y+1:delete_y+height,delete_x+1:delete_x+width);
  output(:,:,3) = B_filter_result(delete_y+1:delete_y+height,delete_x+1:delete_x+width);

%%%%%%%%%%%%%%%%
% Your code end
%%%%%%%%%%%%%%%%

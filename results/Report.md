# 翁啟文 <span style="color:red">(103061112)</span>

# HW1 / Image Filtering and Hybrid Images

## Overview
The project is related to image filtering and hybrid images.   
While implementing image filtering, we have to know how filtering works ─it's all about "convolution." So we will write my_imfilter(), a function which does the same thing as Matlab build-in function "imfilter" does.

After finishing the above image filtering function, what we do next is to produce hybrid images by combining two filtered images: one passes through a low-pass filter(Gaussian filter) and the other one passes through a high-pass filter. For those who stand far away from the hybrid image, they will see the low-pass filtered one, but for those who stand close to it, they will see the high-passed filtered one. This phenomenon is related to human's visual perception. People identify a contour of an object at a distance while see the details when they look at it closely. So by blending the high frequency portion of one image and the low frequency protion of another, we can makes hybrid image look different at different distances. 

## Implementation  
1. Image Filtering(my_imfilter.m)  
	We write a matlab function that works same as the build-in function "imfilter()" (or other similar functions in Matlab), and the followings describe how I implement it.
	First, read the information about the source image (i.e. RGB values, height, width) and the filter (i.e. filter_h, filter_w, value), and create appropriate arrays to store these RGB values with zero padding. The minimun number of zeros we pad around the source image are __2*(width-1)__ at right and left sides of the image, and __2*(height-1)__ at top and bottom of it:
	<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/results/zeropadding_explanation.jpg width="70%"/>  
	```Matlab
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
	
	%Putting the source image in the middle of array and we acheive zero padding!
	R_filter_space (filter_h:filter_h + height-1,filter_w:filter_w + width-1) = R;
	G_filter_space (filter_h:filter_h + height-1,filter_w:filter_w + width-1) = G;
	B_filter_space (filter_h:filter_h + height-1,filter_w:filter_w + width-1) = B;

	```
	Next, prepare array space to store computation results, the height and width of the result image are __(height+filter_h-1)__ and __(width+filter_w-1)__.
	```Matlab
	%Create space to store the results
	R_filter_result = zeros(filter_h -1 + height,filter_w - 1 + width);
	G_filter_result = zeros(filter_h -1 + height,filter_w - 1 + width);
	B_filter_result = zeros(filter_h -1 + height,filter_w - 1 + width); 
	```  
	Now, we are ready to calculate convolution. I use double-nested for loop to conduct element-by-element multiplication and sum up the elements of the result matrix . As for mulplitication, because we are doing "convolution," we have to first flip the filter matrix horizontally and vertically (Same as what we've done in HW0), then do the multiplication and sum-up.
	```Matlab
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
	```
	Finally, we have to truncate the result to give out the filtered result with the same resolution as the source image. We throw out some pixels around the result image.  
	<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/results/truncation_explanation.jpg width="40%"/>
	```Matlab
	 %truncation to get same resolution as input
	 delete_x = floor(filter_w/2);
	 delete_y = floor(filter_h/2);
	 
	output = zeros(height:width:3);
	output(:,:,1) = R_filter_result(delete_y+1:delete_y+height,delete_x+1:delete_x+width);
	output(:,:,2) = G_filter_result(delete_y+1:delete_y+height,delete_x+1:delete_x+width);
	output(:,:,3) = B_filter_result(delete_y+1:delete_y+height,delete_x+1:delete_x+width);

	```  
	In testing matlab file "proj_test_filtering.m," it proceeds a cat image by using different filters to check the functionality of my_imfilter(), and followings are results:
	### Result:
	
	|Identify filter|Small blur with a box filter|Large blur|Sobel Operator|High pass filter (Laplacian)|High pass "filter" alternative|
	|---------------|---------------|---------------|---------------|---------------|---------------|
	|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/code/Part1%20result/identity_image.jpg width="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/code/Part1%20result/blur_image.jpg  width="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/code/Part1%20result/large_blur_image.jpg width="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/code/Part1%20result/sobel_image.jpg width="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/code/Part1%20result/laplacian_image.jpg width="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/code/Part1%20result/high_pass_image.jpg width="70%"/>|
	
2. Hybrid images: 
	To produce Hybrid images, we need a low-pass filter and a high-pass filter. Here we choose Gausian filter as a LPF. Using identity filter minus Gausian filter, we get a HPF. To show a high-pass filtered image with right data range, we have to add 0.5 to the result so the image is visualized. Finally, we sum both results up and show the hybrid image on the screen. To see the changes apparently, we size the hybrid image by downsampling and put the original hybrid image and its copies with smaller sizes together to compare their differences.
	```Matlab
	%Create LPF
	cutoff_frequency = 5; 
	filter = fspecial('Gaussian', cutoff_frequency*4+1, cutoff_frequency);
	%Create HPF
	[filter_com_h, filter_com_w]= size(filter);
	filter_com = zeros(filter_com_h, filter_com_w);
	filter_com(ceil(filter_com_h/2),ceil(filter_com_w/2))=1;
	filter_com = filter_com - filter;
	%Convolution
	low_frequencies= my_imfilter(image1,filter);
	high_frequencies= my_imfilter(image2,filter_com);
	hybrid_image= (low_frequencies + high_frequencies);
	%% Visualize and save outputs
	figure(1); imshow(low_frequencies);
	figure(2); imshow(high_frequencies + 0.5);
	vis = vis_hybrid_image(hybrid_image);
	figure(3); imshow(vis);
	imwrite(low_frequencies, 'low_frequencies.jpg', 'quality', 95);
	imwrite(high_frequencies + 0.5, 'high_frequencies.jpg', 'quality', 95);
	imwrite(hybrid_image, 'hybrid_image.jpg', 'quality', 95);
	imwrite(vis, 'hybrid_image_scales.jpg', 'quality', 95);
	```
	Cut-off frequency: This is the frequency where a LPF has its gain equal to 0.5. We can adjust this value depending on different hybrid image productions. After several experiments, I found that __the smaller the cut-off frequency is, the clearer the low-pass filtered image is.__ On the other hand, if we __raise the cut-off frequency, we can see the high-pass filtered image more clearly.__ So it depends on what input image we want to process and what kind of hybrid images we want to show.
	Followings are the results, including the images given by TA and two additional images I downloaded from the Internet.
	### Result:
	
	|Bicycle (LPF)|Motorcycle (HPF)|Hybrid image|
	|--------------|--------------|-------------|
	|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/data/bicycle%2Bmotorcycle(10)/low_frequencies.jpg="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/data/bicycle%2Bmotorcycle(10)/high_frequencies.jpg  width="70%"/>|<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/data/bicycle%2Bmotorcycle(10)/hybrid_image_scales.jpg width="70%"/>|
## Installation
* Other required packages.
* How to compile from source?

### Results

<table border=1>
<tr>
<td>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg"  width="24%"/>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg" width="24%"/>
</td>
</tr>

<tr>
<td>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg"  width="24%"/>
<img src="placeholder.jpg" width="24%"/>
<img src="placeholder.jpg" width="24%"/>
</td>
</tr>

</table>

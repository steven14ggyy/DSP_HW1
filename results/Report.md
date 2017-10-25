# 翁啟文 <span style="color:red">(103061112)</span>

# HW1 / Image Filtering and Hybrid Images

## Overview
The project is related to image filtering and hybrid images.   
While implementing image filtering, we have to know how filtering works ─it's all about "convolution." So we will write my_imfilter(), a function which does the same thing as Matlab build-in function "imfilter" does.  
After finishing the above image filtering function, what we do next is to produce hybrid images by combining two filtered images: one passes through a low-pass filter(Gaussian filter) and the other one passes through a high-pass filter. For those who stand far away from the hybrid image, they will see the low-pass filtered one, but for those who stand close to it, they will see the high-passed filtered one. This phenomenon is related to human's visual perception. People identify a contour of an object at a distance while see the details when they look at it closely. So by blending the high frequency portion of one image and the low frequency protion of another, we can makes hybrid image look different at different distances. 

## Implementation  
1. Image Filtering (my_imfilter.m)  
	We write a matlab function that works same as the build-in function "imfilter()" (or other similar functions in Matlab), and the followings describe how I implement it.
	first, read the information about the source image (i.e. RGB values, height, width) and the filter (i.e. filter_h, filter_w, value), and create appropriate arrays to store these RGB values with zero padding. The minimun number of zeros we pad around the source image are __2*(width-1)__ at right and left sides of the image, and __2*(height-1)__ at top and bottom of it:
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
	Now, we are ready to calculate convolution. I use double-nested for loop to conduct Matrix multiplications. As for mulplitication, because we are doing "convolution," we have to first flip the filter matrix horizontally and vertically (Same as what we've done in HW0), then do matrix multiplications.
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
	<img src=https://github.com/steven14ggyy/DSP_Lab_HW1/blob/master/results/truncation_explanation.jpg width="70%"/>  
2. Hybrid images: 

```
Code highlights
```

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

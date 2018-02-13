// Macro to create side-by-side 2D and 3D hexbin plots for timeseries, using image sequences generated in Python.
// By Tyler Sloan
// Copyright Creative Commons Non-Commercial

// Install the macro in FIJI (Plugins > Macros > install), and select one of the 4 options from the macros drop-down menu.
// If you have individual files in a folder, choose the "(folder)" option. If they are already in an image stack, choose "(stack)"
// To create 3D representation of a single set of images, choose ("Grayscale 2D + 3D).
// Otherwise, to plot 2 datasets in magenta and cyan, choose the "2-color" option and pay special attention in the open dialogue message.



macro "Grayscale 2D + 3D (folder)" {

	// Open a file in the folder
	file = File.openDialog("Open a file in the folder to process"); // Returns path to this file
	filename = File.getName(file);
	filename = substring(filename, 0, lengthOf(filename) - 5);
	path = File.directory;	// Returns path to the folder
	parent = File.getParent(path); 
	cropBool = getBoolean("Crop whitespace from around image (from matplotlib)?");


	open(path,"virtual");
	filename = getInfo("image.filename");
	selectImage(1);
	rename("Source");
	
	if(cropBool == 1){
		// Crop the images
		var xPos = 1484/2-600;
		var yPos = 1460/2-600 - 7;			// Extra 7 pixels centers the square better.
		selectWindow("Source");
		makeRectangle(xPos, yPos, 1200, 1200);
		run("Crop");
	} 
	
	selectWindow("Source");
	run("8-bit");
	run("Surface Plot...", "polygon=100 shade fill one stack");
	
	selectWindow("Surface Plot");
	rename("Surface");
	
	// Scale both to 960 (1/2 of HD x dimension)
	selectWindow("Source");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Source_scaled");
	selectWindow("Surface");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Surface_scaled");
	// Combine the 8 bit grayscale images
	run("Combine...", "stack1=Source_scaled stack2=Surface_scaled");
	
	selectWindow("Combined Stacks");
	run("Movie...", "frame=20 container=.mp4 using=MPEG4 video=excellent save=" + parent + filename+".mp4"); // Z:\\DataViz\\mtlTrajet\\mp4\\test.mp4");
	selectWindow("Source");
	close();
	selectWindow("Surface");
	close();
}


//-----------------------------
//-----------------------------
//-----------------------------

 // Macro 2 for making a 2-color image

macro "2-color 2D + 3D (folder)" {
	// Open a file in the folder
	file1 = File.openDialog("Open first file (to be cyan)"); // Returns path to this file
	path1 = File.directory;	// Returns path to the folder
	file2 = File.openDialog("Open second file (to be magenta)"); // Returns path to this file
	path2 = File.directory;	// Returns path to the folder
	
	parent = File.getParent(path1); 
	filename = getString("Write the name of the filename to save", "test_output");
	open(path1,"virtual");
	open(path2,"virtual");
	
	// Crop the images
	var xPos = 1484/2-600;
	var yPos = 1460/2-600 - 7;			// Extra 7 pixels centers the square better.
	selectImage(1);
	makeRectangle(xPos, yPos, 1200, 1200);
	run("Crop");
	rename("Source_1");
	
	selectImage(2);
	makeRectangle(xPos, yPos, 1200, 1200);
	run("Crop");
	rename("Source_2");
	
	// Rename the opened files to be easier to manage
	selectWindow("Source_1");
	run("8-bit");
	run("Surface Plot...", "polygon=100 shade fill one stack");
	selectWindow("Surface Plot");
	rename("Surface_1");
	
	selectWindow("Source_2");
	run("8-bit");
	run("Surface Plot...", "polygon=100 shade fill one stack");
	selectWindow("Surface Plot");
	rename("Surface_2");
	
	// Create the merge for both source and surfaces
	run("Merge Channels...", "c5=[Source_1] c6=[Source_2] create keep");
	selectWindow("Composite");
	rename("Source_composite");
	run("RGB Color", "slices");
	
	run("Merge Channels...", "c5=[Surface_1] c6=[Surface_2] create keep");
	selectWindow("Composite");
	rename("Surface_composite");
	run("RGB Color", "slices");
	
	// Scale both to 960 (1/2 of HD x dimension) and combine them
	selectWindow("Source_composite");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Source_scaled");
	selectWindow("Surface_composite");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Surface_scaled");
	run("Combine...", "stack1=Source_scaled stack2=Surface_scaled");
	
	selectWindow("Combined Stacks");
	run("RGB Color", "slices");
	
	run("Movie...", "frame=20 container=.mp4 using=MPEG4 video=excellent save=" + parent + filename+".mp4"); // Z:\\DataViz\\mtlTrajet\\mp4\\test.mp4");
	
	// Close all but the final window
	selectWindow("Source_composite");
	close();
	selectWindow("Surface_composite");
	close();
	selectWindow("Source_1");
	close();
	selectWindow("Source_2");
	close();
	selectWindow("Surface_1");
	close();
	selectWindow("Surface_2");
	close();

}


// ---------------------------------------------------------------
// Same macros as above, but to start with a tiff image stack.
// ---------------------------------------------------------------


macro "Grayscale 2D + 3D (stack)" {

	// Open a file in the folder
	file = File.openDialog("Open a file in the folder to process"); // Returns path to this file
	filename = File.getName(file);
	filename = substring(filename, 0, lengthOf(filename) - 5);
	path = File.directory;	// Returns path to the folder
	parent = File.getParent(path); 
	
	open(path,"virtual");
	filename = getInfo("image.filename");
	print(filename);
	var xPos = 1484/2-600;
	var yPos = 1460/2-600 - 7;			// Extra 7 pixels centers the square better.
	makeRectangle(xPos, yPos, 1200, 1200);
	run("Crop");
	print(getImageID());
	selectImage(1);
	rename("Source");
	
	selectWindow("Source");
	run("8-bit");
	run("Surface Plot...", "polygon=100 shade fill one stack");
	
	selectWindow("Surface Plot");
	rename("Surface");
	
	// Scale both to 960 (1/2 of HD x dimension)
	selectWindow("Source");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Source_scaled");
	selectWindow("Surface");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Surface_scaled");
	// Combine the 8 bit grayscale images
	run("Combine...", "stack1=Source_scaled stack2=Surface_scaled");
	
	selectWindow("Combined Stacks");
	run("Movie...", "frame=20 container=.mp4 using=H.264 video=excellent save="+ parent + filename+".mp4");
	selectWindow("Source");
	close();
	selectWindow("Surface");
	close();
}


//-----------------------------
//-----------------------------
//-----------------------------

 // Macro 2 for making a 2-color image

macro "2-color 2D + 3D (stack)" {
	// Open a file in the folder
	file1 = File.openDialog("Open first file (to be cyan)"); // Returns path to this file
	//path1 = File.directory;	// Returns path to the folder
	file2 = File.openDialog("Open second file (to be magenta)"); // Returns path to this file
	//path2 = File.directory;	// Returns path to the folder
	cropBool = getBoolean("Crop whitespace from around image (from matplotlib)?");
	parent = File.getParent(file1); 
	filename = getString("Write the name of the filename to save", "\\test_output");
	// Open and rename the files to be easier to manage, remove any color
	open(file1,"virtual");
	selectImage(1);
	run("RGB Color", "slices");
	run("8-bit");
	rename("Source_1");
	open(file2,"virtual");
	selectImage(2);
	run("RGB Color", "slices");	
	run("8-bit");
	rename("Source_2");

	if(cropBool == 1){
		// Crop the images
		var xPos = 1484/2-600;
		var yPos = 1460/2-600 - 7;			// Extra 7 pixels centers the square better.
		selectWindow("Source_1");
		makeRectangle(xPos, yPos, 1200, 1200);
		run("Crop");
		selectWindow("Source_2");
		makeRectangle(xPos, yPos, 1200, 1200);
		run("Crop");
	} 
	
	// Create surface plots
	selectWindow("Source_1");
	run("8-bit");
	run("Surface Plot...", "polygon=100 shade fill one stack");
	selectWindow("Surface Plot");
	rename("Surface_1");
	
	selectWindow("Source_2");
	run("8-bit");
	run("Surface Plot...", "polygon=100 shade fill one stack");
	selectWindow("Surface Plot");
	rename("Surface_2");
	
	// Create the merge for both source and surfaces
	run("Merge Channels...", "c5=[Source_1] c6=[Source_2] create keep");
	selectWindow("Composite");
	rename("Source_composite");
	run("RGB Color", "slices");
	
	run("Merge Channels...", "c5=[Surface_1] c6=[Surface_2] create keep");
	selectWindow("Composite");
	rename("Surface_composite");
	run("RGB Color", "slices");
	
	// Scale both to 960 (1/2 of HD x dimension) and combine them
	selectWindow("Source_composite");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Source_scaled");
	selectWindow("Surface_composite");
	run("Scale...", "x=- y=- z=1.0 width=960 height=960 interpolation=Bilinear average process create title=Surface_scaled");
	run("Combine...", "stack1=Source_scaled stack2=Surface_scaled");
	
	selectWindow("Combined Stacks");
	run("RGB Color", "slices");
	
	//run("Movie...", "frame=20 container=.mp4 using=MPEG4 video=excellent save=" + parent + filename+"_mpeg4Compressed.mp4"); // Z:\\DataViz\\mtlTrajet\\mp4\\test.mp4");
	//run("Movie...", "frame=20 container=.mp4 using=MPEG4 video=excellent save=" + parent + filename+"_mpeg4Compressed.mp4"); // Z:\\DataViz\\mtlTrajet\\mp4\\test.mp4");	
	print(parent);
	run("Movie...", "frame=20 container=.mp4 using=H.264 video=excellent save="+ parent + filename+".mp4");
	print(parent + filename);
	// Close all but the final window
	selectWindow("Source_composite");
	close();
	selectWindow("Surface_composite");
	close();
	selectWindow("Source_1");
	close();
	selectWindow("Source_2");
	close();
	selectWindow("Surface_1");
	close();
	selectWindow("Surface_2");
	close();

}

 
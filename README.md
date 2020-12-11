# modify
modular digital image processor
animate in Processing. Good fun. 

SETUP :

You will need to install [Processing](https://processing.org/download/) and make sure the CP5 library is properly installed. This is easy. In the Processing IDE, find Sketch > Import Library > Add Library. Find ControlP5 and click buttons. After this, the PDE file should run without a hitch. You will note that there is some Java included, which will run in Processing. thanks to Kurt Spencer for his implementation of open simplex noise.

GETTING STARTED :

The workflow is inspired by the programming language PureData.

Add a noise module from the Generator column and a display module from the output column. Move the modules around the sketch by clicking and dragging the black grabber nodes at the top center. To Connect the output of the noise generator to in the input of the display, first click the output of the noise module. You should see a line originating at the ouput you clicked following your cursor position. The next data input node you click on will form a connection. Click on the input node of the data module to see what noise looks like. 

Move the generator sliders around, have some fun.

Once you catch your breath, delete the connection by hovering the line between the modules (it should appear bold when hovered) and pressing the 'd' key. The connection is destroyed (to erase entire modules from existence, hover the grabber node and hit 'd', you monster). Go back to the menu, add a gate module from the functions column. Connect the noise generator output to the gate input, then connect the gate output to the display input. Move the sliders on the gate module around. Observe what they do. Feel the difference they make. Three modules become one. You are in control.

Add a basicMod from the modifier column. What is it doing? Why is that red dot there? Figure it out. Connect the gray output on the basicMod to the gray input on the noise generator. Hell, you could even connect it to both gray inputs. If you're a lunatic you could grab four basicMods and attach one to each of the two modifier inputs on the noise module and the gate module. Once you are pleased with your routing, discover the variety of basicMod by clicking buttons and moving sliders. This is the only way to learn.

GOAL :

develop a visual style around modular animation. Much like a sound synthesizer, you can quickly and easily learn to use this tool to create a wonderfully chaotic experience. However, with time and thoughtful practice, you could also learn to create more familiar, intentional items. Just gotta build a tool kit that is flexible.

COMING FEATURES :

color - right now, all output is grayscale. Display will soon have RGB inputs.

record - There is a Movie Maker tool in Processing that allows for a quick conversion of what's displaying to a .mov file.

algorithm - this one is exciting. It is a powerful module that will allow the user to define a pixel-based algorithm. The user will decide
which pixels get acted on with a mask input, conditions that must be met by said pixels, and actions performed given that those conditions are satisfied. For example, for (every pixel on the left side of the screen), if (the pixel has a neighbor above/below with identical value), then (swap positions with a neighbor to the left/right). Building this will be a journey to find the balance between flexibility and usefulness

feedback - right now, if you create a closed loop in the patch, you will make the thing sad. That is temporary. Soon, we will be able to do feedback which will be a game changer.

audio input - seems like it wants to have an audio module as a modifier. Not sure exactly how I would want to implement that though.

DOCUMENTATION :

~ generators ~

math - define an expression and the range over which to evaluate the expression using reverse polish notation (eg. x+y would be written xy+, and x^2+y^2 would be written x2^y2^+). The default, "xs", is sin(x). The two textfields that say 250 are the dimensions of the output. When you click the button to their right, they will update the dimensions of every module down the line, all the way to any connected display. Don't have two modules disagreeing on dimensions(I'll do an error message eventually). The boxes with -10 and 10 define the range over which to evaluate the expression, and the button sends the expression to the expression evaluator (although forming a connection will do this automatically). The expression evaluator maps the min and the max of the evaluation to 0 and 255.

noise - Generate a Perlin Noise field. Polar or cartesian. Again, dimension boxes. The sliders define an increment on the x and y axis that are used to sample the noise. The box above the sliders is the noise seed. Use these text boxes to synchronize noise seeds if you'd like. By default a new seed is generated with every module that uses noise (right now, just noise and basicMod).

image - Hit the button and use the file select screen to navigate to an image (just jpg works I think). All connected modules should resize accordingly, there might be some bugs with resizing. Will tackle them soon.

draw - will be for drawing masks (full black and white, no gray scale, just 0 and 255.. yin and yang, off and on, yes and no, no ifs ands or 127s). This will be useful for more concrete animation sequences. Will make evoking specific forms much easier

text - Again, map text to a mask, maybe a scroll list with different fonts


~ functions ~

compare - two modes. Mask mode, and either/or mode. In mask mode, the output of the pixel is white if the equality/inequality condition is met (read left input, condition, right input), and black otherwise. In either/or mode, the vaule of the left input is pushed through if the condition is met, and the right input otherwise. The slider is a threshold for when you are set to = mode. It corresponds to how close the inputs need to be for the condition to be met.

combine - Expression evaluator again. This time two data inputs. The left input is 'x' and the right is 'y'. The default is "xy+2/", which will give the average of the two inputs. I'll soon list more instruction on how to use the expression evaluator.

gate - If the pixel value is above the top slider value, push that pixel to white. If it is below the bottom slider value, push it to black. Otherwise, leave it the same.

boundary - simple edge detector. Useful in conjunction with gate to draw an outline of a shape. Top slider is the threshold for the difference between neighboring pixels that constitutes a boundary. Bottom is the thickness of the boundary line being drawn. Outputs a mask.

mask - A way to combine to images. Right input is a mask, typically (but not necessarily) black and white. The sliders correspond to the target and tolerance applied to the mask. for each pixel in the mask that satisfies the target/tolerance, push the value of the left input through. For each pixel that doesn't satisfy, push the right pixel through.

util - Utility for (in descending order) multiplying by a constant, multiplying by a small teeny constant, adding a constant, and inverting an image.

redux - pixellate


~ modifiers ~

basicMod - amplitude, duration, and quantization of the modifier data array. Invert and reverse the array with the buttons. Change the noise seed with the text field. six different standard envelope types

sampler - Generate a modifier envelope with the first row of an image input. Use this with a math generator to get custom defined modifier envelopes

~ output ~

display - does the damn thing. Takes the data input (values from 0 to 255), and generates a grayscale image. Will soon have RGB channels that override.

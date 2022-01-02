import os

import matplotlib.image as mpimg
import numpy as np
import numpy.random
import pandas as pd
import pylab as pl
from plotnine import *


dimg = mpimg.imread("../primitive/hawaii_night.jpg")

# Computed to get to 10k points...
num_points = 10000
img_height, img_width, _ = dimg.shape
cell_height = int(np.floor(np.sqrt(img_height * img_width / num_points)))
cell_width = cell_height

data = []
for y in range(0, img_height, cell_height):
	for x in range(0, img_width, cell_width):
		cell_color = dimg[y:y+cell_height, x:x+cell_height, :].mean(axis=(0,1)) / 255
		data.append({
			"x": x,
			"y": y,
			"r": cell_color[0],
			"g": cell_color[1],
			"b": cell_color[2],
			"rgb": matplotlib.colors.to_hex(cell_color),
		})
df = pd.DataFrame(data)

# Plot...
new_img = (ggplot(aes(x="x", y="-y", color="rgb"), data=df) 
	+ geom_jitter(width=1.5*cell_width, height=1.5*cell_height, size=0.3) 
	+ scale_color_identity() 
	+ theme_void() 
	+ coord_fixed(ratio=img_height / img_width) 
	+ theme(panel_background = element_rect(fill = 'black', colour = 'black'))
)
new_img.save(
	"outputs/day01_points.jpg", 
	height=img_height / img_width * 4, 
	width=4, 
	units="in"
)

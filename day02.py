import os

import matplotlib
import matplotlib.image as mpimg
import numpy as np
import numpy.random
import pandas as pd
import pylab as pl
from plotnine import *
from scipy.spatial import Delaunay
from skimage import feature


def dither_with_points(fname, num_points, background_color="black"):
	dimg = mpimg.imread(fname)  # Read the image
	if len(dimg.shape) > 2:
		dimg = rgb2gray(dimg)		# Turn to grayscale

	# We'll aggregate squares of pixels into one point.
	# First we figure out how many pixels should go into each square.
	img_height, img_width = dimg.shape
	cell_height = int(np.floor(np.sqrt(img_height * img_width / num_points)))
	cell_width = cell_height

	# Create a dataframe for each point.
	data = []
	max_val = dimg.max()
	for y in range(0, img_height, cell_height):
		for x in range(0, img_width, cell_width):
			cell_color = dimg[y:y+cell_height, x:x+cell_height].mean() / max_val
			data.append({
				"x": x,
				"y": y,
				"val": cell_color
			})
	df = pd.DataFrame(data)

	# Randomly make the point be black or white depending on the grayscale value.
	df["is_on"] = np.random.rand(len(df)) < df["val"].values

	# Plot the image!
	new_img = (ggplot(aes(x="x", y="-y", color="is_on"), data=df) 
		+ geom_jitter(width=1.5*cell_width, height=1.5*cell_height, size=0.3) 
		+ scale_color_manual(values=["black", "white"], guide=None)
		+ theme_void() 
		+ coord_fixed(ratio=img_height / img_width) 
		+ theme(panel_background = element_rect(
				fill = background_color, 
				colour = background_color))
	)
	return new_img
In [1]: import os

In [2]: import matplotlib.image

In [3]: import matplotlib.image as mpimg

In [4]: import numpy as np

In [5]: import numpy.random

In [6]: import pylab as pl

In [7]: import scipy.spatial as spatial
from scipy.spatial import dle
In [8]: from scipy.spatial import Delaunay

In [9]:

In [9]: dimg = mpimg.imread("../primitive/hawaii_night.jpg")

# Computed to get to 10k points...
cell_height = 30
cell_width = 30
img_height, img_width, _ = dimg.shape
data = []
for y in range(0, img_height, cell_height):
	for x in range(0, img_width, cell_width):
		# print(dimg[y:y+cell_height, x:x+cell_height, :])
		cell_color = dimg[y:y+cell_height, x:x+cell_height, :].mean(axis=(0,1)) / 255
		# print(cell_color)
		# print()
		data.append({
			"x": x,
			"y": y,
			"r": cell_color[0],
			"g": cell_color[1],
			"b": cell_color[2],
			"rgb": matplotlib.colors.to_hex(cell_color),
		})
df = pd.DataFrame(data)

from plotnine import *

ggplot(aes(x="x", y="y", color=))
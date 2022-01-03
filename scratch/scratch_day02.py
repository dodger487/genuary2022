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

N = 1000

def rgb2gray(rgb):
	return np.dot(rgb[...,:3], [0.2989, 0.5870, 0.1140])


dimg = mpimg.imread("inputs/hawaii_night.jpg")
dimg = mpimg.imread("inputs/happy_doggy_grayscale.jpeg")
dimg = mpimg.imread("inputs/gg_bridge1.png")
dimg = mpimg.imread("inputs/gg_bridge2.png")

bw = rgb2gray(dimg)

pl.imshow(bw, cmap="gray")


# Random
dithered_random = (bw > np.random.rand(*bw.shape) * bw.max()).astype(int)
pl.imshow(dithered_random, cmap="gray")  # vmin=0, vmax=255)
pl.show()

points = [
	[0,0],
	[4,0],
	[5,5],
]

# https://stackoverflow.com/questions/8957028/getting-a-list-of-locations-within-a-triangle-in-the-form-of-x-y-positions
def get_coefs(pt1, pt2):
	return [
		pt2[1] - pt1[1], 
		pt1[0] - pt2[0],
		pt2[0] * pt1[1] - pt1[0] * pt2[1],
	]

# https://stackoverflow.com/questions/2049582/how-to-determine-if-a-point-is-in-a-2d-triangle
# User xApple and phuclv
def point_in_triangle(all_points, triangle):
    """Returns True if the point is inside the triangle
    and returns False if it falls outside.
    - The argument *point* is a tuple with two elements
    containing the X,Y coordinates respectively.
    - The argument *triangle* is a tuple with three elements each
    element consisting of a tuple of X,Y coordinates.

    It works like this:
    Walk clockwise or counterclockwise around the triangle
    and project the point onto the segment we are crossing
    by using the dot product.
    Finally, check that the vector created is on the same side
    for each of the triangle's segments.
    """
    # Unpack arguments
    # x, y = point
    x, y = all_points[:, 0], all_points[:, 1]
    ax, ay = triangle[0]
    bx, by = triangle[1]
    cx, cy = triangle[2]
    # Segment A to B
    side_1 = (x - bx) * (ay - by) - (ax - bx) * (y - by)
    # Segment B to C
    side_2 = (x - cx) * (by - cy) - (bx - cx) * (y - cy)
    # Segment C to A
    side_3 = (x - ax) * (cy - ay) - (cx - ax) * (y - ay)
    # All the signs must be positive or all negative
    return all_points[~((side_1 < 0.0) == (side_2 < 0.0)) == (side_3 < 0.0)]


# https://stackoverflow.com/questions/11144513/cartesian-product-of-x-and-y-array-points-into-single-array-of-2d-points
def cartesian_product(*arrays):
    la = len(arrays)
    dtype = numpy.result_type(*arrays)
    arr = numpy.empty([len(a) for a in arrays] + [la], dtype=dtype)
    for i, a in enumerate(numpy.ix_(*arrays)):
        arr[...,i] = a
    return arr.reshape(-1, la)


def simplex_to_pixels(tri, simplex_id):
	triangle = tri.points[tri.simplices[simplex_id]]
	lo_bounds = triangle.min(axis=0).astype(int)
	hi_bounds = triangle.max(axis=0).astype(int)
	possible_coords = np.array(
		[[i,j] for i in range(lo_bounds[0], hi_bounds[0]+1) 
			   for j in range(lo_bounds[1], hi_bounds[1]+1)])
	return point_in_triangle(possible_coords, triangle)

	# points = np.sort(points, axis=0)

	# coefs = [
	# 	get_coefs(points[0], points[1]),
	# 	get_coefs(points[1], points[2]),
	# 	get_coefs(points[0], points[2]),
	# ]

	# x_bounds = [0, 5]
	# y_bounds = [0, 5]
	# for x in range(x_bounds[0], x_bounds[1]+1):
	# 	y_top = -coefs[0][0] * x - coefs[0][2]
	# 	y_bot = -coefs[1][0] * 

def get_edge_points(img, N, sigma=5):
	edges = feature.canny(img, sigma=sigma)
	h, w = np.where(edges)
	idx = np.random.randint(0, len(h), N)
	return np.array([h[idx], w[idx]]).T

N = 100


dimg = mpimg.imread("inputs/hawaii_night.jpg")
dimg = mpimg.imread("inputs/happy_doggy_grayscale.jpeg")
dimg = mpimg.imread("inputs/gg_bridge1.png")
dimg = mpimg.imread("inputs/gg_bridge2.png")

bw = rgb2gray(dimg)


def read_and_draw(fname, N, sigma=5):
	dimg = mpimg.imread(fname)
	dimg = rgb2gray(dimg)
	draw_img(dimg, N, sigma)


def draw_img(dimg, N, sigma=5):
	height, width = dimg.shape[:2]

	# coords = np.random.rand(N, 2) * [height, width]
	rand_coords = np.random.rand(np.ceil(N/10).astype(int), 2) * [height * 1.2, width * 1.2]
	# coords = np.floor(coords)
	rand_coords = np.floor(rand_coords) - [height * 0.1, width * 0.1]

	# tri = Delaunay(coords)
	print("running canny...")
	coords = get_edge_points(dimg, np.floor(9*N/10).astype(int), sigma)
	# coords = np.array([[0,0]])

	# side_points = 50
	# edge_points = np.concatenate([[np.zeros(side_points)], [(np.random.rand(side_points) * width).astype(int)]]).T
	# edge_points2 = np.concatenate([[np.ones(side_points) * width-1], [(np.random.rand(side_points) * width).astype(int)]]).T
	# top_points = np.concatenate([[(np.random.rand(side_points) * width).astype(int)], [np.zeros(side_points)]]).T
	# coords = np.concatenate([coords, edge_points, edge_points2, top_points])
	# tri = Delaunay(get_edge_points(dimg, N, sigma))
	
	tri = Delaunay(np.concatenate([rand_coords, coords]))
	num_triangles = len(tri.simplices)

	# all_coords = [(y, x) for y in range(height) for x in range(width)]
	# tri_mask = tri.find_simplex(all_coords)
	# tri_mask = tri_mask.reshape(height, width)

	print(num_triangles)
	dimg_new = dimg.copy()
	for i in range(num_triangles):
		# Filter out pixels not visible
		pixel_coords = simplex_to_pixels(tri, i)
		pixel_coords = pixel_coords[(0 < pixel_coords[:, 0]) & (pixel_coords[:, 0] < height)]
		pixel_coords = pixel_coords[(0 < pixel_coords[:, 1]) & (pixel_coords[:, 1] < width)]
		mean_val = dimg[pixel_coords[:, 0], pixel_coords[:, 1]].mean()
		# mean_val = dimg[tri_mask == i, :].mean(axis=0)
		# dimg_new[pixel_coords[:, 0], pixel_coords[:, 1]] = mean_val
		new_pts = (np.random.rand(len(pixel_coords)) * dimg.max() < mean_val).astype(int)
		dimg_new[pixel_coords[:, 0], pixel_coords[:, 1]] = new_pts
		if i % 1 == 0: 
			print(i, mean_val, (np.random.rand() * dimg.max()), mean_val)
		# dimg_new[pixel_coords[:, 0], pixel_coords[:, 1]] = (np.random.rand() * dimg.max()) < mean_val
		# dimg_new[pixel_coords[:, 0], pixel_coords[:, 1]] = mean_val

	pl.figure()
	pl.imshow(dimg, cmap="gray")
	pl.figure()
	pl.imshow(dimg_new, cmap="gray", vmin=0, vmax=1)
	pl.show()



# pointalism
hawaii_points = dither_with_points("inputs/hawaii_night.jpg", 100000)
hawaii_points.save(
	"outputs/day02_points_hawaii_black.jpg", 
	height=img_height / img_width * 4, 
	width=4, 
	units="in"
)

hawaii_points_white = dither_with_points("inputs/hawaii_night.jpg", 100000, "white")
hawaii_points_white.save(
	"outputs/day02_points_hawaii_white.jpg", 
	height=img_height / img_width * 4, 
	width=4, 
	units="in"
)

doggy = dither_with_points("inputs/happy_doggy_grayscale.jpeg", 50000, "white")
doggy.save(
	"outputs/happy_doggy_grayscale.jpg", 
)

dither_with_points("inputs/gg_bridge1.png", 50000, "white")
dither_with_points("inputs/gg_bridge2.png")

def dither_with_points(fname, num_points, background_color="black"):
	dimg = mpimg.imread(fname)  # Read the image
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

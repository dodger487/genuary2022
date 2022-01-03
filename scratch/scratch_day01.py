from scipy.spatial import Delaunay
import igraph

tri = Delaunay(df[["x", "y"]].values)

G = igraph.Graph()

indptr, indices = tri.vertex_neighbor_vertices
edges = []
for i in range(len(indptr)):
	if i < len(indptr) - 1:
		edges.extend([(i, n) for n in indices[indptr[i]:indptr[i+1]]])
	else:
		edges.extend([(i, n) for n in indices[indptr[i]:]])

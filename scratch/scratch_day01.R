library(tidyverse)


height <- 2
width <- 7
n_rectangles <- 1000

canvas_size <- 100

xlims <- c(0, canvas_size)
ylims <- c(0, canvas_size)

data <- tibble(x = 50, y = 50)

base <- 
  tibble(
    x = runif(n_rectangles) * canvas_size,
    y = runif(n_rectangles) * canvas_size
  ) %>% 
  mutate(
    id = row_number(),
    color = sample(c(1,2,3), n(), replace = TRUE)
  )
  

data2 <- tibble(
  # generate uniform grid of points
  # x = seq(xlims[1], xlims[2], length.out = n_rectangles),
  # y = seq(ylims[1], ylims[2], length.out = n_rectangles),
  x = runif(n_rectangles) * 100,
  y = runif(n_rectangles) * 100
) %>%
  mutate(
    # jitter the points a little
    x = x + rnorm(n(), sd = 0.01),
    y = y + rnorm(n(), sd = 0.01)
    # test whether each point is inside the polygon or not
    # interior = (sp::point.in.polygon(x, y, poly_x, poly_y) == 1)
  ) 

ggplot(aes(x = x, y = y), data = base) + 
  geom_tile(height = height, width = width, alpha = 0.5, 
            color = 'blue', fill = 'blue') +
  xlim(xlims) +
  ylim(ylims) +
  theme_void() +
  NULL



data3 <- base %>%
  mutate(
    xend = x + 7,
    yend = y + 5
  )

ggplot(aes(x = x, y = y, xend = xend, yend = yend), data = data3) +
  geom_segment(size=4, alpha=0.5) +
  xlim(xlims) +
  ylim(ylims) +
  theme_void()

data4 <- base %>%
  mutate(
    ymin = y - 2,
    ymax = y + 2,
    id = row_number(),
    c = sample(custom_colors, n(), replace = TRUE),
    is_up = sample(c(FALSE, TRUE), n(), replace = TRUE)
  )
data4_help <- data4 %>%
  mutate(
    x = x + width,
    ymin = if_else(is_up, ymin + height, ymin - height),
    ymax = if_else(is_up, ymax + height, ymax - height)
  )
data4 <- rbind(data4, data4_help)
data4 <- data4 %>% arrange(id)
data4 %>% head

data4 %>%
  ggplot(aes(x = x, ymin = ymin, ymax = ymax, 
           group = id, fill=c)) +
  geom_ribbon(alpha=1) +
  xlim(xlims) +
  ylim(ylims) +
  scale_fill_identity(guide = "none") +
  theme_void()

data4 %>%
  mutate(sat_level = if_else(runif(n()) > 0.5, 0.1, 0.9),
         c = ifelse(runif(n()) > 0.5, saturation(c, 0.1), c)) %>%
  ggplot(aes(x = x, ymin = ymin, ymax = ymax, 
             group = id, fill=c)) +
  geom_ribbon() +
  xlim(xlims) +
  ylim(ylims) +
  scale_fill_identity(guide = "none") +
  # scale_fill_manual(values = saturation(custom_colors, is_sat),  guide = "none") +
  # scale_alpha(guide = "none") +
  theme_void()

custom_colors <- c('#6cbbd4', '#5863b1', '#5282a1', '#1dd3b0', '#c1f29b');
custom_colors <- c('#deFbE4', '#eafc70', '#14777F', '#086375', '#5EB8A5')
# color[] palette1 = {#6cbbd4, #5863b1, #5282a1, #1dd3b0, #c1f29b}
# color[] palette2 = {#deFbE4, #eafc70, #14777F, #086375, #5EB8A5};




df <- tibble(x = 1:3, y = 3:1)
df
df %>% add_row(x = x + 10)
# function, make polygon

lo_left <- base %>%
  mutate(
    id = row_number(),
    c = sample(custom_colors, n(), replace = TRUE)
  )
up_left <- lo_left %>%
  mutate(y = y + height / 2)
up_right <- up_left %>%
  mutate(x = x + width, y = y + height / 2)
lo_right <- up_right %>%
  mutate(y = y - height / 2)
# lo_right <- up_right %>%
#   mutate(y = y - height / 2)
data5 <- rbind(lo_left, up_left, up_right, lo_right) %>% arrange(id)
data5 %>% head
data5 %>% nrow

data5 %>% 
  # head(8) %>%
  ggplot(aes(x=x, y=y, fill=c, group=id)) +
  geom_polygon() +
  xlim(xlims) +
  ylim(ylims) +
  scale_fill_manual(values = custom_colors, guide = "none") +
  theme_void() +
  coord_fixed()
  NULL

make_rect <- function(x, y) {
  tibble(
    x = c(x, x, x + width, x + width, x),
    y = c(y, y + height / 2, y + height, y + height / 2, y)     
  )
}

make_rect2 <- function(x, y, height, width) {
  tibble(
    x = c(x, x, x + width, x + width, x),
    y = c(y, y + height / 2, y + height, y + height / 2, y)     
  )
}

data6 <- base %>%
  # head(4) %>%
  mutate(
    id = row_number(),
    c = sample(custom_colors, n(), replace = TRUE)
  ) %>%
  rowwise() %>%
  summarize(make_rect2(x, y, 2, 10), id = id, c = c)

data6 %>%
  ggplot(aes(x=x, y=y, fill=c, group=id)) +
  geom_polygon() +
  xlim(xlims) +
  ylim(ylims) +
  scale_fill_manual(values = custom_colors, guide = "none") +
  theme_void() +
  coord_fixed() +
  NULL



custom_colors <- c('#779CE6', '#E69C8E', '#BAE660', '#405E99', '#7F9948')

custom_colors <- c(
  '#E6ACDD',
  '#E6CF81',
  '#639699',
  '#999482',
  '#A1E1E6'
)


custom_colors <- c(
  '#365953', # green
  '#262626', # black
  '#BF8EAE', # pink
  '#AAB7BF', # gray
  '#F0F2F2' # white
)


custom_colors <- c(
  '#F0F0F2',
  '#699EBF',
  '#8C793F',
  '#404040',
  '#91BDD9' 
)

# I kinda liked 5000 and 3 better
n_rectangles <- 10000
rect_scale_factor <- 1.5
base2 <-
  tibble(
    x = runif(n_rectangles) * (canvas_size + 20) - 10,
    y = runif(n_rectangles) * (canvas_size + 20) - 10
  ) %>% 
  mutate(
    id = row_number(),
    # base_color = sample(custom_colors, n(), replace = TRUE),
    base_color = '#00ff00',
    # layer = sample(c(1,2,3,4,5), n(), replace = TRUE)
    # layer = runif(n_rectangles) * 8 + 1
    # layer = rexp(n_rectangles),
    # layer = rgeom(n(), 0.55),
    layer = rlnorm(n(), sd = .7),
    max_layer = max(layer)
  ) %>%
  rowwise() %>%
  summarize(make_rect2(x, y, layer*rect_scale_factor, layer*rect_scale_factor), 
            id = id, base_color = base_color, layer=layer, max_layer = max_layer) %>%
  ungroup()
base2 <-
  base2 %>%
  rowwise %>%
  # mutate(color = saturation(base_color, scalefac(0.7^(sqrt(max_layer-layer))))) %>%
  # mutate(color = saturation(base_color, scalefac(0.9^((max_layer-layer)^1.3)))) %>%
  # mutate(color = saturation(base_color, scalefac(0.9^((10-layer)^2)))) %>%
  # mutate(color = lightness(color, delta((layer-1)*10))) %>%
  mutate(color = lightness(base_color, scalefac(0.94^((max_layer-layer)^1.1)))) %>%
  ungroup()
base2 %>% head

base2 %>%
  ggplot(aes(x=x, y=y, fill=color, group=layer*10*n_rectangles + id)) +
  # ggplot(aes(x=x, y=y, fill=color, group=id)) +
  geom_polygon(color="black") +
  # geom_polygon() +
  # coord_cartesian(xlim = xlims, ylim = ylims) +
  # xlim(xlims) +
  # ylim(ylims) +
  scale_fill_identity() +
  # scale_fill_manual(values = custom_colors, guide = "none") +
  # scale_fill_manual(values = custom_colors, guide = "none") +
  theme_void() +
  coord_fixed(xlim = xlims, ylim = ylims) +
  theme(panel.background = element_rect(fill = 'black', colour = 'black')) +
  NULL





base2 %>%
  ggplot(aes(x=x, y=y, fill=base_color, group=layer*10*n_rectangles + id)) +
  geom_polygon(color="black") +
  scale_fill_identity() +
  theme_void() +
  coord_fixed(xlim = xlims, ylim = ylims) +
  theme(panel.background = element_rect(fill = 'black', colour = 'black')) +
  NULL


  
# Blog post?
# X ways of plotting quadralaterals
"
Suppose you have data in an #R tibble, and you want to add rows to it in a tidyverse way based on your existing rows.
Below are three methods...
Motivation: I have 100 points, and I want to generate 100 rectangles from this points and plot them with geom_polygon.

1: Create more dataframes and rbind.
"
# Prelim: generate data
library(tidyverse)
base <- 
  tibble(
    x = runif(100) * 100,
    y = runif(100) * 100
  ) %>% 
  mutate(
    id = row_number()
  )
height <- 2
width <- 7

lo_left <- base 
up_left <- lo_left %>% mutate(y = y + height)
up_right <- up_left %>% mutate(x = x + width, y = y)
lo_right <- up_right %>% mutate(y = y - height)

df <- rbind(lo_left, up_left, up_right, lo_right) %>% arrange(id)

ggplot(aes(x = x, y = y, group=id), data=df) +
  geom_polygon(alpha=0.7) + theme_void()

"
2: Mutate and pivot_longer
"
df <- base %>%
  mutate(
    x_ll = x, y_ll = y,                  # ll = lower left
    x_ul = x, y_ul = y + height,         # ul = upper left
    x_ur = x + width, y_ur = y + height, # ur = upper right
    x_lr = x + width, y_lr = y           # lr = lower right
  ) %>%
  pivot_longer(x_ll:y_lr) %>%
  select(id, name, value) %>%
  separate(name, into = c("name", "position")) %>%
  pivot_wider(id_cols = c(id, position)) %>%
  select(-position)

ggplot(aes(x = x, y = y, group=id), data=df) +
  geom_polygon(alpha=0.7) + theme_void()

"
3: Use summarize + a function that returns a tibble! Thanks @drob for showing me this.
"
make_rect <- function(x, y, height, width) {
  tibble(
    x = c(x, x, x + width, x + width, x),
    y = c(y, y + height, y + height, y, y)     
  )
}

df <- base %>%
  rowwise() %>%
  summarize(make_rect(x, y, height, width), id = id) %>%
  ungroup()

ggplot(aes(x = x, y = y, group=id), data=df) +
  geom_polygon(alpha=0.7) + theme_void()

"
Which method is best? Probably a matter 
"


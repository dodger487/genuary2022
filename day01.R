# Genuary 2022

# Jan.1:  Draw 10,000 of something

library(tidyverse)
library(shades)

n_rectangles <- 10000
rect_scale_factor <- 1.5
canvas_size <- 100
xlims <- c(0, canvas_size)
ylims <- c(0, canvas_size)
height <- 2
width <- 7


make_rect <- function(x, y, height, width) {
  tibble(
    x = c(x, x, x + width, x + width, x),
    y = c(y, y + height / 2, y + height, y + height / 2, y)     
  )
}

tibble(
  x = runif(n_rectangles) * (canvas_size + 20) - 10,
  y = runif(n_rectangles) * (canvas_size + 20) - 10
) %>% 
  mutate(
    id = row_number(),
    base_color = '#00ff00',
    layer = rlnorm(n(), sd = .7),
    max_layer = max(layer)
  ) %>%
  rowwise() %>%
  summarize(make_rect(x, y, layer*rect_scale_factor, layer*rect_scale_factor), 
            id = id, base_color = base_color, layer=layer, max_layer = max_layer) %>%
  rowwise() %>%
  mutate(color = lightness(base_color, scalefac(0.94^((max_layer-layer)^1.1)))) %>%
  ungroup() %>%
  ggplot(aes(x=x, y=y, fill=color, group=layer*10*n_rectangles + id)) +
  geom_polygon(color="black") +
  scale_fill_identity() +
  theme_void() +
  coord_fixed(xlim = xlims, ylim = ylims) +
  theme(panel.background = element_rect(fill = 'black', colour = 'black')) +
  NULL
ggsave("outputs/day01_green_rectangles.png", height = 4, width = 4, units = "in")

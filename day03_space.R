# Genuary 2022

# Jan.3: Space

library(tidyverse)
library(ggnewscale)
library(shades)
library(ghibli)


generate_world <- function(canvas_size, color_palette) {
  num_stars <- 50
  
  sky_color <- color_palette[[1]]
  ground_color <- color_palette[[2]]
  sun_color <- color_palette[[3]]
  struct_color <- color_palette[[4]]
  star_color <- color_palette[[5]]
  
  sky_df <- tibble(ymin = (canvas_size / 4):(canvas_size-1)) %>%
    mutate(
      ymax = ymin+1,
      xmin = 0,
      xmax = canvas_size
    )
  sky_df %>% head
  land_df <- tibble(ymin = 0:(canvas_size/4 - 1)) %>%
    mutate(
      ymax = ymin+1,
      xmin = 0,
      xmax = canvas_size
    )
  star_df <- tibble(
    x = runif(num_stars) * canvas_size,
    y = canvas_size - abs(rnorm(num_stars, sd = canvas_size / 10))
  )
  sun_df <- tibble(y = canvas_size / 4 + rnorm(1, mean = 5), x = runif(1) * canvas_size)
  
  num_structs <- 10
  structure_df <- tibble(y = rep(canvas_size / 4, num_structs)) %>%
    mutate(
      yend = y,
      layer = runif(n()),
      x = runif(n()) * canvas_size,
      xend = pmin(x + canvas_size / 20, canvas_size),
      height = rnorm(n(), mean=30, sd=5)
    )
  
  ggplot() +
    
    # Plot the sky
    geom_rect(aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill = ymin), data=sky_df) +
    scale_fill_gradient(low=sky_color, high="black", guide = "none") +
    new_scale_fill() +
    
    # Plot the stars
    geom_point(aes(x=x, y=y, color=y), size = 0.5, data=star_df) +
    scale_color_gradient(low=brightness(star_color, scalefac(0.5)), high=star_color, guide="none") +
    new_scale_color() +
    
    # Plot the sun
    geom_point(aes(x=x, y=y), color=sun_color, size = 30, data=sun_df) +
    
    # Plot 
    geom_segment(aes(x=x, xend=xend, y=y, yend=yend, size=I(height), color=layer), data=structure_df) +
    scale_color_gradient(low=struct_color, high=brightness(struct_color, scalefac(0.75)), guide="none") +
    new_scale_fill() +
    
    # Plot the ground
    geom_rect(aes(xmin=xmin, xmax=xmax, ymin=ymin, ymax=ymax, fill = ymin), data=land_df) +
    scale_fill_gradient(low="black", high=ground_color, guide = "none") +
    coord_fixed(xlim = c(0, canvas_size), ylim = c(0, canvas_size), expand=F) +
    theme_void()
}

generate_world(100, brewer.pal(n = 5, name = "Dark2"))

# Several palettes from https://cran.r-project.org/web/packages/ghibli/index.html
generate_world(100, sample(ghibli::ghibli_palette("TotoroMedium")))
ggsave("outputs/day03_space_totoro1.png", height = 4, width = 4, units = "in")
generate_world(100, sample(ghibli::ghibli_palette("MononokeLight")))
ggsave("outputs/day03_space_mononoke.png", height = 4, width = 4, units = "in")
generate_world(100, sample(ghibli::ghibli_palette("PonyoLight")))
ggsave("outputs/day03_space_ponyo.png", height = 4, width = 4, units = "in")
generate_world(100, sample(ghibli::ghibli_palette("MarnieMedium1")))
ggsave("outputs/day03_space_marnie3.png", height = 4, width = 4, units = "in")
generate_world(100, sample(ghibli::ghibli_palette("SpiritedLight")))
ggsave("outputs/day03_space_spirited.png", height = 4, width = 4, units = "in")

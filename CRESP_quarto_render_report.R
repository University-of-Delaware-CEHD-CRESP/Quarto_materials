
### Render the reports with purrr:: ###


library(tidyverse)
library(here)
#remotes::install_github("jhelvy/jph")
library(jph)

# enrollment <- RSocrata::read.socrata("https://data.delaware.gov//api//odata//v4//6i7v-xnmf")
# districts <- enrollment |> filter(districtcode != 0) |> select(district) |> distinct()
# districts$year <- 2023

district <- c("Cape Henlopen School District", "Brandywine School District", "Appoquinimink School District")
year <- 2023
districts <- data.frame(district, year)
jph::
reports <- districts |>
  dplyr::mutate(
    output_file = paste0(
      `district`, "_", gsub(" ", "", year), "_Report.html"
    ),
    execute_params = purrr::map2(
      district, year,
      \(x, y) list(district = x, year = y)
    )
  ) |>
  dplyr::select(output_file, execute_params)


reports|>
  purrr::pwalk(
    jph::quarto_render_move,
    input = here("Code/CRESP_quarto_example.qmd"),
    output_format = "html",
    output_dir = here("Code")
  )

?quarto_render_move

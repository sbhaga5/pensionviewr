save_plot <- function(plot_grid, width, height, save_filepath) {
  grid::grid.draw(plot_grid)
  #save it
  ggplot2::ggsave(filename = save_filepath,
    plot = plot_grid, width = (width/72), height = (height/72),  bg = "white")
}

create_footer <- function(source) {
  #Make the footer
  footer <- grid::grobTree(grid::textGrob(source,
      x = 0.004, hjust = 0, gp = grid::gpar(fontsize = 9)))
  return(footer)

}

#' Add a source and save ggplot chart
#'
#' Running this function will save your plot with the correct guidelines for publication.
#' It will left align your source and save it to your specified location.
#' @param plot The variable name of the plot you have created that you want to format and save
#' @param source The text you want to come after the text 'Source:' in the bottom left hand side of your side
#' @param save_filepath Exact filepath that you want the plot to be saved to
#' @param width_pixels Width in pixels that you want to save your chart to - defaults to 648
#' @param height_pixels Height in pixels that you want to save your chart to - defaults to 384.48
#'  which needs to be a PNG file - defaults to BBC blocks image that sits within the data folder of your package
#' @return (Invisibly) an updated ggplot object.
#' @examples
#' \dontrun{
#' savePlot(plot = myplot,
#' source = "The source for my data",
#' save_filepath = "filename_that_my_plot_should_be_saved_to.png",
#' width_pixels = 648,
#' height_pixels = 384.48)
#' }
#'
#' @export

savePlot <- function(plot,
  source,
  save_filepath=file.path(Sys.getenv("TMPDIR"), "tmp-nc.png"),
  width_pixels=648,
  height_pixels=384.48) {

  footer <- create_footer(source)

  plot_grid <- ggpubr::ggarrange(plot, footer,
    ncol = 1, nrow = 2,
    heights = c(1, 0.045/(height_pixels/450)))
  save_plot(plot_grid, width_pixels, height_pixels, save_filepath)
  invisible(plot_grid)
}

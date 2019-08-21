#' @name celebrate
#' @title Say nice things
#' @description Celebrate the passing of module tests.
#' @return NULL
#' @family praise
celebrate <- function() {
  template <- paste0("${Exclamation}!", " The module works!",
                     " You are ${adjective}!")
  mssg <- praise::praise(template = template)
  cat_line(crayon::green(mssg))
}

#' @name comfort
#' @title Say consoling things
#' @description Commiserate the failing of module tests.
#' @return NULL
#' @family praise
comfort <- function() {
  phrases <- c('Ah shucks....', 'Damn damn damn.', 'Sodding socks.',
               'Well drop the goat. This is not great.',
               'Grrrr.....', 'A truly unfavourable circumstance:',
               'I am sorry. I feel bad.')
  template <- "But keep on ${creating}! You're doing ${adverb_manner}!"
  mssg <- paste0(sample(phrases, 1), " The module is not working....\n",
                 praise::praise(template = template))
  cat_line(crayon::blue(mssg))
}

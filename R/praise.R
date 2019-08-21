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
               'I am sorry. I feel bad.', 'Oh boy, oh boy, oh boy.',
               'Oh deary me....', 'Fiddle sticks.', 'Flipping goats.',
               'Darn it.', 'Ugh.', 'Tsk. Nasty eels.', 'Crickey mickey!',
               'Oh... that plucky, podgy polecat!', 'Those angry alligators!',
               'Oh... this confounded, contraption.', ':-(',
               'The gloating goat got away!', 'No sugar lumps for the horse.',
               'Ai, ai aye-aye....', 'Quelle absurdité!',
               'Well, it\'s no fluffy alpacca.',
               'This aint\' easy. No one is blaming you.',
               'Ohhh... no. No. No. No.', 'Mais non! Main non!',
               'Who dropped the fudge cake with sprinkles!',
               'Agouti agloopy!',
               'What the? These elephant stockings are too big.',
               'The guinea pig was lost!', 'Catting, cat cat catish cat. CAT!')
  template <- "But keep on ${creating}! You're doing ${adverb_manner}!"
  mssg <- paste0(sample(phrases, 1), " The module is not working....\n",
                 praise::praise(template = template))
  cat_line(crayon::blue(mssg))
}

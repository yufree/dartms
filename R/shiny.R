#' Shiny application for Short-Chain Chlorinated Paraffins analysis
#' @export
rundartr <- function() {
    file <- system.file("dartr",
                        package = "dartms")
    if (file == "") {
        stop("Could not find directory. Try re-installing `dartms`.",
             call. = FALSE)
    }
    shiny::runApp(file)
}
# Ensure user package library is available
# To install user packages run install.packages("path", repo = NULL)
system_libs <- .libPaths()
user_lib <- file.path("//micro.intra", "mydocs", "mydocs", "altada", "My Documents", "R", "win-library", "4.0")
.libPaths(c(user_lib, system_libs))

####################
# HELPER FUNCTIONS #
####################

# Map Raw and Working Directory to Network Drives
map_network_drive <- function(drive, path) {
    message("map_network_drive(): ", drive, " -> ", path, "\n")
    map_cmd <- paste("NET USE", drive, gsub("/", "\\\\", path))
    del_cmd <- paste("NET USE", drive, "/DELETE /Y")
    run_cmd <- function(cmd) {
        suppressWarnings(system(cmd, show.output.on.console = FALSE,
                                intern = TRUE, wait = TRUE))
    }
    sys1 <- run_cmd(map_cmd)
    if (is.null(attr(sys1, "status"))) {
        return()
    } else if (attr(sys1, "status") == 2) {
        sys2 <- run_cmd(del_cmd)
        if (is.null(attr(sys2, "status"))) {
            sys3 <- run_cmd(map_cmd)
            if (!is.null(attr(sys3, "status"))) stop("Error creating mapped network drive.")
        } else stop("Error deleting mapped network drive.")
    } else stop("Unknown error mapping drive.")
}

##############
# RUN SCRIPT #
##############

# Two folders: R: for raw data and W: for working dir
# Mona batch automatically sets working dir to batch file folder at startup.
DATA_PATH <- file.path("//micro.intra", "projekt", "P0863$", "P0863_Gem", "education-choice-data-processing")
options(DATA_PATH = DATA_PATH)
map_network_drive("R:", DATA_PATH)
map_network_drive("W:", getwd())

# Build project
targets::tar_make()

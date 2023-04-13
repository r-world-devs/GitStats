TestHost <- R6::R6Class("TestHost",
                        inherit = GitPlatform,
                        public = list(
                          rest_engine = NULL,
                          orgs = NULL,
                          initialize  = function(rest_api_url = NA,
                                                 token = NA,
                                                 orgs = NA){
                            self$rest_engine <- EngineRest$new(
                              rest_api_url = rest_api_url,
                              token = token
                            )
                            self$orgs <- orgs
                          }
                        ))

#' @description
#' @param
#' @return
create_testhost <- function(rest_api_url = NULL,
                            token = NULL,
                            orgs = NULL,
                            mode = '') {

  test_host <- TestHost$new(rest_api_url = rest_api_url,
                            token = token,
                            orgs = orgs)
  if (grepl("github", rest_api_url)) {
    class(test_host) <- "GitHub"
  } else if (grepl("gitlab", rest_api_url)) {
    class(test_host) <- "GitLab"
  }
  if (mode == "private") {
    test_host <- environment(test_host$initialize)$private
  }
  return(test_host)
}

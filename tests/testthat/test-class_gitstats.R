testGitStats <- GitStats$new()

test_that("Set connection method", {

  expect_message(testGitStats$set_connection(api_url = "https://api.github.com",
                                             token = Sys.getenv("GITHUB_PAT"),
                                             owners_groups = c("avengers", "cocktail_party")),
                 "Set connection to GitHub.")

  expect_message(testGitStats$set_connection(api_url = "https://github.company.com",
                                             token = Sys.getenv("GITHUB_COMPANY_PAT"),
                                             owners_groups = "owner_1"),
                 "Set connection to GitHub Enterprise.")


  expect_message(testGitStats$set_connection(api_url = "https://code.pharma.com",
                                             token = Sys.getenv("GITLAB_PAT"),
                                             owners_groups = c("good_drugs", "vaccine_science")),
                 "Set connection to GitLab.")
})

test_that("Errors pop out, when wrong input is passed in set_connection method", {

  testGitStats$clients <- list()

  expect_error(testGitStats$set_connection(api_url = "https://avengers.com",
                                           token = Sys.getenv("GITLAB_PAT")),
               "You need to specify owner/owners of the repositories.")

  expect_error(testGitStats$set_connection(api_url = "https://avengers.com",
                                           token = Sys.getenv("GITLAB_PAT"),
                                           owners_groups = c("good_drugs", "vaccine_science")),
                 "This connection is not supported by GitStats class object.")


})

test_that("Error pops out, when two clients of the same url api are passed as input", {

  testGitStats$clients <- list()

  cons <- list(api_url = c("https://api.github.com", "https://api.github.com"),
               token = c(Sys.getenv("GITHUB_PAT"),Sys.getenv("GITHUB_PAT")),
               owners_groups = list(c("justice_league"), c("avengers")))


  expect_error(
    purrr::pwalk(cons, function(api_url, token, owners_groups){
      testGitStats$set_connection(api_url = api_url,
                                token = token,
                                owners_groups = owners_groups)
      }),
    "You can not provide two clients of the same API urls."

  )

})

test_that("Proper information pops out when one wants to get team stats without specifying team", {

  expect_error(testGitStats$get_repos_by_team(),
               "You have to specify a team first")

})

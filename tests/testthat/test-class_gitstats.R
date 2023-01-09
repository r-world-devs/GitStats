git_hub_client_1 = GitHubClient$new(rest_api_url = "https://api.github.com")

test_that("Error pops out on wrong input passed to new GitStats object", {

  wrong_objects <- list("sth", something = mean(12, 15), url = "https://api.github.com")

  purrr::walk(wrong_objects, function(x){
    expect_error(GitStats$new(x),
                 "Wrong objects passed into GitStats constructor. GitStats may comprise only of GitClient class objects.",
                 ignore.case = TRUE)
  })

  proper_objects <- list(git_hub_client = git_hub_client_1,
                         git_lab_client = GitLabClient$new(rest_api_url = "https://gitlab.api.com"))

  purrr::walk(proper_objects, function(x){
    expect_no_error(GitStats$new(x))
  })

})

test_that("Error pops out when two clients of the same url api are passed as input", {

  git_hub_client_2 = GitLabClient$new(rest_api_url = "https://api.github.com")

  expect_error(GitStats$new(git_hub_client_1, git_hub_client_2),
               "You can not provide two clients of same API urls.")

  git_hub_client_2 = GitLabClient$new(rest_api_url = "https://github.mycompany.com/api")

  expect_no_error(GitStats$new(git_hub_client_1, git_hub_client_2))

})

MyGitStats <- GitStats$new(git_hub_client_1)

test_that("Proper information pops out when one wants to get team stats without specifying team", {

  expect_error(MyGitStats$get_repos_by_team(),
               "You have to specify a team firstly")

})

test_that("Error pops out when groups/owners are not defined", {

  expect_error(MyGitStats$get_repos_by_owner_or_group(),
               "You have to define")
})

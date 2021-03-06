test_that("fix_dates works for a series of malformed dates", {
bad.dates <- data.frame(id = seq(6),
                        some.dates = c("02/05/92",
                                       "01-04-2020",
                                       "1996/05/01",
                                       "2020-05-01",
                                       "02-04-96",
                                       "2015"),
                        some.more.dates = c(
                                       "02/05/00",
                                       "05/1990",
                                       "2012-08",
                                       "apr-21",
                                       "mar-65",
                                       "feb 84"))

fixed.df <- fix_dates(bad.dates, c("some.dates", "some.more.dates"))

expected.df <- data.frame(id = seq(6),
                          some.dates = c("1992-05-02",
                                         "2020-04-01",
                                         "1996-05-01",
                                         "2020-05-01",
                                         "1996-04-02",
                                         "2015-01-01"),
                          some.more.dates = c(
                                         "2000-05-02",
                                         "1990-05-01",
                                         "2012-08-01",
                                         "2021-04-01",
                                         "1965-03-01",
                                         "1984-02-01"))
expected.df$some.dates <- as.Date(expected.df$some.dates)
expected.df$some.more.dates <- as.Date(expected.df$some.more.dates)
expect_equal(fixed.df, expected.df)
})

test_that("returns error for dates that are malformed beyond auto fix", {
  bad.dates <- data.frame(id = seq(9),
                          some.dates = c("02/05/92",
                                         "01-04-2020",
                                         "1996/05/01",
                                         "2020-05-01",
                                         "02-04-96",
                                         "2015",
                                         "02/05/00",
                                         "05/1990",
                                         "20125/02"))
  expect_error(fix_dates(bad.dates, "some.dates"), "unable to tidy a date")
})

test_that("Handle empty dates correctly", {
  really.bad.dataframe <- data.frame(id = seq(2),
                                     some.dates = c(NA, ""))
  fixed.df <- fix_dates(really.bad.dataframe, "some.dates")

  expected.df <- data.frame(id = seq(2),
                            some.dates = c(NA, NA))
  expected.df$some.dates <- as.Date(expected.df$some.dates)

  expect_equal(fixed.df, expected.df)
})

test_that("error if unexpected data type", {
  exvector <- c(1, 2, 3)
  expect_error(fix_dates(exvector, "some.dates"),
               "df should be a dataframe object!")

  expect_error(fix_dates(data.frame(), 3),
               "col.names should be a character vector!")
})

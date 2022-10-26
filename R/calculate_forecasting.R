#' Title
#'
#' @param table
#' @param ...
#' @param observation_end_date
#' @param prediction_end_date
#' @param variables_type
#' @param model
#'
#' @return
#' @export
#'
#' @examples
calculate_forecasting <- function(model = "temporal",
                                  table,
                                  observation_end_date = "2008-01-01",
                                  prediction_end_date = "2009-08-01",
                                  variables_type = "day",
                                  ...) {
  model <- model
  table <- table
  observation_end_date <- observation_end_date
  prediction_end_date <- prediction_end_date

  # modeling set
  # str(outcome_cohort_table)
  temptable <- table
  temptable <- dplyr::filter(temptable, cohort_start_date < prediction_end_date)
  # temptable <- data.frame(temptable %>% mutate(year = year(cohort_start_date), week = week(cohort_start_date)) %>% group_by(year, week) %>% summarise(count = n()))
  temptable <- dplyr::select(temptable, cohort_start_date)
  temptable <- dplyr::group_by(temptable, cohort_start_date)
  temptable <- dplyr::mutate(temptable, count = dplyr::n())
  temptable <- dplyr::arrange(temptable, cohort_start_date)
  temptable <- dplyr::distinct(temptable)
  temptable <- base::data.frame(temptable)

  data <- xts::as.xts(temptable$count, order.by = base::as.Date(temptable$cohort_start_date))
  ts <- xts::apply.weekly(data, sum)

  # plot(ts)

  ts.df <- base::data.frame(as.matrix(ts), date = time(ts))
  # 계절 변수 만들기 체크시
  ts.df <- dplyr::mutate(
    ts.df,
    season = dplyr::case_when(
      data.table::month(date) %in% c(9, 10, 11) ~ "Fall",
      data.table::month(date) %in% c(12, 1, 2) ~ "Winter",
      data.table::month(date) %in% c(3, 4, 5) ~ "Spring",
      TRUE ~ "Summer"
    )
  )
  ts.df$ts <- base::as.numeric(ts.df$ts)

  ts.df$season <- base::as.factor(ts.df$season)

  # 예측 할 날짜에 대해서 NA처리하면 예측함
  ts.df[ts.df$date > observation_end_date, 1] <- NA

  # 함수 분포화를 위한 이름 변경
  ts.df$season2 <- ts.df$season
  ts.df$date2 <- ts.df$date

  # month 변수 만들기
  ts.df$month <- data.table::month(ts.df$date)
  # month 변수 dummy화
  ts.df[paste0("m", 1:12)] <- base::as.data.frame(base::t(base::sapply(ts.df$month, tabulate, 12)))

  # week 변수
  ts.df$week <- data.table::week(ts.df$date)

  # formula 화 입력 변수 선택적으로 하기 위해
  formula_opts <- base::list(
    "day" = ts ~ 1 + f(as.numeric(date), model = "ar1"),
    "day,season" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      f(season, model = "rw2") + f(season2, model = "ar1"),
    "day,season,month" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      f(season, model = "rw2") + f(season2, model = "ar1") +
      m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8 + m9 + m10 + m11 + m12,
    "day,season,week" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      f(season, model = "rw2") + f(season2, model = "ar1") +
      f(week, model = "ar1"),
    "day,season,month,week" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      f(season, model = "rw2") + f(season2, model = "ar1") +
      m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8 + m9 + m10 + m11 + m12 +
      f(week, model = "ar1"),
    "day,month" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8 + m9 + m10 + m11 + m12,
    "day,month,week" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      m1 + m2 + m3 + m4 + m5 + m6 + m7 + m8 + m9 + m10 + m11 + m12 +
      f(week, model = "ar1"),
    "day,week" = ts ~ 1 + f(as.numeric(date), model = "ar1") +
      f(week, model = "ar1")
  )

  # INLA
  i1 <- INLA::inla(formula_opts[variables_type][[1]],
    control.predictor = base::list(compute = TRUE, link = 1),
    verbose = TRUE,
    family = "poisson",
    data = ts.df
  )

  fit1 <- i1$summary.fitted.values
  ts.df$mean.i1 <- fit1$mean
  ts.df$lo.i1 <- fit1$`0.025quant`
  ts.df$up.i1 <- fit1$`0.975quant`

  ts.df$ts <- base::as.vector(ts)

  output <- ts.df

  output
}

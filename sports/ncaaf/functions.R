convert_date <- function(dt) {
    if (!is.Date(dt)) {
        try_dmy <- suppressWarnings(dmy(dt))
        try_mdy <- suppressWarnings(mdy(dt))
        try_ymd <- suppressWarnings(ymd(dt))

        # Set to NA if dates are too far in the future or too far in the past
        try_dmy[year(try_dmy) > year(today()) + 3L | year(try_dmy) < 2005] <- NA
        try_mdy[year(try_mdy) > year(today()) + 3L | year(try_mdy) < 2005] <- NA
        try_ymd[year(try_ymd) > year(today()) + 3L | year(try_ymd) < 2005] <- NA

        try_list <- list(try_dmy, try_mdy, try_ymd)
        try_max <- map_int(try_list, ~sum(!is.na(.x))) %>%
            which.max()

        return(as.Date(try_list[[try_max]]))
    } else {
        return(dt)
    }
}



days_off <- function(df, date, team) {
    temp_table <- df %>%
        filter((team_home == team | team_visitor == team),
               game_date < date,
               year(date) == year(game_date)) %>%
        arrange(desc(game_date)) %>%
        head(1) %>%
        select(game_date)

    return(ifelse(nrow(temp_table) > 0, date - temp_table$game_date - 1, NA))
}



days_on_the_road <- function(df, date, team) {
    temp_table <- df %>%
        filter(team_home == team,
               game_date < date,
               year(date) == year(game_date)) %>%
        arrange(desc(game_date))

    is_first_game <- if_else(nrow(temp_table) == 0, TRUE, FALSE)

    if (is_first_game) {
        temp_table <- df %>%
            filter(team_home == team | team_visitor == team,
                   game_date < date,
                   year(date) == year(game_date)) %>%
            arrange(game_date) %>%
            head(1) %>%
            select(game_date)
    } else {
        temp_table <- temp_table %>%
            head(1) %>%
            select(game_date)
    }

    return(ifelse(nrow(temp_table) > 0, date - temp_table$game_date - 1, NA))
}



last_n_game_avg <- function(df, date, f_team, n, var) {
    stopifnot(n > 0)
    var <- enquo(var)

    temp_table <- df %>%
        filter(team == f_team,
               game_date < date,
               year(date) == year(game_date)) %>%
        arrange(desc(game_date)) %>%
        head(n) %>%
        summarise(temp_value = mean(!!var))

    return(ifelse(nrow(temp_table) > 0 && !is.nan(temp_table$temp_value),
                  temp_table$temp_value, NA))
}



# most_recent_value <- function(df, date, f_team, var, seas) {
#     var <- enquo(var)
#
#     temp_table <- df %>%
#         filter(team == f_team,
#                game_date < date,
#                season == seas) %>%
#         arrange(desc(game_date)) %>%
#         head(1) %>%
#         select(!!var)
#
#     return(ifelse(nrow(temp_table) > 0, temp_table[[1]], NA_real_))
# }



most_recent_value <- function(df, date, f_team, var, seas) {
    var <- enquo(var)
    var_name <- quo_name(var)

    cond <- (!is.na(df[["team"]]) & df[["team"]] == f_team) &
        (!is.na(df[["game_date"]]) & df[["game_date"]] < date) &
        (!is.na(df[["season"]]) & df[["season"]] == seas)

    if (any(cond)) {
        out <- dplyr::arrange(df[cond, ], dplyr::desc(game_date))[[1, var_name]]
    } else {
        out <- NA_real_
    }

    return(out)
}



last_n_weighted <- function(df, date, f_team, n, var, seas) {
    stopifnot(n > 0)
    var <- enquo(var)
    var_name <- quo_name(var)

    cond <- (!is.na(df[["team"]]) & df[["team"]] == f_team) &
        (!is.na(df[["game_date"]]) & df[["game_date"]] < date) &
        (!is.na(df[["season"]]) & df[["season"]] == seas)

    if (any(cond)) {
        out <- dplyr::arrange(df[cond, ], dplyr::desc(game_date))[[var_name]] %>%
            head(n)
        multiplier <- n:(n - length(out) + 1)
        weight <- multiplier * out
        weight_out <- sum(weight, na.rm = TRUE) / n
        weight_out <- if_else(weight_out == 0, NA_real_, weight_out)
    } else {
        weight_out <- NA_real_
    }

    return(weight_out)
}



# last_n_weighted <- function(df, date, f_team, n, var, seas) {
#     stopifnot(n > 0)
#     var <- enquo(var)
#
#     temp_table <- df %>%
#         filter(team == f_team,
#                game_date < date,
#                season == seas) %>%
#         arrange(desc(game_date)) %>%
#         head(n)
#
#     if (nrow(temp_table) > 0) {
#         temp_table <- temp_table %>%
#             mutate(multiplier = n:(n - nrow(temp_table) + 1),
#                    weight = multiplier * !!var)
#
#         weight_out <- sum(temp_table$weight, na.rm = TRUE) / n
#         weight_out <- if_else(weight_out == 0, NA_real_, weight_out)
#
#         return(weight_out)
#
#     } else {
#         return(NA_real_)
#     }
# }

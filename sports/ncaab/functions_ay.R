last_n_avg <- function(x, n) {
  stopifnot(is.numeric(n) && n >= 1 && n <= 20)
  
  n_list <- n:1
  names_list <- stringr::str_c("lag", n_list)
  
  map(n_list, ~dplyr::lag(x, .x)) %>% 
    set_names(names_list) %>% 
    as_tibble() %>% 
    mutate(sum = rowSums(., na.rm = TRUE),
           games_na = rowSums(is.na(.)),
           avg = if_else(games_na < n, sum / (n - games_na), NA_real_)) %>% 
    pull(avg)
}



last_n_weighted <- function(df, var, n, out_name) {
  stopifnot(is.numeric(n) && n >= 1 && n <= 20)
  
  var <- enquo(var)
  var_name <- paste0("lag_var", n:1)
  var_mutate <- map(n:1, ~quo(lag(!!var, !!.x)))
  
  out <- df %>% 
    arrange(team, season, game_date, id) %>% 
    group_by(team, season) %>% 
    mutate(!!!var_mutate) %>% 
    set_names(c(names(df), var_name)) %>% 
    ungroup() %>% 
    select(id, team, game_date, season, starts_with("lag_var"))
  
  # Multiply lagged variables by recency
  lag_cols <- str_detect(names(out), "lag_var")
  out[lag_cols] <- map2_df(out[lag_cols], 1:n, `*`)
  
  # Created weighted variable
  out <- out %>% 
    mutate(weight_out = rowSums(select(., starts_with("lag_var")), na.rm = TRUE) / n,
           weight_out = if_else(weight_out == 0, NA_real_, weight_out)) %>% 
    select(-starts_with("lag_var")) %>% 
    rename({{ out_name }} := weight_out)
  
  return(out)
}



cummean_lagged <- function(x, n = 1L, default = NA, order_by = NULL, ...) {
  out <- dplyr::cummean(x)
  out <- dplyr::lag(out, n = n, default = default, order_by = order_by, ...)
  
  return(out)
}



cummean_lagged_homeaway <- function(x, homeaway, n = 1L, default = NA, order_by = NULL, ...) {
  x[homeaway == 0] <- 0
  out <- dplyr::if_else(cumsum(homeaway) > 0, cumsum(x) / cumsum(homeaway), NA_real_)
  out <- dplyr::lag(out, n = n, default = default, order_by = order_by, ...)
  
  return(out)
}



past_opponents <- function(df, team_input, date_input, season_input) {
  unique(df$team_id_opp[df$team_id == team_input & 
                          df$date < date_input & 
                          df$season == season_input])
}



win_loss_perc <- function(df, return_val = "win-perc", past_vec, date_input, season_input) {
  stopifnot(return_val %in% c("win-perc", "win-loss"))
  
  if (length(past_vec) > 0) {
    win_loss <- df[df$team_id %in% past_vec & 
                     df$date < date_input &
                     df$season == season_input, 
                   c("team_id", "win2", "loss2")]
    
    win_loss <- win_loss[!duplicated(win_loss$team_id), ]
    
    win_loss_total <- colSums(win_loss[-1], na.rm = TRUE)
    win_perc <- unname(win_loss_total[1] / sum(win_loss_total))
  } else {
    win_loss_total <- c(0, 0)
    win_perc <- NA_integer_
  }
  
  if (return_val == "win-perc") {
    return(win_perc)
  } else if (return_val == "win-loss") {
    return(win_loss_total)
  }
}



opponents_record <- function(df, team_input, date_input, season_input, opp_opp = FALSE) {
  past_vec <- past_opponents(df, team_input, date_input, season_input)
  
  if (!opp_opp) {
    win_perc <- win_loss_perc(df, "win-perc", past_vec, date_input, season_input)
  } else {
    past_list <- map(past_vec, ~past_opponents(df, .x, date_input, season_input))
    win_loss_list <- map(past_list, ~win_loss_perc(df, "win-loss", .x, date_input, season_input))
    win_total <- sum(map_dbl(win_loss_list, 1))
    loss_total <- sum(map_dbl(win_loss_list, 2))
    
    win_perc <- if_else(win_total + loss_total > 0,
                        win_total / (win_total + loss_total),
                        NA_real_)
  }
  
  return(win_perc)
}



# cummean_lagged <- function(x) {
#   x.lagged <- lag(x, 1)
#   x.lagged <- x.lagged[-1]
#   c.mean <- cummean(x.lagged)
#   c.mean <- c(NA, c.mean)
#   return(c.mean)
# }



rollmean_lagged <- function(x, w.size) {
  x.lagged <- lag(x, 1)
  x.lagged <- x.lagged[-1]
  r.mean <- rollmean(x.lagged, k = w.size, na.pad = TRUE, align = "right")
  r.mean <- c(NA, r.mean)
  return(r.mean)
}

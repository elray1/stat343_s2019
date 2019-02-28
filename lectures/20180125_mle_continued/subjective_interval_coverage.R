library(tidyverse)

si_res <- read_csv("http://www.evanlray.com/stat343_s2018/lectures/20180125_mle_continued/subjective_interval_results.csv")

si_truth <- data.frame(
  Q_num = seq_len(10),
  answer = c(100, 164, 1971, 26.3, 12.45, 28, 49000, 850, 1963, 85)
)

si_res <- si_res[, -8]

si_res <- si_res %>%
  left_join(si_truth, by = "Q_num") %>%
  mutate(
    c50 = lb_50 <= answer & ub_50 >= answer,
    c90 = lb_90 <= answer & ub_90 >= answer
  )

si_res$c50[is.na(si_res$c50)] <- FALSE
si_res$c90[is.na(si_res$c90)] <- FALSE
si_res <- si_res %>%
  mutate(
    m_50 = (lb_50 + ub_50)/2,
    m_90 = (lb_90 + ub_90)/2,
  )

si_res %>%
  group_by(Name) %>%
  summarize(
    prop_correct_50 = mean(c50),
    prop_correct_90 = mean(c90)) %>%
  mutate(
    total_dist = (.5 - prop_correct_50) + (.9 - prop_correct_90)
  )

ggplot(data = si_res %>% filter(Q_num %in% 6:10)) +
  geom_errorbarh(mapping = aes(x = m_90, xmin = lb_90, xmax = ub_90, y = Name, color = c90)) +
  geom_errorbarh(mapping = aes(x = m_50, xmin = lb_50, xmax = ub_50, y = Name, color = c50)) +
  geom_vline(mapping = aes(xintercept = answer)) +
  facet_wrap( ~ Q_num, scales = "free")

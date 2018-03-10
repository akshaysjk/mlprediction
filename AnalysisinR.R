air_stores <- read_csv("~/Downloads/finalproject/air_store_info.csv")
air_visits <- read_csv("~/Downloads/finalproject/air_visit_data.csv")
air_reserve <- read_csv("~/Downloads/finalproject/air_reserve.csv")
hpg_reserve <- read_csv("~/Downloads/finalproject/hpg_reserve.csv")
hpg_stores <- read_csv("~/Downloads/finalproject/hpg_store_info.csv")
store_mapping <- read_csv("~/Downloads/finalproject/store_id_relation.csv")
holidays <- read_csv("~/Downloads/finalproject/date_info.csv")
air_prophet <- read_csv("~/Downloads/finalproject/air_visit_data1Res.csv")
head(air_reserve) 
head(hpg_reserve)
head(air_stores)
head(hpg_stores)
head(store_mapping)
head(air_visits)
head(holidays)
library(ggplot2)

#Feature Visualization
p1 <- air_visits %>%
  group_by(visit_date) %>%
  summarise(all_visitors = sum(visitors)) %>%
  ggplot(aes(visit_date,all_visitors)) +
  geom_line(col = "red") +
  labs(x = "Date", y = "All visitors")

p1


p2 <- air_visits %>%
  mutate(wday = wday(visit_date, label = TRUE)) %>%
  group_by(wday) %>%
  summarise(visits = median(visitors)) %>%
  ggplot(aes(wday, visits, fill = wday)) +
  geom_col() +
  theme(legend.position = "none", axis.text.x  = element_text(angle=45, hjust=1, vjust=0.9)) +
  labs(x = "Day of the week", y = "Median visitors")

p2
p3 <- air_visits %>%
  mutate(month = month(visit_date, label = TRUE)) %>%
  group_by(month) %>%
  summarise(visits = median(visitors)) %>%
  ggplot(aes(month, visits, fill = month)) +
  geom_col() +
  theme(legend.position = "none") +
  labs(x = "Month", y = "Median visitors")
p3

air_visits %>%
  filter(visit_date > ymd("2016-04-15") & visit_date < ymd("2016-06-15")) %>%
  group_by(visit_date) %>%
  summarise(all_visitors = sum(visitors)) %>%
  ggplot(aes(visit_date,all_visitors)) +
  geom_line() +
  geom_smooth(method = "loess", color = "red", span = 1/7) +
  labs(x = "Date", y = "All visitors")


#Reservation Data Analysis

visitors_airreserve <- air_reserve %>% mutate(type = "AIR_reservation") %>% 
  group_by(type, visit_date = date(visit_datetime)) %>% 
  summarize(total_visitors = sum(reserve_visitors))

p4 <- ggplot(data = visitors_airreserve, aes(x = visit_date, y = total_visitors)) +
  geom_line(col = "red") +
  labs(x = "Date", y = "# Number of Reservations", title = "No. of Reserved Visitors - AIR restaurants") +
  theme_bw()

p4

visitors_hpgreserve <- hpg_reserve %>% mutate(type = "AIR_reservation") %>% 
  group_by(type, visit_date = date(visit_datetime)) %>% 
  summarize(total_visitors = sum(reserve_visitors))

p5 <- ggplot(data = visitors_hpgreserve, aes(x = visit_date, y = total_visitors)) +
  geom_line(col = "red") +
  labs(x = "Date", y = "# Number of Reservations", title = "No. of Reserved Visitors - HPG restaurants") +
  theme_bw()

p5

visitors_air <- air_visits %>% mutate (type = "AIR_visitors") %>% 
  select (type, visit_date, visitors) %>% group_by(type, visit_date) %>% 
  summarize(total_visitors = sum(visitors))

p6 <- ggplot(data = visitors_air, aes(x = visit_date, y = total_visitors)) +
  geom_line(col = "blue") + 
  labs(x = "Date", y = "Number of Visitors", title = "No. of Visitors - AIR restaurants") +
  theme_bw()

p6


# Store Area and Restaurant Genre analysis

p7 <- air_store %>%
  group_by(air_genre_name) %>%
  count() %>%
  ggplot(aes(reorder(air_genre_name, n, FUN = min), n, fill = air_genre_name)) +
  geom_col() +
  coord_flip() +
  theme(legend.position = "none") +
  labs(x = "Type of cuisine (air_genre_name)", y = "Number of air restaurants")

p7

p8 <- air_store %>%
  group_by(air_area_name) %>%
  count() %>%
  ungroup() %>%
  top_n(20,n) %>%
  ggplot(aes(reorder(air_area_name, n, FUN = min) ,n, fill = air_area_name)) +
  geom_col() +
  theme(legend.position = "none") +
  coord_flip() +
  labs(x = "Top 20 areas (air_area_name)", y = "Number of air restaurants")

p8

p9 <- hpg_store %>%
  group_by(hpg_genre_name) %>%
  count() %>%
  ggplot(aes(reorder(hpg_genre_name, n, FUN = min), n, fill = hpg_genre_name)) +
  geom_col() +
  coord_flip() +
  theme(legend.position = "none") +
  labs(x = "Type of cuisine (hpg_genre_name)", y = "Number of hpg restaurants")
p9

p10 <- hpg_store %>%
  group_by(hpg_area_name) %>%
  count() %>%
  ungroup() %>%
  top_n(20,n) %>%
  ggplot(aes(reorder(hpg_area_name, n, FUN = min) ,n, fill = hpg_area_name)) +
  geom_col() +
  theme(legend.position = "none") +
  coord_flip() +
  labs(x = "Top 20 areas (hpg_area_name)", y = "Number of hpg restaurants")

p10

glimpse(air_visits)
glimpse(holidays)
#Holiday data Analysis
holidaydata <- air_visits %>%
  mutate(calendar_date = visit_date) %>%
  left_join(holidays, by = "calendar_date")


p11 <- holidaydata %>%
  mutate(wday = wday(calendar_date, label = TRUE)) %>%
  group_by(wday, holiday_flg) %>%
  summarise(mean_visitors = mean(visitors)) %>%
  ggplot(aes(wday, mean_visitors, color = holiday_flg)) +
  geom_point(size = 4) +
  theme(legend.position = "none") +
  labs(y = "Average number of visitors")

p11

#ARIMA MODEL
par(mfrow=c(2,1), cex=0.7)
air_visits %>% 
  group_by(visit_date) %>% 
  summarize(visitors = sum(visitors)) %>% 
  plot(type='l', main='Overall Visitors')
glimpse(air_stores)
merged <- air_visits %>% 
  filter(visit_date > '2016-07-01') %>% 
  dplyr::left_join(air_stores, by='air_store_id', how='left')

merged_sum <- merged %>% 
  group_by(visit_date) %>% 
  summarize(visitors = sum(visitors)) 

merged_sum %>% 
  plot(type='l', xlab='Year', main='Cut-off at July 2016')

merged_train <- merged_sum %>% filter(visit_date <='2017-03-01')
merged_test <- merged_sum %>% filter(visit_date >'2017-03-01')


m <- arima(merged_train$visitors, order=c(2,1,2), seasonal= list(order=c(1,1,1), period=7))
y_pred <- forecast::forecast(m, h=80)

par(mfrow=c(1,1), cex=0.7)
plot(ts(merged_sum$visitors), main="ARIMA model predictions, cut off at March 2017")
lines(y_pred$mean, col='red')



dim(air_visits)
summary(air_visits)
library(dplyr)
glimpse(air_prophet)
y <- air_prophet$visitors
y
ds
ds <- air_prophet$visit_date
df <- data.frame(ds,y)
qplot(ds, y, data=df)
library(prophet)

m <- prophet(df,changepoint.prior.scale=0.4, yearly.seasonality=FALSE)
future<- make_future_dataframe(m,periods =60)
tail(future)
forecast <- predict(m, future)
forecast
tail(forecast)
plot(m,forecast)
prophet_plot_components(m, forecast)

p1
p2
p3
p4
p5
p6
p7
p8
p9
p10
p11

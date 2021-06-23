# Week 5 Exercises #

## EX 1 --------------------------------------------------------------

# Create the tibble adult3 composed of all the columns except final_weight, 
# capital_gain, capital_loss

adult3 = adult %>% select(-c(final_weight, capital_gain, capital_loss))

## EX 2 --------------------------------------------------------------

# Calculate the average and standard deviation of hours_per_week for every 
# combination of sex and marital status and order the new tibble in decrasing 
# order with respect to the average.

adult3 %>% group_by(sex, marital_status) %>% 
  summarise(avg_hpw = mean(hours_per_week), sd_hpw = sd(hours_per_week)) %>% 
  arrange(avg_hpw %>% desc)

## EX 3 --------------------------------------------------------------

# Illustrate how the frequencies of class depend on age.

adult4 = adult3 %>% group_by(class, age) %>% summarise(counts = length(hours_per_week))
ggplot(adult4, aes(x = age, y = counts, col = class)) + 
  geom_point() + 
  stat_smooth() +
  ggtitle("Empirical distribution of age by class")

## EX 4 --------------------------------------------------------------

# Focus on rows where education is either "Masters" or "Bachelors", and 
# focus on age between 30 and 40 and "Private" workclass.
# Add a new column called "class_binary" that is 1 if class is ">50K" or 0 
# otherwise.
# Calculate the mean of class_binary for every combination of education and 
# age.
# Show with a plot how this mean depends on age by education.

adult5 = adult3 %>% 
  filter(education == "Masters" | education == "Bachelors") %>%
  filter(age >= 30, age <= 40, workclass == "Private") %>%
  mutate(class_binary = class == ">50K") %>%
  group_by(education, age) %>%
  summarise(proportion = class_binary %>% mean)

ggplot(adult5, aes(x = age, y = proportion, col = education)) + 
  stat_smooth() + 
  geom_point() + 
  scale_x_continuous(breaks = seq(30, 40, by = 2)) + 
  ylab("proportion over 50k") +
  ggtitle("Proportion over 50k by education")


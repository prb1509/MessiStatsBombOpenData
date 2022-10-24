library(StatsBombR)
library(dplyr)
Comp = FreeCompetitions() %>% filter(competition_id == 11)
Matches = FreeMatches(Comp)
SB_data = StatsBombFreeEvents(MatchesDF = Matches, Parallel = T)
SB_data = allclean(SB_data)

#Now we can already save the data in say a .rds format,however, if we wish
#to use something more familiar like a .csv file, we will encounter an error
#due to the fact that some data columns have a nested structure which R 
#in this case will call lists. The exact columns we need to modify or remove are
#"location", "related_events", "pass.end_location", "shot.end_location",
#"carry.end_location", "shot.freeze_frame", "tactics.lineup", and
#"goalkeeper.end_location

#we can check what columns need fixing as follows:
types = sapply(SB_data,class)
for (i in 1:length(names(SB_data))) {
  if (types[i] == "list") {
    cat(names(SB_data)[i],"\n")
  }
}

#for the purpose of this script, we only consider the location columns
#and simply remove the others
SB_data = SB_data %>% select(-location) %>% select(-related_events) %>% 
  select(-pass.end_location) %>% select(-shot.end_location) %>%
  select(-tactics.lineup) %>% select(-carry.end_location) %>%
  select(-shot.freeze_frame) %>% select(-goalkeeper.end_location)

#write to a csv
write.csv(SB_data,"My_SB_Data.csv")
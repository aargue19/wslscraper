library(EloRating)

data = read.csv("C:/Users/gaoan/Desktop/surfelo.csv")

data$Date = paste(data$year, data$month, data$day, sep = "-")
data$date = as.Date(data$Date)

data$year = NULL
data$month = NULL
data$day = NULL

data$intensity[data$intensity == "sr"] = "early"
data$intensity[data$intensity == "er"] = "early"
data$intensity[data$intensity == "rt"] = "early"
data$intensity[data$intensity == "rs"] = "early"
data$intensity[data$intensity == "qf"] = "late"
data$intensity[data$intensity == "sf"] = "late"
data$intensity[data$intensity == "fr"] = "late"

seqcheck(winner =data$winner, loser = data$loser, Date = data$Date)

res <-elo.seq(winner=data$winner, loser=data$loser, Date=data$Date, runcheck =TRUE)

summary(res)
extract_elo(res)
eloplot(res)

all_surfers <-c("Italo Ferreira",
                                 "Gabriel Medina",
                                 "Kolohe Andino",
                                 "Kanoa Igarashi",
                                 "John Florence",
                                 "Owen Wright",
                                 "Jeremy Flores",
                                 "Michel Bourez",
                                 "Leo Fioravanti",
                                 "Frederico Morais",
                                 "Julian Wilson",
                                 "Miguel Tudela",
                                 "Billy Stairmand",
                                 "Hiroto Ohhara",
                                 "Leandro Usuna",
                                 "Leon Glatzer",
                                 "Lucca Mesinas",
                                 "Manuel Selman",
                                 "Ramzi Boukhiam",
                                 "Rio Waida")



myranks <-c(1,2,3,4,5,6,7,8,9,10,11,12)

names(myranks) <-c("Italo Ferreira",
                   "Gabriel Medina",
                   "Kolohe Andino",
                   "Kanoa Igarashi",
                   "John Florence",
                   "Owen Wright",
                   "Jeremy Flores",
                   "Michel Bourez",
                   "Leo Fioravanti",
                   "Frederico Morais",
                   "Julian Wilson",
                   "Miguel Tudela")

startvals <-createstartvalues(ranks = myranks, shape = 0.1)

res2 <-elo.seq(winner =data$winner, loser =data$loser, Date =data$Date, 
               startvalue = startvals$res)

summary(res2)
extract_elo(res2)
eloplot(res2)

table(data$intensity)

# install.packages("Rcpp")

library(Rcpp)

eres <-elo.seq(data$winner, data$loser, data$Date, intensity =data$intensity)

# two list items: 'fight' and 'threat', because these are the two interaction types specified in data$intensity

mykranges <-list(early =c(10,500),late =c(10,500))

ores2 <-optimizek(eres,krange = mykranges,resolution =91)

ores2$best


myk <-list(sr =10, rt =20, rs = 40, qf = 80, sf = 160, fr = 320)

res3 <-elo.seq(winner=data$winner, loser=data$loser, Date=data$Date, 
               intensity=data$intensity, k=myk)

extract_elo(res3)
eloplot(res3)

res4 <-elo.seq(winner=data$winner, loser=data$loser, Date=data$Date,
               startvalue = startvals$res, intensity=data$intensity, k=myk)

extract_elo(res4)
eloplot(res4)

################################################################################

hs = read.csv("C:/Users/gaoan/Desktop/wslscraper/heat_scores.csv")

hs$player_score = as.numeric(hs$player_score)

hs = hs[!is.na(hs$player_score),]

write.csv(hs, "C:/Users/gaoan/Desktop/wslscraper/heat_scores.csv", row.names = F)

summary(hs$player_score)

mu_df = aggregate(hs[, "player_score"], list(hs$player_name), mean)
colnames(mu_df) = c("player_name","mu")
mu_df$mu = round(mu_df$mu, 2)


sd_df = aggregate(hs[, "player_score"], list(hs$player_name), sd)
colnames(sd_df) = c("player_name","sd")
sd_df$sd = round(sd_df$sd, 2)


str(hs)

hs_avg = hs[, c("player_name","player_score")]


p_means = aggregate(hs_avg$player_score, list(hs_avg$player_name), FUN=mean)

p_means$x = round(p_means$x, 2)
colnames(p_means) = c("name","avg")

p_means = p_means[p_means$name %in% all_surfers, ]




hs1 = merge(hs,mu_df, by="player_name", all.x=T)

hs2 = merge(hs1,sd_df, by="player_name", all.x=T)

write.csv(hs2, "C:/Users/gaoan/Desktop/wslscraper/heat_scores_mu_sd.csv", row.names = F)

h2h$evt_ht = paste(h2h$event_name, h2h$heat_name, sep="_")

date_seq = seq(as.Date("2013/01/29"), by = "day", length.out = 6000)



#CREATE ELORATING DF
date_counter = 1
big_df = data.frame()
for(i in unique(h2h$evt_ht)){
    
  temp_df = h2h[h2h$evt_ht == i,]
  
  #print(temp_df)
  
  winning_score = max(temp_df$player_score)
  
  #print(winning_score)
  
  #print(max(temp_df$player_score))

  #print(rownames(temp_df[match(winning_score,temp_df$player_score),]))
  
  if(temp_df$player_score[1] == temp_df$player_score[2]){
    winner = temp_df$player_name[1]
    loser = temp_df$player_name[2]
    draw=TRUE
  }
  
  if(temp_df$player_score[1] != temp_df$player_score[2]){
  winner = temp_df$player_name[temp_df$player_score == winning_score]
  loser = temp_df$player_name[temp_df$player_score != winning_score]
  draw=FALSE
  }
  
  temp_df_to_add = data.frame(Date = date_seq[date_counter], winner= winner, loser = loser, draw = draw)
  
  big_df = rbind(big_df, temp_df_to_add)
  
  date_counter =  date_counter + 1
    
}

library(EloRating)

seqcheck(winner =big_df$winner, loser = big_df$loser, Date = big_df$Date)

#only one observation for these guys so remove them:
#Alex Gray, Barron Mamiya, Billy Kemper, Brent Dorrington, Cahill Bell-Warren, Carl Wright, Carlos Munoz, Dale Staples, David Delroy-Carr, Dillon Perillo, Dylan Lightfoot, Dylan Moffat, Finn McGill, Francisco Alves, Garrett Parkes, Gavin Beschen, Glyndyn Ringrose, Gustavo Fernandes, Heitor Alves, Hira Teriinatoofa, Imaikalani deVault, Inia Nakalevu, Isei Tokovou, Jack Perry, Jackson Baker, Jamie O'Brien, Jocelyn Poulou, Joe Van Dijk, Joel Centeio, Joshua Moniz, Kahea Hart, Kalani Chapman, Krystian Kymerson, Lucas Silveira, Makai McNamara, Marco Fernandez, Marco Mignot, Marcus Hickman, Mateia Hiquily, Mateus Herdy, Messias Felix, Mikey McDonagh, Nathan Yeomans, Nic von Rupp, Olamana Eleogram, Perth Standlick, Ramzi Boukhiam, Rio Waida, Shane Dorian, Slade Prestwich, Steven Sawyer, Tim Stevenson, Timothee Bisso

one_obs_players = c("Alex Gray", "Barron Mamiya", "Billy Kemper", "Brent Dorrington", "Cahill Bell-Warren", 
"Carl Wright", "Carlos Munoz", "Dale Staples", "David Delroy-Carr", "Dillon Perillo", "Dylan Lightfoot", 
"Dylan Moffat", "Finn McGill", "Francisco Alves", "Garrett Parkes", "Gavin Beschen", "Glyndyn Ringrose",
"Gustavo Fernandes", "Heitor Alves", "Hira Teriinatoofa", "Imaikalani deVault", "Inia Nakalevu", 
"Isei Tokovou", "Jack Perry", "Jackson Baker", "Jamie O'Brien", "Jocelyn Poulou", "Joe Van Dijk", 
"Joel Centeio", "Joshua Moniz", "Kahea Hart", "Kalani Chapman", "Krystian Kymerson", "Lucas Silveira",
"Makai McNamara", "Marco Fernandez", "Marco Mignot", "Marcus Hickman", "Mateia Hiquily", "Mateus Herdy", 
"Messias Felix", "Mikey McDonagh", "Nathan Yeomans", "Nic von Rupp", "Olamana Eleogram", "Perth Standlick",
"Ramzi Boukhiam", "Rio Waida", "Shane Dorian", "Slade Prestwich", "Steven Sawyer", "Tim Stevenson", 
"Timothee Bisso", "Granger Larsen")

'%!in%' <- Negate('%in%')

xdata = big_df[big_df$winner %!in% one_obs_players,]
xdata = big_df[big_df$loser %!in% one_obs_players,]

seqcheck(winner =xdata$winner, loser = xdata$loser, Date = xdata$Date)


res <-elo.seq(winner=xdata$winner, loser=xdata$loser, Date=xdata$Date, draw = xdata$draw, runcheck =TRUE)

summary(res)
extract_elo(res)
eloplot(res)


rankings_2012 = read.csv("C:/Users/gaoan/Desktop/wslscraper/rankings_2012.csv")

newnames <- sapply(strsplit(rankings_2012$Name, split=", "),function(x) 
{paste(rev(x),collapse=" ")})

rankings_2012$full_name = sub("(\\w+),(\\w+)","\\2 \\1", rankings_2012$Name, perl=T)

colnames(rankings_2012)[1] = "rank"

rankings_2012.subset = rankings_2012[,c("rank","full_name")]

wl = c(xdata$winner, xdata$loser)

wl = unique(wl)

library(stringr)

str_trim(rankings_2012.subset$full_name)

rankings_2012.subset$full_name[13] = "C.J. Hobgood"

rankings_2012.subset$full_name %in% wl

rankings_2012.subset$full_name = str_trim(rankings_2012.subset$full_name)

rankings_2012.subset$full_name[rankings_2012.subset$full_name %!in% wl]

rankings_2012.subset = rankings_2012.subset[rankings_2012.subset$full_name %!in% c("John Florence John", "De Adriano Souza", "Heitor Alves", "Fredrick Patacchia", "John Florence John", "De Adriano Souza", "Heitor Alves", "Fredrick Patacchia", "Taylor Knox"),]

full_ranks = rankings_2012.subset

for(name in wl){
  if(name %!in% rankings_2012.subset$full_name){
    full_ranks = rbind(full_ranks, data.frame(rank=37, full_name = name))
  }
}

myranks = full_ranks$rank

names(myranks) = full_ranks$full_name

startvals <-createstartvalues(ranks =myranks,shape =0.1)

res2 <-elo.seq(winner=xdata$winner, loser=xdata$loser, 
               Date=xdata$Date, draw = xdata$draw, 
               startvalue = startvals$res, runcheck =TRUE)

summary(res2)
elo_df = as.data.frame(extract_elo(res2))
colnames(elo_df)[1] = "elo_rating"
elo_df$name = rownames(elo_df)
elo_df$name[elo_df$name == "John John Florence"] = "John Florence"

top_names = all_surfers[all_surfers %in% elo_df$name]

edf = data.frame(name = top_names)
edf = merge(edf, elo_df, by="name")
edf = edf[!duplicated(edf),]

eloplot(res2)

rating_a
rating_b



P(A) = 1/(1+10^400) 


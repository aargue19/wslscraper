#loop through each heat based on round/heat combo variable and find highest score

import pandas as pd

# colnames = ['event_name', 'heat_name', 'player_number', 'player_name', 'player_score','mu','sd']

# df = pd.read_csv("heat_scores_mu_sd.csv", names=colnames)

from trueskill import Rating
from trueskill import quality
from trueskill import rate_1vs1
from trueskill import rate



john = Rating(mu=14.62, sigma=3.46)
jordy = Rating(mu=13.26, sigma=3.4)
josh = Rating(mu=12.09, sigma=3.16)

p1 = [john]
p2 = [jordy]
p3 = [josh]

# (new_john,), (new_jordy,), (new_josh,) = rate([p1, p2, p3], ranks=[1, 2, 3])

print(quality([p1, p2, p3]))

# print(new_john)
# print(new_jordy)
# print(new_josh)

from math import sqrt
from trueskill import BETA
from trueskill.backends import cdf

def win_probability(player_rating, opponent_rating):
    delta_mu = player_rating.mu - opponent_rating.mu
    denom = sqrt(2 * (BETA * BETA) + pow(player_rating.sigma, 2) + pow(opponent_rating.sigma, 2))
    return cdf(delta_mu / denom)

print(win_probability(john, jordy))
print(win_probability(jordy, john))


# print('{:.1%} chance to draw'.format(rate_1vs1(john, jordy)))

# print(df.head)


#create fake dates for heats

# import pandas as pd
# from datetime import datetime

# datelist = pd.date_range(datetime.today(), periods=9107).to_pydatetime().tolist()

# for date in datelist:
#     print(date.strftime("%Y-%m-%d"))
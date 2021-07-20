from random import randint
from multi_elo import EloPlayer, calc_elo

# Generate players with random ELO.
# It can be a list of any elements having the `place` and `elo` properties.
elo_players = [EloPlayer(place=place, elo=randint(1200, 1800))
               for place in range(1, 5)]



count =0

print('Original ELO scores:')
for i, player in enumerate(elo_players, start=1):
    print(f'{i}: #{player.place} ({player.elo})')

# Set the K factor (optional)
k_factor = 16

# Calculate new ELO scores
new_elos = calc_elo(elo_players, k_factor)

print('\nNew ELO scores:')
for i, new_elo in enumerate(new_elos, start=1):
    print(f'{i}: {new_elo}')




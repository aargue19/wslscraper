import re
import pandas as pd
import time
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By

chrome_options = Options()
chrome_options.add_argument("user-agent=Mozilla/5.0 (Windows Phone 10.0; Android 4.2.1; Microsoft; Lumia 640 XL LTE) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Mobile Safari/537.36 Edge/12.10166")
chrome_options.add_argument('--disable-blink-features=AutomationControlled')
chrome_options.add_argument('no-sandbox')
chrome_options.add_argument("user-data-dir=C://Users/gaoan/AppData/Local/Google/Chrome/User Data")
driver = webdriver.Chrome(options=chrome_options)

#cycle through all rounds and get individual heat details
colnames = ['links']
round_links_df = pd.read_csv('round_id_links.csv', names=colnames)
all_rounds = round_links_df.links.tolist()

round_counter = 0

for rnd in all_rounds:
    url = rnd
    print(f"checking {url}")
    driver.get(url)
    time.sleep(5)
    
                                                                                                      
    event_name = re.findall(r"(?<=events/)(.*)(?=/results)", rnd)[0]

    heat_htms = []
    heat_elems = driver.find_elements_by_xpath("//div[@class='hot-heat__athletes hot-heat__athletes-num-athletes-3']")
    surfer_count = 3

    print(f"searching for 3s - there are {len(heat_elems)} found")

    if len(heat_elems) > 0:
        
        for elem in heat_elems:
            heat_htms.append(elem.get_attribute('innerHTML'))
        
        round_counter += 1
        heat_counter = 0

        for elem in heat_htms:
            heat_counter += 1
            round_name = f"round_{round_counter}_heat_{heat_counter}" 
            names = []
            scores = []
            surfers = []
            event_list = []
            for i in range(3):
                names.append(re.findall(r'<div class="hot-heat-athlete__name hot-heat-athlete__name--full">(.*?)</div>', str((elem)))[i])
                scores.append(re.findall(r'<div class="hot-heat-athlete__score">(.*?)</div>', str((elem)))[i])
                surfers.append(surfer_count)
                event_list.append(event_name)

            print(names)
            print(scores)

            df = pd.DataFrame(data={"event": event_name, "round": round_name, "surfer_num": surfers, "name": names, "score": scores})
            df.to_csv("./heat_scores.csv", mode='a',sep=',',index=False, header = False)

    print(f"searching for 2s - there are {len(heat_elems)} found")        
    
    if len(heat_elems) == 0:
                                                                                                          
        heat_htms = []
        heat_elems = driver.find_elements_by_xpath("//div[@class='hot-heat__athletes hot-heat__athletes-num-athletes-2']")

        round_counter += 1    
        heat_counter = 0
        surfer_count = 2

        for elem in heat_elems:
            heat_htms.append(elem.get_attribute('innerHTML'))

        for elem in heat_htms:
            heat_counter += 1
            round_name = f"round_{round_counter}_heat_{heat_counter}" 
            names = []
            scores = []
            surfers = []
            event_list = []
            for i in range(2):
                names.append(re.findall(r'<div class="hot-heat-athlete__name hot-heat-athlete__name--full">(.*?)</div>', str((elem)))[i])
                scores.append(re.findall(r'<div class="hot-heat-athlete__score">(.*?)</div>', str((elem)))[i])
                surfers.append(surfer_count)
                event_list.append(event_name)

            print(names)
            print(scores)

            df = pd.DataFrame(data={"event": event_name, "round": round_name, "surfer_num": surfers, "name": names, "score": scores})
            df.to_csv("./heat_scores.csv", mode='a',sep=',',index=False, header = False)



# print(heat_htms[0])
# print(raw_txt.strip())
# print("\n")
# print("##############")



# cycle through events and get round ids
# colnames = ['links']
# event_links_df = pd.read_csv('event_links_2013-2021.csv', names=colnames)
# all_events = event_links_df.links.tolist()
# only_round_list = []
# for evt_lnk in all_events:
#     time.sleep(5)
#     print(f"finding round ids for {evt_lnk}")    
#     url = f"{evt_lnk}/results"
#     driver.get(url)
#     buncha_links = driver.find_elements_by_class_name("ignore")
#     all_ignore_links = []
#     for elem in buncha_links:
#         all_ignore_links.append(elem.get_attribute("href"))
#     for href in all_ignore_links:
#         if "roundId" in str(href):
#             print(f"{url}?roundId={re.findall(r'(?<=roundId=)(.*)', str(href))[0]}")
#             only_round_list.append(f"{url}?roundId={re.findall(r'(?<=roundId=)(.*)', str(href))[0]}")
#     df = pd.DataFrame(data={"links": only_round_list})
#     df.to_csv("./round_id_links.csv", sep=',',index=False, header = False)


#get event links
# url = "https://www.worldsurfleague.com/events/2021/mct?all=1"
# driver.get(url)
# time.sleep(5)
# event_links = []
# years = ["2008","2009","2010","2011","2012","2013","2014","2015","2016","2017","2018","2019","2020"]
# for yr in years:
#     print(f"finding events for {yr}")
#     url = f"https://www.worldsurfleague.com/events/{yr}/mct?all=1"
#     driver.get(url)
#     time.sleep(5)
#     event_div = driver.find_element_by_xpath("/html/body/div[1]/div/div[2]/div/div/div/div/div/div/div[5]/div/table/tbody/tr[2]/td[2]/div/a")
#     all_event_links = driver.find_elements_by_class_name("event-schedule-details__event-name")
#     for elem in all_event_links:
#         if elem is not None:
#             event_links.append(elem.get_attribute("href"))
#         print(event_links)
#     df = pd.DataFrame(data={"links": event_links})
#     df.to_csv("./mycsv.csv", sep=',',index=False, header = False)
    
#get link to first round as starting point to access other round ids
# url = "https://www.worldsurfleague.com/events/2021/mct/3616/billabong-pipe-masters-presented-by-hydro-flask/results"
# driver.get(url)
# time.sleep(5)
# round_div = driver.find_element_by_xpath("/html/body/div[1]/div/div[2]/div/div/div[2]/div/div[2]/div/div/div[3]/div/div/div/div[1]/div[5]/div/div[2]/div/div/div/div/div/div[1]/a")
# link_to_round = round_div.get_attribute("href")
# print(link_to_round)
# print(link_to_round.text)

# print all heats for a round
# for i in range(1,50): 
#     try:
#         info_div = driver.find_element_by_xpath(f"/html/body/div[1]/div/div[2]/div/div/div[2]/div/div[2]/div/div/div[3]/div/div/div/div[1]/div[5]/div/div[3]/div/div/div[2]/div[{i}]/div/div[1]")
#         print(info_div.text)
#         print("\n")
#     except Exception as e:
#         print("no more heats")
        
driver.close()
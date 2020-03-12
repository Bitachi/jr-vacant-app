# coding: UTF-8
import lxml
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import re
import time
#import twitter
import requests
import datetime
import sys


def send_message(message, token):
    apiurl = 'https://notify-api.line.me/api/notify'
    headers = {'Authorization' : 'Bearer ' + token}
    payload = {'message' : message}
    r = requests.post(apiurl, headers=headers, params=payload)


if __name__ == '__main__':
    args = [0] * 8
    args = sys.argv
    month = args[1]
    day = args[2]
    hour = args[3]
    minute = args[4]
    train = args[5]
    dep_stn = args[6]
    arr_stn = args[7]
        #ユーザのトークン設定
    my_token = args[8]
    #プログラム動作開始を通知
    send_message("Started Working", my_token)

    #h = 1
    #while h == 1:



    # URL関連
    top_url = "http://www.jr.cyberstation.ne.jp/index.html"
    url = "http://www.jr.cyberstation.ne.jp/vacancy/Vacancy.html"
    dt1 = datetime.datetime.now()
    dt2 = datetime.datetime(year=dt1.year, month=dt1.month, day=dt1.day, hour=22, minute=30)
    # ヘッドレスモードを設定
    options = Options()
    options.add_argument('--headless')


    #ローカルの場合
    driver_path = "/Users/takamigo/simple_web_crawlers/chromedriver"
    #デプロイする場合
    #driver_path = "/app/.chromedriver/bin/chromedriver"

    # Chromeを起動
    driver = webdriver.Chrome(executable_path=driver_path, options=options)

    # 一度トップページに行きCookieを取得
    driver.get(url)
    driver.get_cookies()

    driver.find_element_by_id("month").send_keys(month)
    driver.find_element_by_id("day").send_keys(day)
    driver.find_element_by_id("hour").send_keys(hour)
    driver.find_element_by_id("minute").send_keys(minute)
    driver.find_element_by_id("train").send_keys(train)
    driver.find_element_by_id("dep_stn").send_keys(dep_stn)
    driver.find_element_by_id("arr_stn").send_keys(arr_stn)
    driver.find_element_by_name("search").click()
    #driver.get(url)

    # soupオブジェクトを作成
    soup = BeautifulSoup(driver.page_source, "lxml")
    table = soup.find_all("td")
    pattern1 = ".*[0-9]{2}:[0-9]{2}.*"
    pattern2 = ".*×.*"
    pattern3 = ".*△.*"
    pattern4 = '.*○.*'
    i=0
    # タイトルリストを取得して表示
    for td in table:
        i+=1
        repatter2 = re.compile(pattern2)
        result2 = repatter2.match(str(td))
        repatter3 = re.compile(pattern3)
        result3 = repatter3.match(str(td))
        repatter4 = re.compile(pattern4)
        result4 = repatter4.match(str(td))
        if result2 or result3 or result4:
            repatter1 = re.compile(pattern1)
            result1 = repatter1.match(str(table[i-2]))
            if result1:
                #print(dt1)
                #print(table[i-4])
                #print(table[i-3])
                #print(table[i-2])
                #print(td)
                if result3 or result4:
                    message = str(month)+"/"+str(day)+"空席あり\n"+str(table[i-4])+"\n"+str(table[i-3])+"\n"+str(table[i-2])+"\n"+str(td)+"\nhttps://www7.eki-net.com/mp/p/(S(g2bbe2swhnqjn3rwt3jtf0i5))/spmember/wb/SMLogin/Login?t=..%2f..%2f..%2fspmember%2fwb%2fSMTop%2fTop2?src=estop_b"
                    send_message(message, my_token)

    driver.close()
    time.sleep(10)
    #h += 1
    #if dt1<dt2:
    #    time.sleep(10)
    #    if dt1.minute == 00 and (dt1.second >= 00 and dt1.second < 20):
    #        message = "I'm working."
    #        send_message(message, my_token)
    #else:
    #    time.sleep(60*60*8)

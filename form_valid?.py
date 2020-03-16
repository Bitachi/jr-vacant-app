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

if __name__ == '__main__':

    args = sys.argv

    month = args[1]
    day = args[2]
    hour = args[3]
    minute = args[4]
    train = args[5]
    dep_stn = args[6]
    arr_stn = args[7]
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
    driver.close()
    pattern1 = '.*発時刻</td>'
    i=0
    # タイトルリストを取得して表示
    for td in table:
        repatter1 = re.compile(pattern1)
        result1 = repatter1.match(str(td))

        if result1:
            i += 1
            print (1)
            break
    if i == 0:
        print (0)

from webbrowser import Chrome
import pandas as pd
import time
################################################################
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import Select
from selenium.webdriver import ActionChains
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import pyautogui as piui

################################################################
arquivo = "python/fluig.xlsx"
fluig = "https://federacaonacional130419.fluig.cloudtotvs.com.br/portal/p/1/wgCadastroAdmFinanceira"
df = pd.read_excel(arquivo)

driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()))
driver.get(fluig)

#Chrome = webdriver.Chrome(executable_path='chromedriver.exe')
#Chrome.get(fluig)

time.sleep(30)



usuario = Chrome.find_element(By.XPATH, '//*[@id="identifierId"]')
usuario.send_keys("admin" + Keys.ENTER)

time.sleep(30)

senha = Chrome.find_element(By.XPATH, '//*[@id="password"]/div[1]/div/div[1]/input')
senha.send_keys("@paeJc@021005" + Keys.ENTER)
time.sleep(30)
time.sleep(2)
piui.click(x=1006, y=447)
time.sleep(2)

for index, row in df.iterrows():
    print("index: " + str(index) + " Validacao do nome" + str(row["Email"]))
    piui.click(x=196, y=707)
    time.sleep(2)
    # print(piui.position())
    email = Chrome.find_element(
    By.XPATH, '//*[@id="ecm-user-form"]/div/div[1]/input')
    email.send_keys(row["Email"])

    login = Chrome.find_element(By.XPATH, '//*[@id="login"]')
    login.send_keys(str(row["CNPJ"]).zfill(14))

    matricula = Chrome.find_element(By.XPATH, '//*[@id="userCode"]')
    matricula.send_keys(str(row["CNPJ"]).zfill(14))

    senha = Chrome.find_element(By.XPATH, '//*[@id="password"]')
    senha.send_keys(row["senha"])

    confirmacao = Chrome.find_element(By.XPATH, '//*[@id="passwordConfirm"]')
    confirmacao.send_keys(row["confirmacao"])

    matricula1 = Chrome.find_element(By.XPATH, '//*[@id="idpId"]')
    matricula1.send_keys(str(row["CNPJ"]).zfill(14))

    nome = Chrome.find_element(By.XPATH, '//*[@id="nome"]')
    nome.send_keys(row["Fantasia"])

    sobrenome = Chrome.find_element(By.XPATH, '//*[@id="sobrenome"]')
    sobrenome.send_keys(row["Estado"])
    time.sleep(1)

   # salva = Chrome.find_element(By.XPATH, '//*[@id="panel-button-wcmid10-0"]').click()

    print(str(row["CNPJ"]).zfill(14))

    Chrome.quit


from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

driver = webdriver.Chrome()

csv_file = open('kingsboro_cc.csv', 'w')
writer = csv.writer(csv_file)
writer.writerow(['name', 'department', 'overall_score', 'difficulty_score', 'grade', 'chili', 'tag_list', 'content'])

driver.get("http://www.ratemyprofessors.com/search.jsp?queryBy=schoolId&schoolName=Kingsborough+Community+College&schoolID=4105&queryoption=TEACHER")

num_ratings = driver.find_element_by_xpath('//span[@class = "professor-count"]').text
button_clicks = int(num_ratings) // 20

button = driver.find_element_by_xpath('//div[@class = "content"]')

for i in range(4): # manually assigned range
	driver.execute_script("arguments[0].click();", button)
	print("professors page button click " + str(i + 1))
	time.sleep(1)

prof_urls = []
profs = driver.find_elements_by_xpath('//div[@class = "result-list"]//a')
for prof in profs:
	if "ShowRatings" in prof.get_attribute("href"):
		num_reviews = prof.find_element_by_xpath('.//span[@class = "info"]').text.split(" ")[0]
		if int(num_reviews) >= 50:
			prof_urls.append(prof.get_attribute("href"))


for url in prof_urls:
	time.sleep(10)
	
	driver.get(url)
	
	last_name = driver.find_element_by_xpath('//span[@class = "plname"]').text + ", "
	first_name = driver.find_element_by_xpath('//span[@class = "pfname"]').text
	name = last_name + first_name

	print(name)
	print(url)

	num_ratings = driver.find_element_by_xpath('//div[@data-table = "rating-filter"]').text.split(" ")[0]
	button_clicks = int(num_ratings) // 20

	button = driver.find_element_by_xpath('//a[@id = "loadMore"]')

	for i in range(button_clicks):
		driver.execute_script("arguments[0].click();", button)
		print("single prof page button click " + str(i + 1))
		time.sleep(1)

	reviews = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[@class != "ad-placement-container"]')
	reviews = reviews[:20]
	# ajax_reviews1 = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[contains(@class, "ajax"]')
	ajax_reviews1 = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[@class = "ajax"]')
	ajax_reviews2 = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[@class = "even ajax"]')

	department = driver.find_element_by_xpath('//div[@class = "result-title"]').text
	department = department.split("\n")[0]

	chili = driver.find_element_by_xpath('//div[@class = "breakdown-section"]//img').get_attribute("src")
	chili = "hot" in chili

	for ind, review in enumerate(reviews):
		print("regular review " + str(ind))
		review_dict = {}

		review2 = review.text.split("\n")
		overall_score = review2[2]
		difficulty_score = review2[4]
		grade = review2[11].split(" ")[2]

		content = review.find_element_by_xpath('.//p[@class = "commentsParagraph"]').text
		
		tag_list = []
		raw_tags = review.find_elements_by_xpath('.//div[@class = "tagbox"]//span')
		for i in range(0, len(raw_tags)):
			tag_list.append(raw_tags[i].text)

		review_dict["name"] = name
		review_dict["department"] = department
		review_dict["overall_score"] = overall_score
		review_dict["difficulty_score"] = difficulty_score
		review_dict["grade"] = grade
		review_dict["chili"] = chili
		review_dict["tag_list"] = tag_list
		review_dict["content"] = content
		writer.writerow(review_dict.values())
		
	for ind, review in enumerate(ajax_reviews1):
		print("ajax1 review " + str(ind))
		review_dict = {}
		review2 = review.text.split("\n")
		overall_score = review2[2]
		difficulty_score = review2[4]
		grade = review2[11].split(" ")[2]

		content = review.find_element_by_xpath('.//p').text
		
		tag_list = []
		raw_tags = review.find_elements_by_xpath('.//div[@class = "tagbox"]//span')
		for i in range(0, len(raw_tags)):
			tag_list.append(raw_tags[i].text)

		review_dict["name"] = name
		review_dict["department"] = department
		review_dict["overall_score"] = overall_score
		review_dict["difficulty_score"] = difficulty_score
		review_dict["grade"] = grade
		review_dict["chili"] = chili
		review_dict["tag_list"] = tag_list
		review_dict["content"] = content
		writer.writerow(review_dict.values())

	for ind, review in enumerate(ajax_reviews2):
		print("ajax2 review " + str(ind))
		review_dict = {}
		review2 = review.text.split("\n")
		overall_score = review2[2]
		difficulty_score = review2[4]
		grade = review2[11].split(" ")[2]

		content = review.find_element_by_xpath('.//p').text
		
		tag_list = []
		raw_tags = review.find_elements_by_xpath('.//div[@class = "tagbox"]//span')
		for i in range(0, len(raw_tags)):
			tag_list.append(raw_tags[i].text)

		review_dict["name"] = name
		review_dict["department"] = department
		review_dict["overall_score"] = overall_score
		review_dict["difficulty_score"] = difficulty_score
		review_dict["grade"] = grade
		review_dict["chili"] = chili
		review_dict["tag_list"] = tag_list
		review_dict["content"] = content
		writer.writerow(review_dict.values())
			
		# except Exception as e:
		# 	print(e)
		# 	driver.close()
		# 	break
driver.close()
	# driver = webdriver.Chrome()



		

	

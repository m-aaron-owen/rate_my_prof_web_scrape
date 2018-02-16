
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time
import csv

# set browser
driver = webdriver.Chrome()

# create file
csv_file = open('kingsboro_cc.csv', 'w')
# create writer
writer = csv.writer(csv_file)
# add key names for dictionary
writer.writerow(['name', 'department', 'overall_score', 'difficulty_score', 'grade', 'chili', 'tag_list', 'content'])

# website to start
driver.get("http://www.ratemyprofessors.com/search.jsp?queryBy=schoolId&schoolName=Kingsborough+Community+College&schoolID=4105&queryoption=TEACHER")

### this isn't actually needed because I manually specify how many times to click the button ###
# need to know how many times to click the button to get list of all profs
num_ratings = driver.find_element_by_xpath('//span[@class = "professor-count"]').text
# each button click adds 20 new reviews
button_clicks = int(num_ratings) // 20
### ###

# initializing button
button = driver.find_element_by_xpath('//div[@class = "content"]')

# having already known the number of clicks needed, I manually told it to click 4 times
for i in range(4): # manually assigned range
	driver.execute_script("arguments[0].click();", button)
	print("professors page button click " + str(i + 1))
	time.sleep(1)

# collecting list of urls where profs have at least 50 reviews
prof_urls = []
# the tag with all the reviews in it
profs = driver.find_elements_by_xpath('//div[@class = "result-list"]//a')
for prof in profs:
	# if there are reviews, then grab the number of them
	if "ShowRatings" in prof.get_attribute("href"):
		num_reviews = prof.find_element_by_xpath('.//span[@class = "info"]').text.split(" ")[0]
		# if the number is >= 50, add it to the list
		if int(num_reviews) >= 50:
			prof_urls.append(prof.get_attribute("href"))

# now that we have the list of urls, we can follow them and scrape the ratings 
for url in prof_urls:
	# wait 10 seconds before visiting the next url
	time.sleep(10)
	
	# initialize the driver as the specific prof's webpage
	driver.get(url)
	
	# getting the prof's name
	last_name = driver.find_element_by_xpath('//span[@class = "plname"]').text + ", "
	first_name = driver.find_element_by_xpath('//span[@class = "pfname"]').text
	name = last_name + first_name

	# printing so that I can keep track of what's being scraped
	print(name)
	print(url)

	# collecting the number of ratings for the prof to know how many times to click the button
	num_ratings = driver.find_element_by_xpath('//div[@data-table = "rating-filter"]').text.split(" ")[0]
	button_clicks = int(num_ratings) // 20

	# initializing the button
	button = driver.find_element_by_xpath('//a[@id = "loadMore"]')

	# clicking the button the desired number of times
	for i in range(button_clicks):
		driver.execute_script("arguments[0].click();", button)
		print("single prof page button click " + str(i + 1))
		time.sleep(1)

	# because ads were placed inside the review tags, I make sure not to grab those
	reviews = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[@class != "ad-placement-container"]')
	
	# first 20 reviews are unaffected by ajax
	reviews = reviews[:20]
	# then the reviews have different tags as either "ajax" or "even ajax"
	ajax_reviews1 = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[@class = "ajax"]')
	ajax_reviews2 = driver.find_elements_by_xpath('//table[@class = "tftable"]//tr[@class = "even ajax"]')

	# getting the department
	department = driver.find_element_by_xpath('//div[@class = "result-title"]').text
	department = department.split("\n")[0]

	# True if the word "hot" is in the attribute
	chili = driver.find_element_by_xpath('//div[@class = "breakdown-section"]//img').get_attribute("src")
	chili = "hot" in chili

	# first looking into the regular (non ajax reviews)
	for ind, review in enumerate(reviews):
		# printing a statement saying which review it's currently scraping
		print("regular review " + str(ind))
		
		# initializing the dict
		review_dict = {}

		# getting scores from the rating box
		review2 = review.text.split("\n")
		overall_score = review2[2]
		difficulty_score = review2[4]
		grade = review2[11].split(" ")[2]

		# getting the text of the review
		content = review.find_element_by_xpath('.//p[@class = "commentsParagraph"]').text
		
		# getting the list of tags
		tag_list = []
		raw_tags = review.find_elements_by_xpath('.//div[@class = "tagbox"]//span')
		for i in range(0, len(raw_tags)):
			tag_list.append(raw_tags[i].text)

		# filling in the dictionary's values
		review_dict["name"] = name
		review_dict["department"] = department
		review_dict["overall_score"] = overall_score
		review_dict["difficulty_score"] = difficulty_score
		review_dict["grade"] = grade
		review_dict["chili"] = chili
		review_dict["tag_list"] = tag_list
		review_dict["content"] = content

		# writing the dict to the csv
		writer.writerow(review_dict.values())
		
	# performing all of the above for ajax reviews1
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

	# performing all of the above for ajax reviews2
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
			
# closing the driver
driver.close()



		

	

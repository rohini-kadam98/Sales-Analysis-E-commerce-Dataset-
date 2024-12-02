# Analysing-E-Commerce-Using-SQL
For this project, I obtained the <a href="https://www.kaggle.com/datasets/benroshan/ecommerce-data">dataset from Kaggle containing sales data from an Indian E-commerce website</a> spanning from April 2018 to March 2019. <br><br>

Below is the entity-relationship diagram that I created using template on MIRO application. <br><br>
<img src="https://miro.medium.com/max/1050/1*7K1z19CMh_P0KJvJHoo1Eg.jpeg" alt="ER diagram">

# Hypothetical Questions & Results
1. The marketing department is running a sales campaign and they target the customer with different sales materials. They categorized customers into groups based on the RFM model. Show the number and percentage for each customer segment as the final result. Order the results by the percentage of customers. <br><br>
<img src="https://miro.medium.com/max/1050/1*4tAFpv01no4Xxy32hX-hUQ.png" alt="Result of query 1">
2. Find the number of orders, customers, cities, and states. <br><br>
<img src="https://miro.medium.com/max/1050/1*gHTr7kMZ8aNe63eMbo7bGQ.png" alt="Result of query 2">
3. Find the top 10 profitable states & cities so that the company can expand its business. Determine the number of products sold and the number of customers in these top 10 profitable states & cities. <br><br>
<img src="https://miro.medium.com/max/1050/1*Xszxeou5ZoUCqAJziQst0g.png" alt="Result of query 4">
4. Determine the number of orders (in the form of a histogram) and sales for different days of the week. <br><br>
<img src="https://miro.medium.com/max/1050/1*EDDVYPQ_158nlyNSkfgFiQ.png" alt="Result of query 6">
5. Check the monthly profitability and monthly quantity sold to see if there are patterns in the dataset. <br><br>
<img src="https://miro.medium.com/max/1050/1*vz2uKi-f6MJ1izhGhmkJnw.png" alt="Result of query 7">
6. Determine the number of times that salespeople hit or failed to hit the sales target for each category. <br><br>
<img src="https://miro.medium.com/max/1050/1*rRcCqIJI1lmtnzJ1VSgG7Q.png" alt="Result of query 8">

# Summary 
For the complete code explanation & analysis, please check out <a href="https://jadangpooiling.medium.com/building-sql-project-with-e-commerce-dataset-from-kaggle-3c678d44fc0a">my Medium article</a>. Below are summary of the analysis.
1. Almost 50% of the customers were loyal customers (spend well and often) and champions (spend well and often, as well as make a recent purchase). The rest of the customers falls within the categories of potential loyalists, hibernating, customers needing attention, at risk, and about to sleep.
2. There are 500 orders and 332 customers from 24 different cities and 19 states from April 2018 to March 2019.
3. The most profitable cities are Pune, followed by Indore, Allahabad, and Delhi. This may be because these areas are more developed (e.g. having a better internet connection and better logistics). 
4. The highest sales happened on Sunday. However, the number of orders is the highest on Monday. This may happen because the customers selected the items they want to order on Sunday, and placed their orders on Monday.
5. Losses occurred from April 2018 to September 2018. Luckily, there was a high profit from October 2018 onwards, followed along with an increase in the quantity sold (although it fluctuates). The total profit was able to cover all the losses it suffered previously. Besides, it also indicates that consumers started to shift toward online shopping.
6. According to the result, the salespeople mostly failed to achieve the target for furniture and clothing target. It is needed to review the target to determine if it is really achievable. Otherwise, more training would be required for the salespeople who are involved in promoting the furniture and clothing.
07. The sellers should avoid selling electronic games and focus more on selling printers and accessories because electronic games led to losses although the quantity of electronic games is higher than that of printers and accessories.

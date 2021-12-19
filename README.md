# Capital-Bikeshare


Now-a-days more and more people are using bike renting services to rent out bikes and use it for
their respective purposes. Some people use to travel to and fro from their workplaces, while some
use it as recreational thing, and few others use these services to rent bikes to stay physically fit
and maintain a healthy lifestyle. The dataset for this project is taken from Capital BikeshareBicycle sharing company.
The primary focus of study in this project was to predict the total no. of bikes being shared daily,
using the input variables. Firstly, I performed some data tidying and transformation techniques
on the data so that the data variables can be fitted better in the models I create. Then I created
multiple data visualizations to explore the data and get better view at the dataset. And Lastly, I
fed the data to the data analysis methods and compared various models to get the best model.

**Data Description**: This dataset consists of 731 records and 16 variables. Variables in the
dataset consist of “instant”- It is basically record number of the data “dteday”- Data type is
“Date” and it consists of dates in the format ”mm/dd/yyyy” , “season”- consists of four unique
numerical values,(1:winter, 2:spring, 3:summer, 4:fall), yr- Consists binary values (0: 2011, 1:
2012), mnth- It consists of numerical values for all months( 1 to 12), holiday- consists of binary
values for holidays (1: holiday or 0:not), weekday- It consists of numerical values for all
weekdays(0-6), where 0 being Sunday, and 6 is Saturday, workingday – consists binary values, if
day is neither weekend nor holiday is 1, otherwise is 0, weathersit- Consists of four numerical
values with their associated meanings(1: Clear, Few clouds, Partly cloudy, Partly cloudy - 2: Mist+ Cloudy, Mist + Broken clouds, Mist + Few clouds, Mist - 3: Light Snow, Light Rain +Thunderstorm + Scattered clouds, Light Rain + Scattered clouds, 4: Heavy Rain + Ice Pallets +Thunderstorm + Mist, Snow + Fog), temp- Normalized temperature in Celsius, atemp- Normalizedfeeling temperature in Celsius, hum- Normalized humidity, windspeed- Normalized wind speed,casual- count of casual users, registered- count of registered users, cnt- count of total rentalbikes including both casual and registered. Categorical variables in the dataset are- season, yr,mnth, holiday, weekday, workingday, weathersit. Continuous variables in the dataset are- temp,atemp, hum, windspeed, casual, registered, cnt.

**Data Inspection and preparation of analysis dataset**: First the dataset was checked for
any NA values it may contain and there were no na values present in the data. Converted all the
categorical variables into the factor class as they were present in different classes initially.
Following that I performed one hot encoding method for all the categorical variables so that they
get converted to multiple variables with binary values, can be fitted better in the model.

**Exploratory Analysis and Research Questions:**
Exploratory data analysis gives some insights about the data variables in the dataset.


Can a Model be built that can predict the total no. of bikes rented?
What are the important variables contributing to model accuracy?

**Methods and software used**:
The Output variable I have chosen is Cnt which has a continuous datatype. Since the response
variable is continuous I have used Regression Methods to analyse the data. I have used R studio
to develop the models that would help to predict (cnt).

**1.)** Initially, I had built the linear regression model on the complete data using all the features.
Using complete data, and the response variable being the total count(cnt).
Then after this I used the Best Subsets selection Technique. For this the data was split into train
and test data. train data consisted of 500 records, while test data consisted of the remaining
records other than train data. Linear model was created using train data. Then by using the best
subsets selection method on all the variables in the train data, the algorithm chose the 1 subset
for each 27 variables. The least MSE found was associated with the model containing 23 variables.

I considered the AdjustedRsq vs Number of Variables plot to select the best
subset. So, a 19 Variable model was selected according to that. Then, RMSE and AdjustedRsq
values for some models with lesser variables were tried. But, model with 19 variables had
was found to be an appropriate one. Model Summary of 19 variable model had some
variables having p-value more than 0.05, so those were removed and again another model
was made having only 13 variables.
Summary for a model with 13 variables has adj rsq value- 0.8513, and RSE: 738.8.

**2.)** Next I tried using a random forest model for regression. Used the same Train and test data split made for the linear regression. Taking
all the variables in the train data, a Random forest model was created.No. of trees
created were 500 and the % of variance explained was found to be 88.47%. No. of
variables tried for each split were 11.

**Conclusions:**
To answer the research questions the model can be built using both models but the rms for random
forest is better than rmse for linear regression model. The important features from the var imp plot are
temp, yr _1, hum, season _1, yr 0. Temp seems to be the most variable. The instant variable and dteday
variable was initially inputted in the model but later it was found that these variables were responsible
to hinder the accuracy of the model. And even after best subset p value for some features are greater
than 0.05 which I had to use remove manually.
